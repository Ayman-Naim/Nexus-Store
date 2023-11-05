//
//  Currency.swift
//  Nexus-Store
//
//  Created by Ahmed Ashraf on 05/11/2023.
//

import Foundation

struct Currency{
    func updateCurrency(){
        ApiManger.SharedApiManger.getCurrency()
    }
    
    
}
