//
//  BrandsModel.swift
//  Nexus-Store
//
//  Created by ayman on 25/10/2023.
//

import Foundation
struct BrandsModel:Codable{
    let smart_collections : [SmartCollection]
    
    
}
struct SmartCollection: Codable{
    let id: Int?
    let handle:String?
    let title: String?
    let updated_at: String?
    let body_html: String?
    let published_at: String?
    let sort_order: String?
    let disjunctive: Bool?
    let adminGraphqlAPIID: String?
    let image: BrandImage?
    
}
struct BrandImage: Codable{
    let createdAt: Date?
    let width: Int?
    let  height: Int?
    let src: String?
}
