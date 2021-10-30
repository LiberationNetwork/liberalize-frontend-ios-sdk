//
//  PaymentResponse.swift
//  Libralize-iOS
//
//  Created by Libralize on 12/10/2021.
//

import Foundation

class PaymentResponse: Codable {
    let id, organizationId, posId, paymentId: String?
    let payment: Payment?
    let status: String?
    let state: String?
    let amount: Int?
    let currency: String?
    let createdAt, updatedAt: Date?
    let processor: PaymentProcessor?
    
    init(
        id: String? = nil,
        organizationId: String? = nil,
        posId: String? = nil,
        paymentId: String? = nil,
        payment: Payment? = nil,
        status: String? = nil,
        state: String? = nil,
        amount: Int? = nil,
        currency: String? = nil,
        processor: PaymentProcessor? = nil,
        createdAt: Date? = nil,
        updatedAt: Date? = nil
    ) {
        self.id = id
        self.organizationId = organizationId
        self.posId = posId
        self.paymentId = paymentId
        self.payment = payment
        self.status = status
        self.state = state
        self.amount = amount
        self.currency = currency
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.processor = processor
    }
}

class Payment: Codable {
    let id, organizationId, posId, currency: String?
    let amount, amountCaptured, amountRefunded: Int?
    let state, routeId, createdAt, updatedAt: String?
    
    init(
        id: String,
        organizationId: String,
        posId: String,
        currency: String,
        amount: Int,
        amountCaptured: Int,
        amountRefunded: Int,
        state: String,
        routeId: String,
        createdAt: String,
        updatedAt: String
    ) {
        self.id = id
        self.organizationId = organizationId
        self.posId = posId
        self.currency = currency
        self.amount = amount
        self.amountCaptured = amountCaptured
        self.amountRefunded = amountRefunded
        self.state = state
        self.routeId = routeId
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

class PaymentProcessor: Codable {
    let transactionId: String?
    let qrData: String?
    let status: String?
    let authCode: String?
}
