//
//  Option.swift
//  Nexus-Admin
//
//  Created by Khater on 29/10/2023.
//

import Foundation


struct Option: Codable {
    let id: Int
    let productId: Int
    let name: String
    let values: [String]
    
    enum CodingKeys: String, CodingKey {
        case id
        case productId = "product_id"
        case name
        case values
    }
}
