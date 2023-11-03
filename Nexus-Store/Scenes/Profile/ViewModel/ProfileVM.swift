//
//  ProfileVM.swift
//  Nexus-Store
//
//  Created by ayman on 25/10/2023.
//

import Foundation
import Alamofire
class ProfileVM{
    
    func getOrders(completion:@escaping (Result<[Order], Error>) -> Void){
        
        //BaseUrl.userID = 6899149603052
        BaseUrl.userID = K.customerID
        ApiManger.SharedApiManger.fetchData(url: .usersOrder, decodingModel: profileOrder.self) { result in
            switch result{
            case .success(let data):
                guard let orders =  data.orders else{return}
                completion(.success(orders))
                
            case .failure(let error):
                completion(.failure(error))
            
                
        }
          
        }
        
    }
    
    
    private let baseURLString = "https://b088a15054821f0f76c1eb98b594061a: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@ios-q1-new-capital-admin1-2023.myshopify.com/admin/api/2023-01"
    private lazy var customersEndpoint = baseURLString + "/customers"
    private let header: HTTPHeaders = ["X-Shopify-Access-Token": "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"]
    
    private func fetchAllMetafields(forCustom customerID: Int, completion: @escaping (Result<[Metafield], Error>) -> Void) {
        let url = customersEndpoint + "/\(customerID)/metafields.json"
        AF.request(url, method: .get, headers: header).responseDecodable(of: MetafieldResponse.self) { response in
            switch response.result {
            case .success(let data):
                guard let metafields = data.metafields else {
                    completion(.success([]))
                    return
                }
                
                completion(.success(metafields))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getWishlist(forCustom customerID: Int, completion: @escaping (Result<[Product], Error>) -> Void) {
        fetchAllMetafields(forCustom: customerID) { result in
            switch result {
            case .success(let wishListMetafield):
                guard !wishListMetafield.isEmpty else {
                    completion(.success([]))
                    return
                }
                let stringIDs = wishListMetafield.compactMap( { String($0.key) }).joined(separator: ",")
                let url = self.baseURLString + "/products.json?ids=\(stringIDs)"
                AF.request(url, method: .get, headers: self.header).responseDecodable(of: AllProduct.self) { response in
                    switch response.result {
                    case .success(let data):
                        completion(.success(data.products))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
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
