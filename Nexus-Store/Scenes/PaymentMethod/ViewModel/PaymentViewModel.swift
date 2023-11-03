//
//  PaymentViewModel.swift
//  Nexus-Store
//
//  Created by Ahmed Ashraf on 03/11/2023.
//

import Foundation
import Alamofire

class PaymentViewModel{
    let draftOrder = DraftOrderService()
    
    func create(completion:@escaping (Result<SignUpModel, Error>) -> Void){
        let header: HTTPHeaders = ["X-Shopify-Access-Token": "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",
            "Content-Type": "application/json"]
        let param: [String: Any]  =
        [
            "customer": [
                "send_email_welcome": true
            ]
        ] as [String: Any]
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: param){
            print(jsonData)
            AF.request(BaseUrl.createCustomer.enpoint, method: .post, parameters: param, encoding: JSONEncoding.default, headers: header).response { response in
                switch response.result {
                case .success(let data):
                    guard let data = data else { return }
           //         print(String(data: data, encoding: .utf8))
                    do {
               //         print("Debug3 \(data)")
                        let jsonData = try JSONDecoder().decode(SignUpModel.self, from: data)
                //        print(jsonData)
                        let customerId = jsonData.customer.id
                        // Save the ID to UserDefaults
                        UserDefaults.standard.set(customerId, forKey: "customerID")
                        completion(.success(jsonData))

                    } catch {
                        completion(.failure(error))
                    }
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else{
            print("Error")
        }
    }
}
