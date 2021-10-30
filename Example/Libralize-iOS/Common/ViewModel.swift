//
//  ViewModel.swift
//  libralizetest
//
//  Created by Libralize on 06/10/2021.
//

import Foundation

class ViewModel {
    let provider = ApiProvider()
    
    private var onError: ((ErrorResponse?) -> Void)?
    private var bindLoading: ((Bool) -> Void)?
    
    func onError(_ callback: ((ErrorResponse?) -> Void)?) {
        self.onError = callback
    }
    
    func bindLoading(_ callback: ((Bool) -> Void)?) {
        self.bindLoading = callback
    }
    
    
    var loading = true {
        didSet {
            bindLoading?(loading)
        }
    }
    
    var error: ErrorResponse? {
        didSet {
            onError?(error)
        }
    }
}
