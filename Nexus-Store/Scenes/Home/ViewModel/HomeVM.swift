//
//  HomeVM.swift
//  Nexus-Store
//
//  Created by ayman on 25/10/2023.
//

import Foundation
class HomeVM{
    
    
    func getBrands(completion:@escaping (Result<[SmartCollection], Error>) -> Void){
        ApiManger.SharedApiManger.fetchData(url: .Brand, decodingModel: BrandsModel.self) { result in
            switch result{
            case .success(let data):
                completion(.success(data.smart_collections))
                
            case .failure(let error):
                completion(.failure(error))
            
                
        }
          
        }
        
    }
    
    
    
    
}
