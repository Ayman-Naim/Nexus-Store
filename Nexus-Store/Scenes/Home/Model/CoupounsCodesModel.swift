//
//  CoupounsCodesModel.swift
//  Nexus-Store
//
//  Created by ayman on 02/11/2023.
//

import Foundation
struct CoupounsCodesModel:Codable{
    let discount_codes: [CoupounsCodes]
}
struct CoupounsCodes :Codable {
    let id :Int?
    let price_rule_id :Int?
    let usage_count :Int?
    let code:String?
    let created_at:String?
    let updated_at:String?
    
}

