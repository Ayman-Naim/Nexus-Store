//
//  AdminNetManger.swift
//  Nexus-Admin
//
//  Created by ayman on 28/10/2023.
//

import Foundation
import Alamofire

class AdminNetManger {
    
    static let SharedApiManger = AdminNetManger()
    
    private  init(){}
    
    private let headerApi: HTTPHeaders = [
        "X-Shopify-Access-Token": "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",
        "Content-Type": "application/json"
    ]
    
    
    func fetchDataaa<T: Decodable>(url: BaseUrl, decodingModel: T.Type, completion: @escaping (Result<T, Error>) -> Void) {

        AF.request(url.enpoint,headers: headerApi).validate().responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let decodedData):
                // print("DeBug: \(response)")
                completion(.success(decodedData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
  
    func postData<T: Decodable>(url: BaseUrl, parameters: [String: Any],decodingModel: T.Type,completion: @escaping (Result<T,Error>) -> Void) {
        AF.request(url.enpoint, method: .post,parameters: parameters,encoding: JSONEncoding.default, headers: headerApi).validate(statusCode: 200 ..< 299).responseData { response in
                switch response.result {
                case .success(let data ):
                    do {
                        let result = try JSONDecoder().decode(decodingModel, from: data)
                        
                        completion(.success(result))
                    } catch {
                        completion(.failure(error))
                        print("Error: Trying to convert JSON data to string")
                        return
                    }
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
