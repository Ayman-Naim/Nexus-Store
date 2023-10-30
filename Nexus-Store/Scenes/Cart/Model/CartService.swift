//
//  CartService.swift
//  Nexus-Store
//
//  Created by Khater on 26/10/2023.
//

import Foundation
import Alamofire


fileprivate let CUSTOMER = 6899149865196
fileprivate let MOCKPRODUCT = Product(id: 8031031787756, title: "ADIDAS | CLASSIC BACKPACK", bodyHtml: nil, vendor: "ADIDAS", productType: "ACCESSORIES", createdAt: nil, handle: nil, updatedAt: nil, publishedAt: nil, status: nil, publishedScope: nil, tags: nil, adminGraphqlApiId: nil, variants: [Variants(id: 44007215464684, productId: 44007215464684, price: "70.00")], image: Image(id: 39285105197292, productId: 8031031787756, position: nil, createdAt: nil, updatedAt: nil, width: nil, height: nil, src: "https://cdn.shopify.com/s/files/1/0668/7650/6348/products/85cc58608bf138a50036bcfe86a3a362.jpg?v=1698170984", adminGraphqlApiId: nil))









//struct ShippinAddress: Codable {
//
//}

//struct AppliedDiscount: Codable {
//    let title: String
//    let value: String
//    let amount: String
//    let valueType: ValueType
//
//
//    enum ValueType: String, Codable {
//        case fixed = "fixed_amount"
//        case percentage
//    }
//}


class CartService {
    private let baseURLString = "https://ios-q1-new-capital-admin1-2023.myshopify.com/admin/api/2023-01/draft_orders"
    private let header: HTTPHeaders = ["X-Shopify-Access-Token": "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"]
    
    
    // MARK: - Helpers
    private func customError(message: String) -> Error {
        return NSError(domain: "Error", code: 400, userInfo: [NSLocalizedDescriptionKey: message])
    }
    
    private func testResponse(withURLString urlString: String) {
        AF.request(urlString, method: .get, encoding: JSONEncoding.default, headers: header).response { response in
            switch response.result {
            case .success(let data):
                guard let data = data else {
                    print("Test Response Error || No Data from response")
                    return
                }
                print(String(data: data, encoding: .utf8) ?? "Test Response Error || Decoding Response")
            case .failure(let error):
                print("Test Response Error || \(error)")
            }
        }
    }
    
    
    // MARK: - Private Functions
    private func fetchDraftOrders(completion: @escaping (Result<[DraftOrder], Error>) -> Void) {
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
    
    private func customerDraftOrders(customerID: Int, completion: @escaping (Result<[DraftOrder], Error>) -> Void) {
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
    
    private func createDraftOrder(forCustomer customerID: Int, variantID: Int, imageURLString: String, completion: @escaping (Result<DraftOrder, Error>) -> Void) {
        let urlString = baseURLString + ".json"
        
        let params = [
            "draft_order": [
                "line_items": [
                    [
                        "variant_id": variantID,
                        "quantity": 1,
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
    
    
    // MARK: - Public Functions
    func getCartProducts(forCustomerID customerID: Int, completion: @escaping (Result<[CartProduct], Error>) -> Void) {
        customerDraftOrders(customerID: customerID) { result in
            switch result {
            case .success(let draftOrders):
                let cartProducts = draftOrders.map({ CartProduct(draftOrderID: $0.id,
                                                                 variantID: $0.lineItems.first!.variantID!,
                                                                 title: $0.lineItems.first!.productTitle,
                                                                 price: Double($0.lineItems.first!.productPrice)!,
                                                                 image: $0.lineItems.first!.properties.first!.value,
                                                                 quantity: $0.lineItems.first!.quantity) })
                completion(.success(cartProducts))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func addProductToCart(forCustomerID customerID: Int, variantID: Int, imageURLString: String, completion: @escaping (Error?) -> Void) {
        customerDraftOrders(customerID: customerID) { result in
            switch result {
            case .success(let draftOrders):
                 // Check if there is draft order contain the same variant ID in it's line items
                if draftOrders.contains(where: { $0.lineItems.contains(where: { $0.variantID == variantID }) }) {
                    completion(self.customError(message: "The product is already in the cart"))
                } else {
                    self.createDraftOrder(forCustomer: customerID, variantID: variantID, imageURLString: imageURLString) { result in
                        switch result {
                        case .success(_):
                            completion(nil)
                        case .failure(let error):
                            completion(error)
                        }
                    }
                }
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    func updateQuantity(ofProduct cartProduct: CartProduct, withQuantity quantity: Int, toCustomer customerID: Int, completion: @escaping (Error?) -> Void){
        let urlString = baseURLString + "/\(cartProduct.draftOrderID).json"
        
        let params = [
            "draft_order": [
                "line_items": [
                    [
                        "variant_id": cartProduct.variantID,
                        "quantity": quantity,
                        "properties": [
                              [
                                "name": "imageSrc",
                                "value": cartProduct.image
                              ]
                        ]
                    ] as [String : Any]
                ]
            ]
        ]
        
        AF.request(urlString, method: .put, parameters: params, headers: header).response { response in
            switch response.result {
            case .success(_):
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    func removeProductFromCart(_ cartProduct: CartProduct, customerID: Int, completion: @escaping (Error?) -> Void) {
        let urlString = baseURLString + "/\(cartProduct.draftOrderID).json"
        AF.request(urlString, method: .delete, headers: header).response { response in
            switch response.result {
            case .success(_):
                completion(nil)
            case.failure(let error):
                completion(error)
            }
        }
    }
    
    
    
    init() {
        print("CartService init")
    }
    
    deinit {
        print("CartService deinit")
    }
}
