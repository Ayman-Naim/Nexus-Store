//
//  ProfileVM.swift
//  Nexus-Store
//
//  Created by ayman on 25/10/2023.
//

import Foundation
class ProfileVM{
    
    func getOrders(completion:@escaping (Result<[Order], Error>) -> Void){
        ApiManger.SharedApiManger.fetchData(url: .orders, decodingModel: profileOrder.self) { result in
            switch result{
            case .success(let data):
                guard let orders =  data.orders else{return}
                completion(.success(orders))
                
            case .failure(let error):
                completion(.failure(error))
            
                
        }
          
        }
        
    }
    
}
