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



struct ProductMustafa: Codable {
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
    var variants: [VariantMustafa]?
    var options: [OptionMustafa]?
    var images: [ImageMustafa]?
    var image: ImageMustafa?
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


