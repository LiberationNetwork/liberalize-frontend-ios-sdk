//
//  ApiProvider.swift
//  Libralize-iOS_Example
//
//  Created by Libralize on 12/10/2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation

typealias ResponseType<T:Codable> = (ErrorResponse?, T?) -> Void

class ApiProvider {
    
    private let provider = HTTPRequestProvider()
    
    func createPayment(
        amount: Double,
        currency: String,
        source: String,
        authorize: Bool,
        completion: @escaping ResponseType<PaymentResponse>
    ) {
        provider.sendRequest(
            target: PaymentTarget.createPayment(
                amount: amount,
                currency: currency,
                source: source,
                authorize: authorize),
            completion: completion)
    }
    
    func capturePayment(
        paymentId: String,
        amount: Double,
        completion: @escaping ResponseType<PaymentResponse>
    ) {
        provider.sendRequest(
            target: PaymentTarget.capturePayment(
                paymentId: paymentId,
                amount: amount
            ),
            completion: completion)
    }
    
    func getPayment(paymentId: String, completion: @escaping ResponseType<PaymentResponse>) {
        provider.sendRequest(target: PaymentTarget.getPayment(paymentId: paymentId), completion: completion)
    }
    
    func getSupportedMethod(completion: @escaping ResponseType<[PaymentMethod]>) {
        provider.sendRawRequest(target: PaymentTarget.getSupportedMethods) { error, response in
            // Conver json data from response to expected type
            // Response data:
            //         {
            //            "card": [
            //                {
            //                    "accountId": "8f65c0bc-b511-47bc-9f4f-73793515dbfd",
            //                    "imageUrl": ...,
            //                    "status" ...,
            //                    "source": "card"
            //                }
            //            ],
            //            "grabpay": [
            //                {
            //                    "accountId": "8f65c0bc-b511-47bc-9f4f-73793515dbfd",
            //                    "imageUrl": ...,
            //                    "status" ...,
            //                    "source": "grabpay"
            //                }
            //            ]
            //        }
            //
            // Expected:
            //         [
            //             {
            //                  "accountId": "8f65c0bc-b511-47bc-9f4f-73793515dbfd",
            //                  "imageUrl": ...,
            //                  "status" ...,
            //                  "source": "card"
            //             },
            //              {
            //                  "accountId": "8f65c0bc-b511-47bc-9f4f-73793515dbfd",
            //                  "imageUrl": ...,
            //                  "status" ...,
            //                  "source": "grabpay"
            //              }
            //        ]
            
            if let data = response,
               let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let allValues = Array(json.values)
                let jsonDecoder = JSONDecoder()
                let allPaymentMethods = allValues
                    .compactMap { ($0 as? [Any])?.first }
                    .compactMap { dict -> PaymentMethod? in
                        guard let jsonData = try? JSONSerialization.data(withJSONObject: dict) else {
                            return nil
                        }
                        return try? jsonDecoder.decode(PaymentMethod.self, from: jsonData)
                    }.sorted { first, second in
                        guard let firstSource = first.source, let secondSource = second.source else { return false }
                        return firstSource > secondSource
                    }
                completion(error, allPaymentMethods)
                return
            }
            completion(error, nil)
        }
    }
}

enum PaymentTarget: Target {

    case createPayment(amount: Double, currency: String, source: String, authorize: Bool)
    case capturePayment(paymentId: String, amount: Double)
    case getPayment(paymentId: String)
    case getSupportedMethods

    var baseURL: String {
        return Constant.paymentUrl
    }

    var header: [String : String] {
        var header = defaultHeader
        header["x-lib-pos-type"] = "elements"
        switch self {
        case .getSupportedMethods:
            header["Authorization"] = "Basic \(AuthManager.shared.publicKey ?? "")"
        default:
            break
        }
        return header
    }
    
    var path: String {
        switch self {
        case .createPayment:
            return "payments"
        case .capturePayment(let paymentId, _):
            return "payments/\(paymentId)/captures"
        case .getPayment(let paymentId):
            return "payments/\(paymentId)"
        case .getSupportedMethods:
            return "supported"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .createPayment, .capturePayment:
            return .post
        case .getPayment, .getSupportedMethods:
            return .get
        }
    }

    var params: [String : Any]? {
        switch self {
        case .createPayment(let amount, let currency, let source, let authorize):
            return [
                "amount": amount,
                "currency": currency,
                "source": source,
                "authorize": authorize
            ]
        case .capturePayment(_, let amount):
            return [
                "amount": amount
            ]
        case .getPayment, .getSupportedMethods:
            return nil
        }
    }
}
