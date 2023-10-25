//
//  WishListService.swift
//  Nexus-Store
//
//  Created by Khater on 25/10/2023.
//

import Foundation
import Alamofire

struct ProductTest: Codable {
    
}

struct Metafields: Codable {
    let metafield: Metafield? // Single
    let metafields: [Metafield]? // All
}

struct Metafield: Codable {
    let id: Int
    let key, value: String
    let ownerID: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case key
        case value
        case ownerID = "owner_id"
    }
}

struct Products: Codable {
    let products: [Product]
}

struct Product: Codable {
    let id: Int
    let title: String
    let descrip: String
    let vendor: String
    let productType: String
    let tags: String
    let status: String
    let images: [Image]
    let image: Image
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case descrip = "body_html"
        case vendor
        case productType = "product_type"
        case tags
        case status
        case images
        case image
    }
}

struct Image: Codable {
    let id: Int
    let urlString: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case urlString = "src"
    }
}


class WishListService {
    private let baseURLString = "https://b088a15054821f0f76c1eb98b594061a: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@ios-q1-new-capital-admin1-2023.myshopify.com/admin/api/2023-01"
    private lazy var customersEndpoint = baseURLString + "/customers"
    private let header: HTTPHeaders = ["X-Shopify-Access-Token": "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"]
    
    func addToWishList(productID: Int, toCustomer customerID: Int, completion: @escaping (Error?) -> Void) {
        let url = customersEndpoint + "/\(customerID)/metafields.json"
        
        let body: [String: Any] = [
            "metafield": [
                "namespace": "WishList",
                "key": productID, // Product ID
                "value": "Product", // Product Name
                "owner_id": customerID, // Customer ID
                "type": "single_line_text_field"
            ] as [String : Any]
        ]
        
        AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header).response { response in
            switch response.result {
            case .success(let data):
                guard let data = data else { return }
                do {
                    let _ = try JSONDecoder().decode(Metafields.self, from: data)
                    completion(nil)

                } catch {
                    completion(error)
                }
                
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    
    func removeWishList(productID: Int, fromCustomer customerID: Int, completion: @escaping (Error?) -> Void) {
        getMetaField(forProduct: productID, andCustomer: customerID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let metafild):
                let url = self.customersEndpoint + "/\(customerID)/metafields/\(metafild.id).json"
                AF.request(url, method: .delete, headers: self.header).response { response in
                    switch response.result {
                    case .success(_):
                        completion(nil)
                    case .failure(let error):
                        completion(error)
                    }
                }
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    func getWishlist(forCustom customerID: Int, completion: @escaping (Result<[Product], Error>) -> Void) {
        fetchAllMetafields(forCustom: customerID) { result in
            switch result {
            case .success(let wishListMetafield):
                guard !wishListMetafield.isEmpty else {
                    completion(.success([]))
                    return
                }
                let stringIDs = wishListMetafield.compactMap( { String($0.key) }).joined(separator: ",")
                let url = self.baseURLString + "/products.json?ids=\(stringIDs)"
                AF.request(url, method: .get, headers: self.header).responseDecodable(of: Products.self) { response in
                    switch response.result {
                    case .success(let data):
                        completion(.success(data.products))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    
    
    // MARK: - Helpers
    private func getMetaField(forProduct productID: Int, andCustomer customerID: Int, completion: @escaping (Result<Metafield, Error>) -> Void){
        let url = customersEndpoint + "/\(customerID)/metafields.json?key=\(productID)"
        AF.request(url, method: .get, headers: header).responseDecodable(of: Metafields.self) { response in
            switch response.result {
            case .success(let data):
                guard let metafield = data.metafields?.first else { return }
                completion(.success(metafield))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    private func fetchAllMetafields(forCustom customerID: Int, completion: @escaping (Result<[Metafield], Error>) -> Void) {
        let url = customersEndpoint + "/\(customerID)/metafields.json"
        AF.request(url, method: .get, headers: header).responseDecodable(of: Metafields.self) { response in
            switch response.result {
            case .success(let data):
                guard let metafields = data.metafields else {
                    completion(.success([]))
                    return
                }
                
                completion(.success(metafields))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
