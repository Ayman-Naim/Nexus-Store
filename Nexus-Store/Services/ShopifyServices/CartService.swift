//
//  CartService.swift
//  Nexus-Store
//
//  Created by Khater on 26/10/2023.
//

import Foundation
import Alamofire


class CartService {
    
    private let draftOrderSerivce = DraftOrderService()
    
    private let baseURLString = "https://ios-q1-new-capital-admin1-2023.myshopify.com/admin/api/2023-01/draft_orders"
    private let header: HTTPHeaders = ["X-Shopify-Access-Token": "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"]
    
    
    
    // MARK: - Public Functions
    func getCartProducts(forCustomerID customerID: Int, completion: @escaping (Result<[CartProduct], Error>) -> Void) {
        draftOrderSerivce.customerDraftOrders(customerID: customerID) { result in
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
    
    func addProductToCart(forCustomerID customerID: Int, variantID: Int, quantity: Int, imageURLString: String, completion: @escaping (Error?) -> Void) {
        draftOrderSerivce.customerDraftOrders(customerID: customerID) { result in
            switch result {
            case .success(let draftOrders):
                 // Check if there is draft order contain the same variant ID in it's line items
                if draftOrders.contains(where: { $0.lineItems.contains(where: { $0.variantID == variantID }) }) {
                    completion(K.customError(message: "The product is already in the cart"))
                } else {
                    self.draftOrderSerivce.createDraftOrder(forCustomer: customerID, variantID: variantID, quantity: quantity, imageURLString: imageURLString) { result in
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
