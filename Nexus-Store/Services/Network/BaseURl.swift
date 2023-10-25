//
//  BaseURl.swift
//  Nexus-Store
//
//  Created by ayman on 24/10/2023.
//

import Foundation

enum BaseUrl:String{
    static private let baseURL = "https://ios-q1-new-capital-admin1-2023.myshopify.com/admin/api/2023-01/"
    case product
    case category
    case Brand
    
    var enpoint :String {
        switch self {
        case .product: return "\(BaseUrl.baseURL)smart_collections.json"
        case .category: return "\(BaseUrl.baseURL)"
        case .Brand : return "\(BaseUrl.baseURL)smart_collections.json"
        }
    }
    
}
