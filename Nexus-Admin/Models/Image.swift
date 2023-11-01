//
//  Image.swift
//  Nexus-Admin
//
//  Created by Khater on 29/10/2023.
//

import Foundation


struct Image: Codable {
    let id: Int
    let productID: Int
    let src: String

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case src
    }
}


struct ImageMustafa: Codable {
    let id: Int?
    let productId: Int?
    let position: Int?
    let createdAt: String?
    let updatedAt: String?
    let width: Int?
    let height: Int?
    let src: String?
    let adminGraphqlApiId: String?
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case productId = "product_id"
        case position = "position"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case width = "width"
        case height = "height"
        case src = "src"
        case adminGraphqlApiId = "admin_graphql_api_id"
    }
}

