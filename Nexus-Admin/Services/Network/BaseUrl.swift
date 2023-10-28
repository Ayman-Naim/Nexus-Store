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
    case customer
    case AddProduct

    var enpoint :String {
        switch self {
        case .customer: return "\(BaseUrl.baseURL)customers/search.json?query=email:\(BaseUrl.AdminEmail)"
        case.AddProduct: return "\(BaseUrl.baseURL)products.json"
            
            
       

        }
    }
    
}
