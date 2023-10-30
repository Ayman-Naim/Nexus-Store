//
//  Product.swift
//  Nexus-Admin
//
//  Created by Khater on 29/10/2023.
//

import Foundation

struct Product: Codable {
    let id: Int
    let title: String
    let description: String
    let vendor: String
    let productType: ProductType
    let variants: [Variant]
    let options: [Option]
    let images: [Image]
    let image: Image?
    
    
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
