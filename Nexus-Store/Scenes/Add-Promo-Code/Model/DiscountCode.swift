//
//  DiscountCode.swift
//  Nexus-Store
//
//  Created by Mustafa on 29/10/2023.
//

import Foundation

// MARK: - Welcome
struct Welcome: Codable {
    let discountCodes: [DiscountCode]

    enum CodingKeys: String, CodingKey {
        case discountCodes = "discount_codes"
    }
}

// MARK: - DiscountCode
struct DiscountCode: Codable {
    let id, priceRuleID: Int
    let code: String
    let usageCount: Int
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case priceRuleID = "price_rule_id"
        case code
        case usageCount = "usage_count"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
