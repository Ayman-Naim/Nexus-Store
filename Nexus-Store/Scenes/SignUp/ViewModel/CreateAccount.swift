//
//  CreateAccount.swift
//  Nexus-Store
//
//  Created by Ahmed Ashraf on 27/10/2023.
//

import Foundation
import FirebaseAuth
import Alamofire

class FireBaseSignUPViewModel{
    func createAccount (email: String, password: String){
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            // Check for errors during sign-up
            if let error = error {
                // Handle sign-up error
                print("Sign-up error: \(error.localizedDescription)")
                return
            }
            if let result = authResult {
                print("El Mon")
                self.create(email: email) { result in
                    switch result{
                    case .success(let customer):
                        print("debug2 \(customer)")
                        //     self.customer = customer
                        
                    case .failure(let error):
                        print(error)
                        
                        
                    }
                }
            }
        }
    }
    
    func create(email: String, completion:@escaping (Result<SignUpModel, Error>) -> Void){
        let header: HTTPHeaders = ["X-Shopify-Access-Token": "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",
            "Content-Type": "application/json"]
        let param: [String: Any]  =
        [
            "customer": [
                "email": "\(email)",
                "first_name": "\(email)",
                "last_name": "\(email)",
                "phone": "+15142546011",
                "password" : "admin",
                "password_confirmation" : "admin",
                "send_email_welcome" : true
            ]
        ] as [String: Any]
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: param){
            print(jsonData)
            AF.request(BaseUrl.createCustomer.enpoint, method: .post, parameters: param, encoding: JSONEncoding.default, headers: header).response { response in
                switch response.result {
                case .success(let data):
                    guard let data = data else { return }
                    do {
                        print("Debug3 \(data)")
                        let jsonData = try JSONDecoder().decode(SignUpModel.self, from: data)
                        print(jsonData)
                        completion(.success(jsonData))

                    } catch {
                        completion(.failure(error))
                    }
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else{
            print("Error Yasta")
        }
        
        
        /*
        ApiManger.SharedApiManger.postData(url: .createCustomer, parameters: param, decodingModel: SignUpModel.self) { result in
            switch result{
            case .success(let data):
                completion(.success(data.signUpModel))
                
            case .failure(let error):
                completion(.failure(error))
                print(error)
                
        }
          
        }*/
        
    }
}
