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
    
    
    func fetchDraftOrders(completion: @escaping (Result<[DraftOrder], Error>) -> Void) {
        let urlString = baseURLString + ".json"
        AF.request(urlString, method: .get, encoding: JSONEncoding.default, headers: header).responseDecodable(of: DraftOrderResponse.self) { response in
            switch response.result {
            case .success(let draftOrders):
                guard let draftOrdersResult = draftOrders.result else {
                    completion(.failure(K.customError(message: "No result for draft orders")))
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
    
    func createDraftOrder(forCustomer customerID: Int, variantID: Int, quantity: Int, imageURLString: String, completion: @escaping (Result<DraftOrder, Error>) -> Void) {
        let urlString = baseURLString + ".json"
        
        let params = [
            "draft_order": [
                "line_items": [
                    [
                        "variant_id": variantID,
                        "quantity": quantity,
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
                    completion(.failure(K.customError(message: "Created a draft order for the user but single result is nil")))
                    return
                }
                
                completion(.success(customerNewDraftOrder))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func convertToOrder(customerID: Int, completion: @escaping (Result<DraftOrder, Error>) -> Void) {
        customerDraftOrders(customerID: customerID) { result in
            switch result {
            case .success(let draftOrders):
                let lineItems = draftOrders.compactMap({ $0.lineItems.first })
                guard let lineItemsData = try? JSONEncoder().encode(lineItems) else { return }
                guard let lineItemsJSON = try? JSONSerialization.jsonObject(with: lineItemsData, options: [.fragmentsAllowed]) else { return }
                
                let urlString = self.baseURLString + ".json"
                let params = [
                    "draft_order": [
                        "note": "FullOrder",
                        "line_items": lineItemsJSON,
                        "customer": [
                            "id": customerID
                        ]
                    ]
                ]
                
                AF.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: self.header).responseDecodable(of: DraftOrderResponse.self) { response in
                    switch response.result {
                    case .success(let draftOrderResponse):
                        guard let draftOrder = draftOrderResponse.singleResult else { return }
                        completion(.success(draftOrder))
                        self.deleteNotFullDraftOrder(customerID: customerID, failure: { completion(.failure($0) )})
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
                
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func deleteNotFullDraftOrder(customerID: Int, failure: @escaping (Error) -> Void) {
        customerDraftOrders(customerID: customerID) { result in
            switch result {
            case .success(let draftOrders):
                let notFullDraftOrders = draftOrders.filter{ $0.note == nil }
                
                let url = "https://ios-q1-new-capital-admin1-2023.myshopify.com/admin/api/2023-01/draft_orders"
                for index in notFullDraftOrders.indices {
                    let orderID = notFullDraftOrders[index].id
                    AF.request(url + "/\(orderID).json", method: .delete, headers: self.header).response { _ in }
                }
                
            case .failure(let error):
                failure(error)
            }
        }
    }
}
