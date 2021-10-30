//
//  CardUtils.swift
//  Libralize-iOS
//
//  Created by Libralize on 07/10/2021.
//

import Foundation

class CardUtils {
    
    static func detectCardType(startNumbers: String) -> CardType? {
        if startNumbers.starts(with: "4") {
            for startNumber in visaElectronStartNumbers {
                if startNumbers.starts(with: startNumber) {
                    return .visaElectron
                }
            }
            return .visa
        }
        if startNumbers.starts(with: "5") {
            for startNumber in masterCardStartNumbers {
                if startNumbers.starts(with: startNumber) {
                    return .mastercard
                }
            }
        }
        return nil
    }
    
    static func isValidCardNumber(cardNumber: String) -> Bool {
        for type in CardType.allCases {
            if isValidCardNumber(cardType: type, cardNumber: cardNumber) {
                return true
            }
        }
        return false
    }
    
    static func isValidCardNumber(cardType: CardType, cardNumber: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: cardPattern(cardType: cardType), options: .caseInsensitive)
            return regex.matches(
                in: cardNumber,
                options: [],
                range: NSMakeRange(0, cardNumber.count))
                .isEmpty == false
        } catch {
            return false
        }
    }
        
    private static let visaElectronStartNumbers = ["4026", "417500", "4405", "4508", "4844", "4913", "4917"]
    
    private static let masterCardStartNumbers = ["51", "52", "53", "54", "55"]
    
    private static func cardPattern(cardType: CardType) -> String {
        switch (cardType) {
        case .visa: return "^4[0-9]{12}(?:[0-9]{3})?$"
        case .visaElectron: return "^(4026|417500|4508|4844|491(3|7))"
        case .mastercard: return "^5[1-5][0-9]{14}$"
        case .maestro: return "^(5018|5020|5038|6304|6759|676[1-3])"
        case .americanExpress: return "^3[47][0-9]{13}$"
        case .dinnersClub: return "^3(?:0[0-5]|[68][0-9])[0-9]{11}$"
        case .discovery: return "^6(?:011|5[0-9]{2})[0-9]{12}$"
        case .jcb: return "^(?:2131|1800|35\\d{3})\\d{11}$"
        }
    }
}
