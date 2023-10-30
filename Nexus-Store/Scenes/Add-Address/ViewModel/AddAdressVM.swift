//
//  AddAdressVM.swift
//  Nexus-Store
//
//  Created by ayman on 29/10/2023.
//

import Foundation

class AddAddressVM{
    
    
    func addAdress(name:String ,city:String ,adddress:String,Phone:String,completion:@escaping (Result<CustomerAddresses,Error>)->Void){
        BaseUrl.userID = 6921948365036
        let AdressParameter:[String:Any] = [
            "customer_address":[
                "first_name": "\(name)",
                "address1": "\(adddress)",
                "address2": "\(adddress)",
                "city": "\(city)",
                "phone": "\(Phone)",
                ] as [String : Any]
                
        ]
        
        ApiManger.SharedApiManger.postData(url: .AddAdress, parameters: AdressParameter, decodingModel: CustomerAddresses.self) { result in
            switch result{
            case.success(let address):
                //print(address)
                completion(.success(address))
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
    
    
    
}
