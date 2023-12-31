//
//  K.swift
//  Nexus-Store
//
//  Created by Mustafa on 19/10/2023.
//

import Foundation


struct K{
    
    
    
    static let customCategoryCellIdetifier = "MainCategoryCell"
    static let customProductDetailsIdetifier = "productDetailsCell"
    static let categoryTitle = "Category"
    static let categoryNibID = "CategoryViewController"
    static let heartIcon = "mus\\Fav"
    static let cartIcon = "mus\\Cart"
    static let searchIcon = "mus\\Search"
    static let customFooterNib = "CustomFooterSepertator"
    
    //Custom Main Category Type
    static let womenID = 413226074348
    static let menID = 413226041580
    static let kidID = 413226107116
    static let saleID = 413226139884
    //Custom Sub Category Type
    static let tShirt = "T-SHIRTS"
    static let shoes = "SHOES"
    static let accessories = "ACCESSORIES"
    static let all = "All"
    
    //Icons
    static let darkModeLogo = "DarkMode-AppIcon"
    static let backButtonIcon = "chevron.left"
    
    
    //Favorite icon image system
    static let favoriteIconNotSave = "heart"
    static let favoriteIconSave = "heart.fill"
    
    static let customerIdKey = "customerID"

    static let dicountCopounKey = "Copone"
 
    
    
    static var customerID: Int { UserDefaults.standard.integer(forKey: "customerID") == 0 ? -1 : UserDefaults.standard.integer(forKey: "customerID") }
    
    
    static func customError(title: String? = nil, message: String) -> Error {
        return NSError(domain: title ?? "Error", code: 400, userInfo: [NSLocalizedDescriptionKey: message])
    }
}
