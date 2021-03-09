//
//  Tabby.swift
//  Safex-Pay
//
//  Created by Sandeep on 19/11/20.
//

import Foundation
import AnyCodable

struct CheckoutSession: Decodable {
    var id: String
    var configuration: Configuration
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case configuration = "configuration"
    }
}

struct Configuration: Decodable {
    var availableProducts: [String: AnyCodable]
    
    enum CodingKeys: String, CodingKey {
        case availableProducts = "available_products"
    }
}

enum ProductType: String {
    case payLater = "pay_later"
    case installments = "installments"
}


struct CreatedCheckoutSession: Decodable {
    var id: String?
    var status: String?
    var payment: Payment?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case status = "status"
        case payment = "payment"
    }
}

struct Payment: Decodable {
    var status: PaymentStatus?
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
    }
}

enum PaymentStatus: String, Decodable {
    case authorized = "authorized"
    case rejected = "REJECTED"
    case closed = "closed"
    case created = "CREATED"
}
