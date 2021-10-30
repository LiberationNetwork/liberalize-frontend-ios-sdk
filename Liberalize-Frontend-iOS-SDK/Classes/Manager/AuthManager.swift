//
//  AuthManager.swift
//  libralizetest
//
//  Created by Libralize on 05/10/2021.
//

import Foundation

class AuthManager {
    static let shared = AuthManager()
    
    private var encodedKey: String?
    private var encodedPublicKey: String?
    
    func setKey(key: String) {
        self.encodedKey = "\(key):".base64
    }
    
    var key: String? {
        encodedKey
    }
    
    func setPublicKey(key: String) {
        encodedPublicKey = "\(key):".base64
    }
    
    var publicKey: String? {
        encodedPublicKey
    }
}
