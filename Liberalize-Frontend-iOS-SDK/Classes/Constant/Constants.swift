//
//  Constants.swift
//  libralizetest
//
//  Created by Libralize on 05/10/2021.
//

import Foundation

public enum LiberalizeEnv {
    case dev, staging, prod
}

class Constant {
    
    private static let customerDevUrl = "https://customer.api.dev.liberalize.io/"
    private static let customerStagUrl = "https://customer.api.staging.liberalize.io/"
    private static let customerProdUrl = "https://customer.api.liberalize.io/"

    private static let paymentDevUrl = "https://payment.api.dev.liberalize.io/"
    private static let paymentStagUrl = "https://payment.api.staging.liberalize.io/"
    private static let paymentProdUrl = "https://payment.api.liberalize.io/"

    private static let qrDevUrl = "http://qr-element.dev.liberalize.io/"
    private static let qrStagUrl = "https://qr-element.staging.liberalize.io/"
    private static let qrProdUrl = "http://qr-element.liberalize.io/"
    
    static let OCBC_SCHEME = "ocbcpao://readQR"

    static var customerUrl: String {
        switch Liberalize.shared.env {
        case .dev:
            return customerDevUrl
        case .staging:
            return customerStagUrl
        case .prod:
            return customerProdUrl
        }
    }

    static var paymentUrl: String {
        switch Liberalize.shared.env {
        case .dev:
            return paymentDevUrl
        case .staging:
            return paymentStagUrl
        case .prod:
            return paymentProdUrl
        }
    }

    static var qrUrl: String {
        switch Liberalize.shared.env {
        case .dev:
            return qrDevUrl
        case .staging:
            return qrStagUrl
        case .prod:
            return qrProdUrl
        }
    }
}

//ocbcpao://readQR?transactionID=4efa1548-ead3-4e7d-91bc-0f3b543c3bdb&version=3&qrString=00020101021226500009SG.PAYNOW010120223no%20account%20for%20non-prod0301052045812530370254040.505802SG5904dev16009Singapore610612312362290125dev1%20%20%20%20%20%20%20%20%2000000008783163041AB47&returnURI=samplemerchant://action%26shouldOpenInExternalBrowser%3Dtrue
