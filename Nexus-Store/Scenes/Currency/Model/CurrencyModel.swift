//
//  CurrencyModel.swift
//  Nexus-Store
//
//  Created by Ahmed Ashraf on 05/11/2023.
//

import Foundation

struct CurrencyModel: Codable {
//    let meta: Meta
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let egp: EGP

    enum CodingKeys: String, CodingKey {
        case egp = "EGP"
    }
}

// MARK: - Usd
struct EGP: Codable {
    let code: String
    let value: Double
}
