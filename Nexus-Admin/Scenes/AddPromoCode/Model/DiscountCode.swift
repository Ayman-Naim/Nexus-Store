//
//  DiscountCode.swift
//  Nexus-Admin
//
//  Created by Khater on 04/11/2023.
//

import Foundation


struct DiscountCodeResponse: Codable {
    let results: [DiscountCode]
    
    enum CodingKeys: String, CodingKey {
        case results = "discount_codes"
    }
}


struct DiscountCode: Codable {
    let id: Int
    let priceRuleID: Int
    let code: String
    let usageCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case priceRuleID = "price_rule_id"
        case code
        case usageCount = "usage_count"
    }
}
