//
//  Address.swift
//  Nexus-Store
//
//  Created by Khater on 31/10/2023.
//

import Foundation



struct Address: Codable{
    let  id: Int
    let  customerID: Int
    let  firstName: String?
    let  lastName: String?
    let  address1: String?
    let  address2: String?
    let  city: String?
    let  phone: String?
    let  name: String?
    let isDefault: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case customerID = "customer_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case address1
        case address2
        case city
        case phone
        case name
        case isDefault = "default"
    }
}

