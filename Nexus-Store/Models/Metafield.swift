//
//  Metafield.swift
//  Nexus-Store
//
//  Created by Khater on 01/11/2023.
//

import Foundation



struct Metafield: Codable {
    let id: Int
    let key, value: String
    let ownerID: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case key
        case value
        case ownerID = "owner_id"
    }
}
