//
//  Int+Extension.swift
//  Nexus-Store
//
//  Created by Mustafa on 27/10/2023.
//

import Foundation


extension Double{
    
    var randomValue:Double {
        if self > 0 {
            return Double(arc4random_uniform(UInt32(Double(self))))
        }else if self < 0 {
            return -Double(arc4random_uniform(UInt32(Double(abs(self)))))
        }else {
            return 0
        }
    }
}


//MARK: Adding extention to Int Struct to By generate uniform Random value
extension Int{
    
    var randomValue:Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        }else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        }else {
            return 0
        }
    }
}
