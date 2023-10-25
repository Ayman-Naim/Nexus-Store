//
//  profileOrder.swift
//  Nexus-Store
//
//  Created by ayman on 25/10/2023.
//

import Foundation
struct profileOrder:Codable{
    
        let orders: [Order]?
        
}
struct Order:Codable{
    let id: Int?
    let app_id: Int?
    let currency : String?
    let order_status_url : String?
    let customer:Customer?
    let current_total_price : String?
    let order_number : Int?
    let line_items :[LineItems]?
    let total_price :String?
}
struct Customer:Codable{
        let id: Int?
        let email: String?
        let firstName: String?
        let lastName: String?
        let phone: String?
    
}
struct LineItems:Codable{
       let id: Int?
       let fulfillable_quantity: Int?
       let quantity : Int?
       let price: String?
       
}
