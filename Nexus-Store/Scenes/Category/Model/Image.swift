//
//  Image.swift
//  Nexus-Store
//
//  Created by Mustafa on 25/10/2023.
//

import Foundation
struct Image:Hashable, Codable {
    let id: Int?
    let productId: Int?
    let position: Int?
   // let createdAt: String?
   // let updatedAt: String?
    //let width: Int?
    //let height: Int?
    let src: String?
    //let adminGraphqlApiId: String?
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case productId = "product_id"
        case position = "position"
      //  case createdAt = "created_at"
       // case updatedAt = "updated_at"
       // case width = "width"
       // case height = "height"
        case src = "src"
        //case adminGraphqlApiId = "admin_graphql_api_id"
    }
    
}
