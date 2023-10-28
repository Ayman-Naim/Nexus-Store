//
//  Product.swift
//  Nexus-Store
//
//  Created by Mustafa on 25/10/2023.
//

import Foundation
struct AllProduct:Hashable, Codable {
    let products: [Product]
}
struct SingleProduct: Codable {
    let product: Product
}

// MARK: - Product
struct Product:Hashable, Codable {
    let id: Int
    var title: String?
    var bodyHtml: String?
    var vendor: String?
    var productType: String?
    var createdAt: String?
    var handle: String?
    var updatedAt: String?
    var publishedAt: String?
    var status: String?
    var publishedScope: String?
    var tags: String?
    var adminGraphqlApiId: String?
    var variants: [Variants]?
    var options: [Options]?
    var images: [Image]?
    var image: Image?
    var templateSuffix: String?
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case bodyHtml = "body_html"
        case vendor = "vendor"
        case productType = "product_type"
        case createdAt = "created_at"
        case handle = "handle"
        case updatedAt = "updated_at"
        case publishedAt = "published_at"
        case status = "status"
        case publishedScope = "published_scope"
        case tags = "tags"
        case adminGraphqlApiId = "admin_graphql_api_id"
        case variants = "variants"
        case options = "options"
        case images = "images"
        case image = "image"
        case templateSuffix = "template_suffix"
    }

}


