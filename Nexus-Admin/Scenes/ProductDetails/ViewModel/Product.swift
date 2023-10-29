//
//  Product.swift
//  Nexus-Admin
//
//  Created by Khater on 27/10/2023.
//

import Foundation

//struct ProductResponse: Codable {
//    let result: Product
//    
//    enum CodingKeys: String, CodingKey {
//        case result = "product"
//    }
//}
//
//
//struct Product: Codable {
//    let id: Int
//    let title: String
//    let description: String
//    let vendor: String
//    let productType: ProductType
//    let variants: [Variant]
//    let options: [Option]
//    let images: [Image]
//    let image: Image?
//    
//    
//    enum CodingKeys: String, CodingKey {
//        case id
//        case title
//        case description = "body_html"
//        case vendor
//        case productType = "product_type"
//        case variants
//        case options
//        case images
//        case image
//    }
//}
//
//enum ProductType: String, CaseIterable, Codable {
//    case accessories = "ACCESSORIES"
//    case shoes = "SHOES"
//    case tShirts = "T-SHIRTS"
//}
//
//struct Variant: Codable {
//    let id: Int
//    let productID: Int
//    let title: String
//    let price: String
//    let inventoryQuantity: Int
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case productID = "product_id"
//        case title
//        case price
//        case inventoryQuantity = "inventory_quantity"
//    }
//}
//
//struct Option: Codable {
//    let id: Int
//    let productId: Int
//    let name: String
//    let values: [String]
//    
//    enum CodingKeys: String, CodingKey {
//        case id
//        case productId = "product_id"
//        case name
//        case values
//    }
//}
//
//struct Image: Codable {
//    let id: Int
//    let productID: Int
//    let src: String
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case productID = "product_id"
//        case src
//    }
//}
