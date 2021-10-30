//
//  Card.swift
//  libralizetest
//
//  Created by Libralize on 30/09/2021.
//

import Foundation

public struct CardResponse: Codable {
    var id: String?
    var posId: String?
    var organizationId: String?
    var type: String?
    public var card: Card?
    var ttl: Int?
    var createdAt: Date?
    var updatedAt: Date?
}

public struct Card: Codable {
    var type: CardType?
    public var number: String?
    public var name: String?
    public var expiry: Expiry?
    public var data: CardData?
}

public struct Expiry: Codable {
    public var month: String?
    public var year: String?
}

public struct CardData: Codable {
    var iin: String?
    var last4: String?
    var scheme: String?
}

enum CardType: String, Codable, CaseIterable {
    case visa
    case visaElectron
    case mastercard
    case maestro
    case americanExpress
    case dinnersClub
    case discovery
    case jcb
}
