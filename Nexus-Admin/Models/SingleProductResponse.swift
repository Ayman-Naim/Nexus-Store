//
//  SingleProductResponse.swift
//  Nexus-Admin
//
//  Created by Khater on 29/10/2023.
//

import Foundation


struct SingleProductResponse: Codable {
    let result: Product
    
    enum CodingKeys: String, CodingKey {
        case result = "product"
    }
}
struct SingleProductResponseMustafa: Codable {
    let result: ProductMustafa
    
    enum CodingKeys: String, CodingKey {
        case result = "product"
    }
}
