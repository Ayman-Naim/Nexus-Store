//
//  AdressModel.swift
//  Nexus-Store
//
//  Created by ayman on 29/10/2023.
//

import Foundation
struct CustomerAddresses:Codable{
    let customer_address:Address?
}
struct Address:Codable{
    let  id: Int?
    let  customer_id: Int?
    let  first_name: String?
    let  last_name: String?
    let  address1: String?
    let  address2: String?
    let  city: String?
    let  phone: String?
    let  name: String?
    
}
