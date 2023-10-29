//
//  EditProductViewModel.swift
//  Nexus-Admin
//
//  Created by Khater on 28/10/2023.
//

import Foundation
import Alamofire


class EditProductViewModel {
    
    private let productID: Int
    
    var error: ((String) -> Void)?
    var saved: ((Bool) -> Void)?
    var loading: ((Bool) -> Void)?
    
    init(productID: Int) {
        self.productID = productID
    }
    
    func editProduct(type: EditProductViewController.EditType, value: String) {
        let urlString = K.baseURL + "/products/\(productID)"
        
        switch type {
        case .title:
            sendUpdateProductRequest(with: urlString + ".json", method: .put, params: ["product": ["title": value]])
        case .productType:
            sendUpdateProductRequest(with: urlString + ".json", method: .put, params: ["product": ["product_type": value]])
        case .description:
            sendUpdateProductRequest(with: urlString + ".json", method: .put, params: ["product": ["body_html": value]])
        case .addImage:
            if value.isEmpty {
                self.error?("Need to add url to the image in text field")
            } else {
                sendUpdateProductRequest(with: urlString + "/images.json", method: .post, params: ["image": ["src": value]])
            }
        }
    }
    
    private func sendUpdateProductRequest(with urlString: String, method: HTTPMethod, params: Parameters){
        loading?(true)
        AF.request(urlString, method: method, parameters: params, headers: K.APIHeader).response { response in
            DispatchQueue.main.async {
                self.loading?(false)
            }
            switch response.result {
            case .success(let data):
                print(String(data: data!, encoding: .utf8) ?? "")
                self.saved?(data != nil)
                
            case .failure(let error):
                self.error?(error.localizedDescription)
            }
        }
    }
}
