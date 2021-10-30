//
//  PaymentMethod.swift
//  libralizetest
//
//  Created by Libralize on 06/10/2021.
//

import Foundation

public class PaymentMethod: Codable {
    public var accountId: String?
    public var source: String?
    public var image: String?
    public var status: String?
    
    public var isCard: Bool {
        return source == "card"
    }
}
