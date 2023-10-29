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
    
    func editProduct(type: EditProductViewController.EditType, value: String...) {
        let urlString = K.baseURL + "/products/\(productID)"
        
        switch type {
        case .title:
            guard let title = value.first else { return }
            sendUpdateProductRequest(with: urlString + ".json", method: .put, params: ["product": ["title": title]])
//        case .productType:
//            guard let type = value.first else { return }
//            sendUpdateProductRequest(with: urlString + ".json", method: .put, params: ["product": ["product_type": type]])
        case .description:
            guard let description = value.first else { return }
            sendUpdateProductRequest(with: urlString + ".json", method: .put, params: ["product": ["body_html": description]])
        case .addImage:
            guard let urlString = value.first else { return }
            if let _ = URL(string: urlString)  {
                sendUpdateProductRequest(with: urlString + "/images.json", method: .post, params: ["image": ["src": urlString]])
            } else {
                self.error?("The URL you added is not valid!")
            }
            
        case .addSizeColor:
            print(value)
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
