//
//  Variant.swift
//  Nexus-Admin
//
//  Created by Khater on 29/10/2023.
//

import Foundation


struct Variant: Codable {
    let id: Int
    let productID: Int
    let title: String
    let price: String
    let inventoryQuantity: Int

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case title
        case price
        case inventoryQuantity = "inventory_quantity"
    }
}

struct VariantMustafa: Codable {
    var id: Int?
    var productId: Int?
    var title: String?
    var price: String
    var sku: String?
    var position: Int?
    var inventoryPolicy: String?
    var compareAtPrice: String?
    var fulfillmentService: String?
    var inventoryManagement: String?
    var option1: String?
    var option2: String?
    var createdAt: String?
    var updatedAt: String?
    var taxable: Bool?
    var grams: Int?
    var weight: Int?
    var weightUnit: String?
    var inventoryItemId: Int?
    var inventoryQuantity: Int?
    var oldInventoryQuantity: Int?
    var requiresShipping: Bool?
    var adminGraphqlApiId: String?
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case productId = "product_id"
        case title = "title"
        case price = "price"
        case sku = "sku"
        case position = "position"
        case inventoryPolicy = "inventory_policy"
        case compareAtPrice = "compare_at_price"
        case fulfillmentService = "fulfillment_service"
        case inventoryManagement = "inventory_management"
        case option1 = "option1"
        case option2 = "option2"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case taxable = "taxable"
        case grams = "grams"
        case weight = "weight"
        case weightUnit = "weight_unit"
        case inventoryItemId = "inventory_item_id"
        case inventoryQuantity = "inventory_quantity"
        case oldInventoryQuantity = "old_inventory_quantity"
        case requiresShipping = "requires_shipping"
        case adminGraphqlApiId = "admin_graphql_api_id"
    }
}
