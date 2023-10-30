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
    
    
    func getUserData()->Result<String,Error>{
       guard let contentData = UserDefaults.standard.string(forKey: "customerEmail") 
              else{ return(.failure(UserDfaultError.emptyUser)) }
        print(contentData)
        return(.success(contentData))
        

    }
    
    
    
}

enum UserDfaultError : Error{
case emptyUser
    
    
    var errorDescription :String{
        switch self{
        case.emptyUser : return "No User LogedIN"
        }
    }
}
