//
//  ConvertPrice.swift
//  Nexus-Store
//
//  Created by Ahmed Ashraf on 05/11/2023.
//

import Foundation

class ConvertPrice{

    func getPrice(price: Double) -> String{
      
        if getSelectedCurrency(){
            let price = round(price * 100) / 100
            print("converted total \(price)")
            return "\(price) USD"
        }

        let price = round((price * (Double(getCurrency() ?? "") ?? 0.0)) * 100) / 100.0
        
        return "\(price) EGP"

    }
    
    func changePrice(price: String) -> String?{
        guard let oldPrice = Double(price) else { return ""}
        if getSelectedCurrency(){
            let newPrice = round(oldPrice * 100) / 100
            print("converted total \(newPrice)")
            return "\(newPrice) USD"
        }

        let newPrice = round((oldPrice * (Double(getCurrency() ?? "") ?? 0.0)) * 100) / 100.0
        
        return "\(newPrice) EGP"

    }
    
    func convertPrice(price: Double) -> Double{
        if getSelectedCurrency(){
            
            return round(price * 100) / 100
        }
        return round((price * (Double(getCurrency() ?? "") ?? 0.0)) * 100) / 100.0
    }
    
    func getSelectedCurrency()-> Bool{
        return UserDefaults.standard.bool(forKey: "USD")
    }
    
    func getCurrency()-> String?{
        let currency = UserDefaults.standard.string(forKey: "Currency")
        if currency == "USD"{
            return "USD"
        }
        return currency ?? ""
    }
}
