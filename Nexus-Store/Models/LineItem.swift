//
//  LineItem.swift
//  Nexus-Store
//
//  Created by Khater on 30/10/2023.
//

import Foundation


struct LineItem: Codable {
    let id: Int
    let variantID: Int?
    var quantity: Int
    
//    let properties: [Property]
    let properties: [[String: String]]
    
    let productID: Int?
    let productTitle: String
    let productVendor: String?
    let productPrice: String
    let sizeColor: String?
    
    //    let appliedDiscount: AppliedDiscount?
    
    enum CodingKeys: String, CodingKey {
        case id
        case variantID = "variant_id"
        case quantity
        case properties
        case productID = "product_id"
        case productTitle = "title"
        case productVendor = "vendor"
        case productPrice = "price"
        case sizeColor = "variant_title"
    }
    
    struct Property: Codable {
        let name: String
        let value: String
        
        enum CodingKeys: String, CodingKey {
            case name = "name"
            case value = "value"
        }
    }
}
