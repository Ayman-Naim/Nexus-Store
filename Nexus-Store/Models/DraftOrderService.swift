//
//  DraftOrderService.swift
//  Nexus-Store
//
//  Created by Khater on 30/10/2023.
//

import Foundation
import Alamofire


class DraftOrderService {
    
    private let baseURLString = "https://ios-q1-new-capital-admin1-2023.myshopify.com/admin/api/2023-01/draft_orders"
    private let header: HTTPHeaders = ["X-Shopify-Access-Token": "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"]
    
    
    // MARK: - Helpers
    private func customError(message: String) -> Error {
        return NSError(domain: "Error", code: 400, userInfo: [NSLocalizedDescriptionKey: message])
    }
    
    func fetchDraftOrders(completion: @escaping (Result<[DraftOrder], Error>) -> Void) {
        let urlString = baseURLString + ".json"
        AF.request(urlString, method: .get, encoding: JSONEncoding.default, headers: header).responseDecodable(of: DraftOrderResponse.self) { response in
            switch response.result {
            case .success(let draftOrders):
                guard let draftOrdersResult = draftOrders.result else {
                    completion(.failure(self.customError(message: "No result for draft orders")))
                    return
                }
                completion(.success(draftOrdersResult))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func customerDraftOrders(customerID: Int, completion: @escaping (Result<[DraftOrder], Error>) -> Void) {
        fetchDraftOrders { result in
            switch result {
            case .success(let draftOrders):
                if draftOrders.contains(where: { $0.customer.id == customerID }) {
                    let customerDraftOrders = draftOrders.filter({ $0.customer.id == customerID })
                    completion(.success(customerDraftOrders))
                    print("CustomerDraftOrders (aka Cart Products) Count: \(customerDraftOrders.count)")
                } else {
                    completion(.success([]))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func createDraftOrder(forCustomer customerID: Int, variantID: Int, imageURLString: String, completion: @escaping (Result<DraftOrder, Error>) -> Void) {
        let urlString = baseURLString + ".json"
        
        let params = [
            "draft_order": [
                "line_items": [
                    [
                        "variant_id": variantID,
                        "quantity": 1,  // TODO: Get quantity from the user
                        "properties": [
                              [
                                "name": "imageSrc",
                                "value": imageURLString
                              ]
                        ]
                    ] as [String : Any?]
                ],
                "customer": [
                    "id": customerID
                ]
            ] as [String : Any]
        ]
        
        AF.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header).responseDecodable(of: DraftOrderResponse.self) { response in
            switch response.result {
            case .success(let newDraftOrder):
                print("Create Draft Order of Customer with ID: \(customerID)")
                guard let customerNewDraftOrder = newDraftOrder.singleResult else {
                    completion(.failure(self.customError(message: "Created a draft order for the user but single result is nil")))
                    return
                }
                
                completion(.success(customerNewDraftOrder))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
