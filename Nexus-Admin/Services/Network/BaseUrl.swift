//
//  BaseUrl.swift
//  Nexus-Admin
//
//  Created by ayman on 28/10/2023.
//

import Foundation


enum BaseUrl:String{

    static private let baseURL = "https://ios-q1-new-capital-admin1-2023.myshopify.com/admin/api/2023-01/"
     static var AdminEmail = ""
    static var brandId = ""
    static var productId = ""
    
    case customer
    case AddProduct
    case Brand
    case collects
    case BrandProduct
    case productDetails


    var enpoint :String {
        switch self {
        case .customer: return "\(BaseUrl.baseURL)customers/search.json?query=email:\(BaseUrl.AdminEmail)"
        case.AddProduct: return "\(BaseUrl.baseURL)products.json"
        case .Brand : return "\(BaseUrl.baseURL)smart_collections.json"
        case.collects : return "\(BaseUrl.baseURL)collects.json"
        case .BrandProduct: return "\(BaseUrl.baseURL)collections/\(BaseUrl.brandId)/products.json"
        case .productDetails : return "\(BaseUrl.baseURL)products/\(BaseUrl.productId).json"

       

        }
    }
    
}
