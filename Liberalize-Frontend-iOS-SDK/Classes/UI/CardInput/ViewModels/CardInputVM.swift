//
//  CardInputVM.swift
//  libralizetest
//
//  Created by Libralize on 05/10/2021.
//

import Foundation

class CardInputVM: ViewModel {
    
    private var onSuccess: ((CardResponse) -> Void)?
    func bindSubmitCardSuccess(_ callback: @escaping (CardResponse) -> Void) {
        self.onSuccess = callback
    }
    
    func submitCard(holderName: String, cardNumber: String, expiryDate: String, securityCode: String) {
        let expiry = expiryDate.split(separator: "/")
        let month = expiry.first?.trimmingCharacters(in: .whitespaces)
        let year = expiry.last?.trimmingCharacters(in: .whitespaces)
        let card = CardResponse(
            type: "card",
            card: Card(
                number: cardNumber,
                name: holderName,
                expiry: Expiry(
                    month: month,
                    year: year)
            )
        )
        loading = true
        provider.submitCard(card: card) { [weak self] error, response in
            guard let self = self else { return }
            self.loading = false
            if let error = error {
                self.error = error
                return
            }
            if let response = response {
                self.onSuccess?(response)
            }
        }
    }
}
