//
//  CollectsID.swift
//  Nexus-Admin
//
//  Created by ayman on 29/10/2023.
//

import Foundation
enum collectsID:String,CaseIterable{
    case men = "Men"
    case women = "Women"
    case kid = "Kids"
    case sale = "Sale"
    
    var collectionId : Int {
        switch self {
        case.men : return 413226041580
        case.women : return 413226074348
        case.kid : return 413226107116
        case.sale : return 413226139884
        }
    }
  
}
