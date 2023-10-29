//
//  Product.swift
//  Nexus-Admin
//
//  Created by Khater on 27/10/2023.
//

import Foundation

struct ProductResponseM: Codable {
    let result: ProductM
    
    enum CodingKeys: String, CodingKey {
        case result = "product"
    }
}


struct ProductM: Codable {
    let id: Int
    let title: String
    let description: String
    let vendor: String
    let productType: ProductTypeM
    let variants: [VariantM]
    let options: [OptionM]
    let images: [ImageM]
    let image: ImageM?
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description = "body_html"
        case vendor
        case productType = "product_type"
        case variants
        case options
        case images
        case image
    }
}

enum ProductTypeM: String, CaseIterable, Codable {
    case accessories = "ACCESSORIES"
    case shoes = "SHOES"
    case tShirts = "T-SHIRTS"
}

struct VariantM: Codable {
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

struct OptionM: Codable {
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

struct ImageM: Codable {
    let id: Int
    let productID: Int
    let src: String

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case src
    }
}
