//
//  PriceRuleModel.swift
//  Nexus-Store
//
//  Created by ayman on 02/11/2023.
//

import Foundation
struct PriceRuleModel:Codable{
    let price_rules:[PriceRuleElements]
}
struct PriceRuleElements:Codable,Hashable{
    let id:Int
    let value_type:String?
    let value:String?
    let customer_selection:String?
    let target_type:String?
    let target_selection:String?
    let allocation_method:String?
   
    let usage_limit:Int?
    let starts_at:String?
    let title:String?
    
}



