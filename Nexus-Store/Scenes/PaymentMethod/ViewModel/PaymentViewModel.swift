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
    
    let baseURLString = "https://ios-q1-new-capital-admin1-2023.myshopify.com/admin/api/2023-01/draft_orders"
    let header: HTTPHeaders = ["X-Shopify-Access-Token": "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"]
    
    func updatePaymentOfDraftOrder(draft_order_id:Int, paymentPending: Bool, completion: @escaping ((Result<DraftOrder, Error>)?) -> Void) {
   //     let urlString = baseURLString + ".json"
        let urlString = "https://b088a15054821f0f76c1eb98b594061a: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@ios-q1-new-capital-admin1-2023.myshopify.com/admin/api/2023-01/draft_orders/\(draft_order_id)/complete.json"
        let params = [
            "payment_pending": paymentPending
        ] as [String : Any]
        
        AF.request(urlString, method: .put, parameters: params, encoding: JSONEncoding.default, headers: header).responseDecodable(of: DraftOrderResponse.self) { response in
            switch response.result {
            case .success(let draftOrders):
                guard let draftOrdersResult = draftOrders.singleResult else {
                    completion(.failure(K.customError(message: "No result for draft orders")))
                    return
                }
                completion(.success(draftOrdersResult))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    func deleteFullDraftOrder(customerID: Int, failure: @escaping (Error) -> Void) {
        draftOrder.customerDraftOrder(customerID: customerID) { result in
            switch result {
            case .success(let draftOrder):
                let url = "https://ios-q1-new-capital-admin1-2023.myshopify.com/admin/api/2023-01/draft_orders"
                AF.request(url + "/\(draftOrder.id).json", method: .delete, headers: self.header).response { _ in }
                
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    
    /*
    // Method to update the payment_pending attribute
        func updatePaymentPending(forDraftOrder draftOrderID: Int, isPending: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
            let baseURLString = "https://ios-q1-new-capital-admin1-2023.myshopify.com/admin/api/2023-01/draft_orders"
            let header: HTTPHeaders = ["X-Shopify-Access-Token": "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"]
            // Create an instance of DraftOrderUpdateAttributes
            let attributes = DraftOrderUpdateAttributes(payment_pending: isPending)
            
            let param: [String: Any]  =
            [
                "draft_orders": [
                    "payment_pending": true
                ]
            ] as [String: Any]
            
            // Convert it to JSON
            guard let jsonData = try? JSONEncoder().encode(attributes) else {
                completion(.failure(K.customError(message: "Failed to encode JSON data")))
                return
            }
            
            // Make a PUT request to update the draft order
            let urlString = baseURLString + "/\(draftOrderID).json"
            AF.request(urlString, method: .put, parameters: jsonData, encoding: JSONEncoding.default, headers: header)
                .response { response in
                    if response.error != nil {
                        completion(.failure(response.error!))
                    } else {
                        completion(.success(()))
                    }
                }
        }
        
        // Method to delete all draft orders
        func deleteAllDraftOrders(completion: @escaping (Result<Void, Error>) -> Void) {
            // Use the DraftOrderService to delete not full draft orders
            draftOrder.deleteNotFullDraftOrder(customerID: yourCustomerID) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    
    /////////////////
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
    }*/
}
