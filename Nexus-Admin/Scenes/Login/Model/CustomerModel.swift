//
//  CustomerModel.swift
//  Nexus-Admin
//
//  Created by ayman on 28/10/2023.
//

import Foundation
import Foundation
struct Admin:Codable{
    
    let customers:[adminModel]?
    
    
}
struct adminModel:Codable{
    let id: Int?
    let email: String?
}
