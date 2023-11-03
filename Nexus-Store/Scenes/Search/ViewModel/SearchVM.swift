//
//  SearchVM.swift
//  Nexus-Store
//
//  Created by ayman on 30/10/2023.
//

import Foundation
class SearchVM{
    
    func getProducts(completion:@escaping (Result<[Product], Error>) -> Void){
        ApiManger.SharedApiManger.fetchData(url: .product, decodingModel: AllProduct.self) { result in
            switch result{
            case .success(let allproducts):
                completion(.success(allproducts.products))
                
            case .failure(let error):
                completion(.failure(error))
            
                
        }
          
        }
        
    }
    
}
