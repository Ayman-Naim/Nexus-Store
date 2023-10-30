//
//  collectsModel.swift
//  Nexus-Admin
//
//  Created by ayman on 29/10/2023.
//

import Foundation
struct collectsModel:Codable{
    let collects : collects?
}
struct collects:Codable{
   let collection_id:Int?
    let product_id : Int?
    
}
