//
//  DraftOrderService.swift
//  Nexus-Store
//
//  Created by Khater on 30/10/2023.
//

import Foundation
import Alamofire


//class DraftOrderService {
//
//    private let baseURLString = "https://ios-q1-new-capital-admin1-2023.myshopify.com/admin/api/2023-01/draft_orders"
//    private let header: HTTPHeaders = ["X-Shopify-Access-Token": "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"]
//
//
//    private func fetchDraftOrders(completion: @escaping (Result<[DraftOrder], Error>) -> Void) {
//        let urlString = baseURLString + ".json"
//        AF.request(urlString, method: .get, encoding: JSONEncoding.default, headers: header).responseDecodable(of: DraftOrderResponse.self) { response in
//            switch response.result {
//            case .success(let draftOrders):
//                guard let draftOrdersResult = draftOrders.result else {
//                    completion(.failure(K.customError(message: "No result for draft orders")))
//                    return
//                }
//                completion(.success(draftOrdersResult))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
//
//    func customerDraftOrders(customerID: Int, completion: @escaping (Result<[DraftOrder], Error>) -> Void) {
//        fetchDraftOrders { result in
//            switch result {
//            case .success(let draftOrders):
//                if draftOrders.contains(where: { $0.customer.id == customerID }) {
//                    let customerDraftOrders = draftOrders.filter({ $0.customer.id == customerID })
//                    completion(.success(customerDraftOrders))
//                    print("CustomerDraftOrders (aka Cart Products) Count: \(customerDraftOrders.count)")
//                } else {
//                    completion(.success([]))
//                }
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
//
//    func createDraftOrder(forCustomer customerID: Int, variantID: Int, quantity: Int, imageURLString: String, completion: @escaping (Result<DraftOrder, Error>) -> Void) {
//        let urlString = baseURLString + ".json"
//
//        let params = [
//            "draft_order": [
//                "line_items": [
//                    [
//                        "variant_id": variantID,
//                        "quantity": quantity,
//                        "properties": [
//                              [
//                                "name": "imageSrc",
//                                "value": imageURLString
//                              ]
//                        ]
//                    ] as [String : Any?]
//                ],
//                "customer": [
//                    "id": customerID
//                ]
//            ] as [String : Any]
//        ]
//
//        AF.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header).responseDecodable(of: DraftOrderResponse.self) { response in
//            switch response.result {
//            case .success(let newDraftOrder):
//                print("Create Draft Order of Customer with ID: \(customerID)")
//                guard let customerNewDraftOrder = newDraftOrder.singleResult else {
//                    completion(.failure(K.customError(message: "Created a draft order for the user but single result is nil")))
//                    return
//                }
//
//                completion(.success(customerNewDraftOrder))
//
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
//
//    func convertToOrder(customerID: Int, completion: @escaping (Result<DraftOrder, Error>) -> Void) {
//        customerDraftOrders(customerID: customerID) { result in
//            switch result {
//            case .success(let draftOrders):
//                let lineItems = draftOrders.compactMap({ $0.lineItems.first })
//                guard let lineItemsData = try? JSONEncoder().encode(lineItems) else { return }
//                guard let lineItemsJSON = try? JSONSerialization.jsonObject(with: lineItemsData, options: [.fragmentsAllowed]) else { return }
//
//                let urlString = self.baseURLString + ".json"
//                let params = [
//                    "draft_order": [
//                        "note": "FullOrder",
//                        "line_items": lineItemsJSON,
//                        "customer": [
//                            "id": customerID
//                        ]
//                    ]
//                ]
//
//                AF.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: self.header).responseDecodable(of: DraftOrderResponse.self) { response in
//                    switch response.result {
//                    case .success(let draftOrderResponse):
//                        guard let draftOrder = draftOrderResponse.singleResult else { return }
//                        completion(.success(draftOrder))
//                        self.deleteNotFullDraftOrder(customerID: customerID, failure: { completion(.failure($0) )})
//                    case .failure(let error):
//                        completion(.failure(error))
//                    }
//                }
//
//
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
//
//    func deleteNotFullDraftOrder(customerID: Int, failure: @escaping (Error) -> Void) {
//        customerDraftOrders(customerID: customerID) { result in
//            switch result {
//            case .success(let draftOrders):
//                let notFullDraftOrders = draftOrders.filter{ $0.note == nil }
//
//                let url = "https://ios-q1-new-capital-admin1-2023.myshopify.com/admin/api/2023-01/draft_orders"
//                for index in notFullDraftOrders.indices {
//                    let orderID = notFullDraftOrders[index].id
//                    AF.request(url + "/\(orderID).json", method: .delete, headers: self.header).response { _ in }
//                }
//
//            case .failure(let error):
//                failure(error)
//            }
//        }
//    }
//}



// MARK: - DraftOderService 2
class DraftOrderService {
    private let baseURLString = "https://ios-q1-new-capital-admin1-2023.myshopify.com/admin/api/2023-01/draft_orders"
    private let header: HTTPHeaders = ["X-Shopify-Access-Token": "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"]
    
    
    // MARK: - Customer Draft Order
    func customerDraftOrder(customerID: Int, completion: @escaping (Result<DraftOrder, Error>) -> Void) {
        fetchDraftOrders { result in
            switch result {
            case .success(let draftOrders):
                if let customerDraftOrder = draftOrders.first(where: { $0.customer.id == customerID }) {
                    completion(.success(customerDraftOrder))
                } else {
                    // Create Draft Order
                    self.createFirstDraftOrder(customerID: customerID, completion: completion)
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    // MARK: - Add Product to Draft Order LineItems
    func addNewLineItem(customerID: Int, variantID: Int, quantity: Int, imageURLString: String, completion: @escaping (Error?) -> Void) {
        customerDraftOrder(customerID: customerID) { result in
            switch result {
            case .success(let draftOrder):
                if draftOrder.lineItems.contains(where: { $0.variantID == variantID }) {
                    // Check if Product is exsits
                    completion(K.customError(message: "Product is already added"))
                    return
                }
                
                var lineItems = draftOrder.lineItems
                lineItems.append(.init(id: 0,
                                       variantID: variantID,
                                       quantity: quantity,
                                       properties: [["name": "imageSrc", "value": imageURLString]],
                                       productID: nil,
                                       productTitle: "",
                                       productVendor: nil,
                                       productPrice: ""))
                
                guard let lineItemsData = try? JSONEncoder().encode(lineItems) else { return }
                guard let lineItemsJSON = try? JSONSerialization.jsonObject(with: lineItemsData, options: [.fragmentsAllowed]) as? [[String: Any]] else { return }
                
                let params = [
                    "draft_order": [
                        "line_items": lineItemsJSON,
                        "customer": [
                            "id": customerID
                        ]
                    ] as [String : Any]
                ]
                
                self.updateDraftOrder(id: draftOrder.id, params: params, completion: completion)
                
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    
    // MARK: - Delete Product from Draft Order LineItems
    func deleteLineItem(customerID: Int, variantID: Int, completion: @escaping (Error?) -> Void){
        customerDraftOrder(customerID: customerID) { result in
            switch result {
            case .success(let draftOrder):
                var lineItems = draftOrder.lineItems
                lineItems.removeAll(where: { $0.variantID == variantID })
                guard let lineItemsData = try? JSONEncoder().encode(lineItems) else { return }
                guard let lineItemsJSON = try? JSONSerialization.jsonObject(with: lineItemsData, options: [.fragmentsAllowed]) as? [[String: Any]] else { return }
                
                let params: [String: Any] = [
                    "draft_order": [
                        "line_items": lineItemsJSON,
                        "customer": [
                            "id": customerID
                        ]
                    ] as [String : Any]
                ]
                
                self.updateDraftOrder(id: draftOrder.id, params: params, completion: completion)
                
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    
    
    // MARK: - Update Product Quantity in Draft Order LineItem
    func updateLineItemQuantity(customerID: Int, variantID: Int, newQuantity quantity: Int, completion: @escaping (Error?) -> Void) {
        customerDraftOrder(customerID: customerID) { result in
            switch result {
            case .success(let draftOrder):
                self.canUpdate(quantity: quantity, forVariantID: variantID) { canUpdate in
                    if !canUpdate {
                        completion(K.customError(message: "You have reached max limit of quantity"))
                    } else {
                        var lineItems = draftOrder.lineItems
                        
                        if let index = lineItems.firstIndex(where: { $0.variantID == variantID }) {
                            lineItems[index].quantity = quantity
                        }
                        
                        guard let lineItemsData = try? JSONEncoder().encode(lineItems) else { return }
                        guard let lineItemsJSON = try? JSONSerialization.jsonObject(with: lineItemsData, options: [.fragmentsAllowed]) as? [[String: Any]] else { return }
                        
                        print("any value", terminator: Array(repeating: "\n", count: 100).joined())
                        print(draftOrder.lineItems)
                        print("========================================")
                        print(lineItemsJSON)
                        
                        let params = [
                            "draft_order": [
                                "line_items": lineItemsJSON,
                                "customer": [
                                    "id": customerID
                                ]
                            ] as [String : Any]
                        ]
                        
                        self.updateDraftOrder(id: draftOrder.id, params: params, completion: completion)
                    }
                }
                
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    
    
    // MARK: - Private Helper Functions
    private func fetchDraftOrders(completion: @escaping (Result<[DraftOrder], Error>) -> Void) {
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
    
    private func canUpdate(quantity: Int, forVariantID variantID: Int, completion: @escaping (Bool) -> Void) {
        AF.request("https://ios-q1-new-capital-admin1-2023.myshopify.com/admin/api/2023-01/variants/\(variantID).json", method: .get, headers: header).response { response in
            switch response.result {
            case .success(let data):
                guard let data = data else {
                    //completion(K.customError(message: "No Data for variant: \(variantID)"))
                    completion(false)
                    return
                }
                do {
                    if let responseJSON = try JSONSerialization.jsonObject(with: data, options: [.fragmentsAllowed]) as? [String: Any] {
                        if let variant = responseJSON["variant"] as? [String: Any], let inventoryQuantity = variant["inventory_quantity"] as? Int  {
                            if quantity <= Int(Double(inventoryQuantity) * 0.5) {
                                completion(true)
                            } else {
                                completion(false)
                            }
                        }
                    }
                } catch let error {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func updateDraftOrder(id: Int, params: [String: Any], completion: @escaping (Error?) -> Void) {
        let url = self.baseURLString + "/\(id).json"
        AF.request(url, method: .put, parameters: params, headers: self.header).response { response in
            switch response.result {
            case .success(let data):
                guard let _ = data else { return }
//                print("any value", terminator: Array(repeating: "\n", count: 100).joined())
//                print(String(data: data, encoding: .utf8) ?? " Nil ")
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    private func createFirstDraftOrder(customerID: Int, completion: @escaping (Result<DraftOrder, Error>) -> Void) {
        let url = baseURLString + ".json"
        
        let lineItem = [LineItem(id: 0, variantID: nil, quantity: 1, properties: [], productID: nil, productTitle: "FirstEver", productVendor: nil, productPrice: "0")]
        guard let lineItemData = try? JSONEncoder().encode(lineItem) else { return }
        guard let lineItemJSON = try? JSONSerialization.jsonObject(with: lineItemData, options: [.fragmentsAllowed]) as? [[String: Any]] else { return }
        
        let params = [
            "draft_order": [
                "line_items": lineItemJSON,
                "customer": [
                    "id": customerID
                ]
            ] as [String : Any]
        ]
        
        AF.request(url, method: .post, parameters: params, headers: header).responseDecodable(of: DraftOrderResponse.self) { response in
            switch response.result {
            case .success(let draftOrderResponse):
                guard let newDraftOrder = draftOrderResponse.singleResult else { return }
                completion(.success(newDraftOrder))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
