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
        draftOrderSerivce.customerDraftOrder(customerID: customerID) { result in
            switch result {
            case .success(let draftOrder):
                let cartProducts = draftOrder.lineItems.filter({ $0.variantID != nil }).map({ CartProduct(draftOrderID: draftOrder.id,
                                                                                                          variantID: $0.variantID!,
                                                                                                          productID: $0.productID!,
                                                                                                          title: $0.productTitle,
                                                                                                          price: Double($0.productPrice) ?? 0,
                                                                                                          image: $0.properties.first?["value"] ?? "",
                                                                                                          quantity: $0.quantity) })
                completion(.success(cartProducts))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func addProductToCart(forCustomerID customerID: Int, variantID: Int, quantity: Int, imageURLString: String, completion: @escaping (Error?) -> Void) {
        draftOrderSerivce.addNewLineItem(customerID: customerID, variantID: variantID, quantity: quantity, imageURLString: imageURLString) { error in
            if let error = error {
                completion(error)
                return
            }
            self.draftOrderSerivce.customerDraftOrder(customerID: customerID) { result in
                switch result {
                case .success(let draftOrder):
                    if draftOrder.lineItems.contains(where: { $0.variantID == variantID }) {
                        completion(nil)
                    } else {
                        self.draftOrderSerivce.addNewLineItem(customerID: customerID, variantID: variantID, quantity: quantity, imageURLString: imageURLString, completion: completion)
                    }
                case .failure(let error):
                    completion(error)
                }
            }
        }
    }
    
    func updateQuantity(ofProduct cartProduct: CartProduct, withQuantity quantity: Int, toCustomer customerID: Int, completion: @escaping (Error?) -> Void){
        draftOrderSerivce.updateLineItemQuantity(customerID: customerID, variantID: cartProduct.variantID, newQuantity: quantity, completion: completion)
    }
    
    
    
    func removeProductFromCart(_ cartProduct: CartProduct, customerID: Int, completion: @escaping (Error?) -> Void) {
        draftOrderSerivce.deleteLineItem(customerID: customerID, variantID: cartProduct.variantID, completion: completion)
    }
    
    
    func imageForProduct(withProductID productID: Int, completion: @escaping (String) -> Void) {
        let url = "https://ios-q1-new-capital-admin1-2023.myshopify.com/admin/api/2023-01/products/\(productID).json"
        AF.request(url, method: .get, headers: header).response { response in
            switch response.result {
            case .success(let data):
                guard let data = data else { return }
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if let product = json["product"] as? [String: Any], let image = product["image"] as? [String: Any] {
                            if let src = image["src"] as? String {
                                completion(src)
                            }
                        }
                    }
                } catch let error as NSError {
                    print("Failed to load: \(error)")
                }
                
            case .failure(let error):
                print("Failed to load: \(error)")
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
