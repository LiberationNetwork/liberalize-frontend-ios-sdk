//
//  RestfulApi.swift
//  libralizetest
//
//  Created by Libralize on 05/10/2021.
//

import Foundation

public typealias ResponseType<T:Codable> = (ErrorResponse?, T?) -> Void

class ApiProvider {
    
    private let provider = HTTPRequestProvider()
    
    func submitCard(card: CardResponse, completion: @escaping ResponseType<CardResponse>) {
        provider.sendRequest(target: CardTarget.addCard(card: card), completion: completion)
    }
}

enum CardTarget: Target {
    
    case addCard(card: CardResponse)
    
    var baseURL: String {
        return Constant.customerUrl
    }

    var path: String {
        switch self {
        case .addCard:
            return "paymentMethods"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .addCard:
            return .post
        }
    }
    
    var params: [String : Any]? {
        switch self {
        case .addCard(let card):
            return try? card.asDictionary()
        }
    }
}

enum QRTarget: Target {
    
    case getQRCode(qrData: String, source: String, size: Int)
    
    var baseURL: String {
        return Constant.qrUrl
    }
    
    var path: String {
        switch self {
        case .getQRCode:
            return ""
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getQRCode:
            return .get
        }
    }
    
    var params: [String : Any]? {
        switch self {
        case .getQRCode(let qrData, let source, let size):
            var data = [String: Any]()
            if !qrData.isEmpty {
                data["qrData"] = qrData
            }
            if !source.isEmpty {
                data["source"] = source
            }
            data["size"] = size
            return data
        }
    }
}

enum OCBCTarget: Target {
    
    case openOCBC(qrString: String, paymentId: String)
    
    var baseURL: String {
        return Constant.OCBC_SCHEME
    }
    
    var path: String {
        return ""
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var params: [String : Any]? {
        switch self {
        case .openOCBC(let qrString, let paymentId):
            return [
                "version": 3,
                "qrString": qrString,
                "transactionID": paymentId,
                "returnURI": "example://action&shouldOpenInExternalBrowser=true"
            ]
        }
    }
}
