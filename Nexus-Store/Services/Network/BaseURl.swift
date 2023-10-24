//
//  BaseURl.swift
//  Nexus-Store
//
//  Created by ayman on 24/10/2023.
//

import Foundation

enum BaseUrl:String{
    case baseUrl = "https://ios-q1-new-capital-admin1-2023.myshopify.com/admin/api/2023-01/"
    case product
    case category
    
    var Url :String {
        switch self {
      
        case .product: return "\(BaseUrl.baseUrl.rawValue)smart_collections.json"
        case .category: return "\(BaseUrl.baseUrl.rawValue)"
        case .baseUrl: return BaseUrl.baseUrl.rawValue
            
        }
    }
    
}
