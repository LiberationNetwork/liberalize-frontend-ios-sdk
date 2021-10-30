//
//  GeneralVM.swift
//  libralizetest
//
//  Created by Libralize on 05/10/2021.
//

import Foundation
import Liberalize_Frontend_iOS_SDK

class GeneralVM: ViewModel {

    private var bindCardComponent: ((Bool) -> Void)?
    private var bindPaymentMethods: (([PaymentMethod]) -> Void)?

    private var hideCard = true {
        didSet {
            bindCardComponent?(hideCard)
        }
    }

    private var paymentMethods: [PaymentMethod] = [] {
        didSet {
            bindPaymentMethods?(paymentMethods)
        }
    }

    func getPaymentMethods() {
        loading = true
        error = nil
        provider.getSupportedMethod { [weak self] error, methods in
            self?.loading = false
            self?.paymentMethods = methods?.filter { !$0.isCard } ?? []
            self?.hideCard = methods?.filter { $0.isCard }.isEmpty ?? true
            self?.error = ErrorResponse(message: error?.message, code: error?.code)
        }
    }
    
    func bindCardComponent(_ callback: ((Bool) -> Void)?) {
        self.bindCardComponent = callback
    }
    
    func bindPaymentMethods(_ callback: (([PaymentMethod]) -> Void)?) {
        self.bindPaymentMethods = callback
    }
}
