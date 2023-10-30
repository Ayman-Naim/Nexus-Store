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
