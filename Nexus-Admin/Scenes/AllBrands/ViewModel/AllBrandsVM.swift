//
//  AllBrandsVM.swift
//  Nexus-Admin
//
//  Created by ayman on 01/11/2023.
//

import Foundation
struct AllBrandsVM{
    
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
