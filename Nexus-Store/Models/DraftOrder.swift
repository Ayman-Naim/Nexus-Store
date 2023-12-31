//
//  DraftOrder.swift
//  Nexus-Store
//
//  Created by Khater on 30/10/2023.
//

import Foundation


struct DraftOrder: Codable {
    let id: Int
//    let orderID: Int
    let currency: String
    let lineItems: [LineItem]
//    let shippingAddress: ShippinAddress?
//    let appliedDiscount: AppliedDiscount?
//    let shippingLine: String?
    let totalPrice: String
    let customer: Customer
    let note: String?
    let applied_discount: AppliedDiscount?
    
    enum CodingKeys: String, CodingKey {
        case id
        case currency
        case lineItems = "line_items"
        case totalPrice = "total_price"
        case customer
        case note
        case applied_discount
    }
}


// MARK: - AppliedDiscount
struct AppliedDiscount: Codable {
    let value, amount, value_type: String

    
}
