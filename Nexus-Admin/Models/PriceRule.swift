//
//  PriceRule.swift
//  Nexus-Admin
//
//  Created by Khater on 04/11/2023.
//

import Foundation


struct PriceRuleResponse: Codable {
    let singleResult: PriceRule?
    let results: [PriceRule]?
    
    enum CodingKeys: String, CodingKey {
        case singleResult = "price_rule"
        case results = "price_rules"
    }
}


struct PriceRule: Codable {
    let id: Int
    let title: String
    let discountType: DiscountType
    let discountValue: String
    let usageLimit: Int?
    let startAt: String
    let endAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case discountType = "value_type"
        case discountValue = "value"
        case usageLimit = "usage_limit"
        case startAt = "starts_at"
        case endAt = "ends_at"
    }
}
