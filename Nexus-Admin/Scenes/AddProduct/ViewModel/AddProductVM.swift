//
//  AddProductVM.swift
//  Nexus-Admin
//
//  Created by ayman on 28/10/2023.
//

import Foundation
class AddProductVM{
    
    
    func AddProduct(title:String,type:String,Descriotion:String,vendor:String){
        
        let parameter :[String: Any] = [
            "product": [
                "title": "\(title)", //product tilte
                "body_html": "<strong>\(Descriotion)</strong>",//product descrioption
                "vendor": "\(vendor)", // vendor name
                "product_type": "\(type)", // product type
                "variants": []
                
            ] as [String : Any]
        ]
        
        AdminNetManger.SharedApiManger.postData(url: .AddProduct, parameters:parameter , decodingModel:SingleProduct.self ){result in
            switch result{
            case.success(let Data):
                print(Data)
            case.failure(let erorr):
                print(erorr)
            }
            
            
        }
        
        
    }
    
    

    
}
