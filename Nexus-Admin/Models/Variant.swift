//
//  Variant.swift
//  Nexus-Admin
//
//  Created by Khater on 29/10/2023.
//

import Foundation


struct Variant: Codable {
    let id: Int
    let productID: Int
    let title: String
    let price: String
    let inventoryQuantity: Int

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case title
        case price
        case inventoryQuantity = "inventory_quantity"
    }
}
