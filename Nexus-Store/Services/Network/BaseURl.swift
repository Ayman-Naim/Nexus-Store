//
//  BaseURl.swift
//  Nexus-Store
//
//  Created by ayman on 24/10/2023.
//

import Foundation

enum BaseUrl:String{

    static private let baseURL = "https://ios-q1-new-capital-admin1-2023.myshopify.com/admin/api/2023-01/"
    static var MainCategory:Int = 0
    static var CategoryPriceID:Int = 0
    static var SubCategoryItem:String = ""
    static var priceRuleID = ""
    static var CoupunsPriceRuleID:Int = 0
    static var userID = 0
    static var draftOrderID = 0
    static var AddresID = 0
    case product
    case category
    case CategoryProduct
    case Brand
    case CategoryProductPrice
    case SubCategory
    case orders
    case createCustomer
    case PriceRule
    case usersOrder
    case AddAdress
    case allpriceRole
    case copounsOfPrieRule
    case draftOrder
    case FetchAdress
    case DeleteAddress
    var enpoint :String {
        switch self {
        case .product: return "\(BaseUrl.baseURL)products.json"
        case .category: return "\(BaseUrl.baseURL)"
        case .Brand : return "\(BaseUrl.baseURL)smart_collections.json"
        case.orders : return"\(BaseUrl.baseURL)orders.json?financial_status=paid"
        case .CategoryProduct: return "\(BaseUrl.baseURL)collections/\(BaseUrl.MainCategory)/products.json"
        case .SubCategory: return "\(BaseUrl.baseURL)products.json?collection_id=\(BaseUrl.MainCategory)&product_type=\(BaseUrl.SubCategoryItem)"
        case .CategoryProductPrice: return "\(BaseUrl.baseURL)products/\(BaseUrl.CategoryPriceID).json"
        case .createCustomer: return "\(BaseUrl.baseURL)customers.json"
        case .PriceRule: return "\(BaseUrl.baseURL)price_rules/\(BaseUrl.priceRuleID).json"
        case .usersOrder: return "\(BaseUrl.baseURL)customers/\(BaseUrl.userID)/orders.json"
        case .AddAdress: return"\(BaseUrl.baseURL)customers/\(BaseUrl.userID)/addresses.json"
        case .allpriceRole: return "\(BaseUrl.baseURL)price_rules.json"
        case .copounsOfPrieRule: return "\(BaseUrl.baseURL)price_rules/\(BaseUrl.CoupunsPriceRuleID)/discount_codes.json"
            
        case .draftOrder : return "\(BaseUrl.baseURL)draft_orders/\(BaseUrl.draftOrderID).json"

        case .FetchAdress : return "\(BaseUrl.baseURL)customers/\(BaseUrl.userID)/addresses.json"
        case .DeleteAddress : return "\(BaseUrl.baseURL)customers/\(BaseUrl.userID)/addresses/\(BaseUrl.AddresID).json"
        }
    }
    
}
