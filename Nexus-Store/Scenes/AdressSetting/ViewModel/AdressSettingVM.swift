//
//  AdressSettingVM.swift
//  Nexus-Store
//
//  Created by ayman on 03/11/2023.
//

import Foundation
class AdressSettingVM{
    
    var UserAdresses:[Address] = []
    
    func getUserAdresses(completion:@escaping (Result<[Address],Error>)->Void){
        BaseUrl.userID = K.customerID
        ApiManger.SharedApiManger.fetchData(url: .FetchAdress, decodingModel: userAdresses.self) { result in
            switch result {
            case .success(let addresses):
                self.UserAdresses = addresses.addresses
                completion(.success( addresses.addresses))
            case .failure(let error):
                print(error)
                completion(.failure (error))
                
            }
        }
        
    }
    func DelteAdress(addressID:Int,completion:@escaping (Result<Bool,Error>)->Void){
        BaseUrl.userID = K.customerID
        BaseUrl.AddresID = addressID
        ApiManger.SharedApiManger.Delete(url: .DeleteAddress) { result in
            switch result {
            case .success(_):
                completion(.success(true))
            case .failure(let error):
                print(error)
                completion(.failure (error))
                
            }
        }
        
    }
    
    
}
