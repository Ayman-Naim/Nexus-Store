//
//  DraftOrderResponse.swift
//  Nexus-Store
//
//  Created by Khater on 30/10/2023.
//

import Foundation


struct DraftOrderResponse: Codable {
    let singleResult: DraftOrder?
    let result: [DraftOrder]?
    
    enum CodingKeys: String, CodingKey {
        case singleResult = "draft_order"
        case result = "draft_orders"
    }
}
