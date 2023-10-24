//
//  NetworkManger.swift
//  Nexus-Store
//
//  Created by ayman on 24/10/2023.
//

import Foundation
import Alamofire

class ApiManger {
    
    static let SharedApiManger = ApiManger()
    
   private  init(){
        
    }
    
   
    
    func fetchData<T: Decodable>(url: String, decodingModel: T.Type, completion: @escaping (T?, Error?) -> Void) {
        AF.request(url).validate().responseDecodable(of: T.self) { response in
        
        switch response.result {
        case .success(let decodedData):
           // print("DeBug: \(response)")
            completion(decodedData, nil)
        case .failure(let error):
            completion(nil, error)
            
            
        }
        
    }
        
    }
    
    func postData<T: Decodable>(url: String,parameters: [String: Any],decodingModel: T.Type,completion: @escaping (T?, Error?) -> Void) {
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate().responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let decodedData):
                    completion(decodedData, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
    
}
