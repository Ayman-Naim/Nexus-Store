//
//  DiscountType.swift
//  Nexus-Admin
//
//  Created by Khater on 04/11/2023.
//

import Foundation


enum DiscountType: String, CaseIterable, Codable {
    case percentage = "percentage"
    case fixed = "fixed_amount"
}
