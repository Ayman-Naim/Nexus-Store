//
//  MetafieldResponse.swift
//  Nexus-Store
//
//  Created by Khater on 01/11/2023.
//

import Foundation


struct MetafieldResponse: Codable {
    let metafield: Metafield? // Single
    let metafields: [Metafield]? // All
}
