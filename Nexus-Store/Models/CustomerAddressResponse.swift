//
//  CustomerAddressResponse.swift
//  Nexus-Store
//
//  Created by Khater on 31/10/2023.
//

import Foundation


struct CustomerAddressResponse: Codable {
    let singleResult: Address?
    let results: [Address]?
    
    enum CodingKeys: String, CodingKey {
        case results = "addresses"
        case singleResult = "customer_address"
    }
}
