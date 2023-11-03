//
//  AddProductVM.swift
//  Nexus-Admin
//
//  Created by ayman on 28/10/2023.
//

import Foundation
class AddProductVM{
    
    
    func AddProduct(title:String,type:String,Descriotion:String,vendor:String ,category:String,completion: @escaping (Result<SingleProductResponse, Error>) -> Void){
        
        let parameter :[String: Any] = [
            "product": [
                "title": "\(vendor)|\(title)", //product tilte
                "body_html": "\(Descriotion)",//product descrioption
                "vendor": "\(vendor)", // vendor name
                "product_type": "\(type)", // product type
                "variants": [
                            [
                                "option1":"1",
                                "option2":"red"
                            ]
                            ],
                
                            "options": [
                           [
                             
                               "name": "Size",
                               "position": 1,
                               "values": [
                                   "1"
                               ]
                           ],
                           [
                             
                               "name": "Color",
                               "position": 2,
                               "values": [
                                   "red"
                               ]
                           ]
                       ]
               
                
            ] as [String : Any]
        ]
        AdminNetManger.SharedApiManger.postData(url: .AddProduct, parameters:parameter , decodingModel: SingleProductResponse.self ){result in
            switch result{
            case.success(let product):
                var coolectid : Int?
                collectsID.allCases.forEach({ collects in
                    if (collects.rawValue == category){
                        coolectid = collects.collectionId
                        
                    }
                })
                guard let collectionID = coolectid else {return}
                let collectsparameter :[String: Any] = [
                    "collect": [
                       
                        "collection_id": collectionID,
                        "product_id": product.result.id
                        ] as [String : Any]
                ]
                             
                AdminNetManger.SharedApiManger.postData(url: .collects, parameters: collectsparameter, decodingModel: collectsModel.self) { result in
                    switch result{
                    case.success(_):
                        completion(.success(product))
                    case.failure(let error):
                        completion(.failure(error))
                    }
                }
               // completion(.success( Data))
                
                
            case.failure(let erorr):
                completion(.failure(erorr))
            }
            
            
        }
        
        
    }
    
    func getBrands(completion:@escaping (Result<[SmartCollection], Error>) -> Void){
        AdminNetManger.SharedApiManger.fetchDataaa(url: .Brand, decodingModel: BrandsModel.self) { result in
            switch result{
            case .success(let data):
                completion(.success(data.smart_collections))
                
            case .failure(let error):
                completion(.failure(error))
            
                
        }
          
        }
        
    }
    
    

    
}
