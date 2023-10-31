//
//  SignInWithAccount.swift
//  Nexus-Store
//
//  Created by Ahmed Ashraf on 27/10/2023.
//

import Foundation
import FirebaseAuth
import Alamofire

class FireBaseSignInViewModel{
    func getCustomerId(email: String, completion: @escaping (Result<SignInModel, Error>) -> Void) {
        let apiUrl = BaseUrl.createCustomer.enpoint
        let header: HTTPHeaders = ["X-Shopify-Access-Token": "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"]
   //     print("\(apiUrl) \(header)")
        AF.request(apiUrl, method: .get, headers: header).response { response in
            switch response.result {
            case .success(let data):
                guard let data = data else { return }
       //         print(String(data: data, encoding: .utf8))
                do {
           //         print("Debug3 \(data)")
                    let jsonData = try JSONDecoder().decode(SignInModel.self, from: data)
            /*        print(jsonData)
                    let customerId = jsonData.customers[0].id
                    print("============")
                    print("\(customerId)")
                    print("============")*/
                    for customer in jsonData.customers {
                        if(customer.email == email){
                            let customerId = customer.id
                            // Save the ID to UserDefaults
                            UserDefaults.standard.set(customerId, forKey: "customerID")
                            print("\(customerId)")
                            break
                        }
                    }
                    // Save the ID to UserDefaults
           //         UserDefaults.standard.set(customerId, forKey: "customerID")
                    completion(.success(jsonData))

                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
                completion(.failure(error))
            }
        }
    }
}

