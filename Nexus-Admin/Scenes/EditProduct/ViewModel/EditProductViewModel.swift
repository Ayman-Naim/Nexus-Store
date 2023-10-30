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
        case .productType:
            guard let type = value.first else { return }
            sendUpdateProductRequest(with: urlString + ".json", method: .put, params: ["product": ["product_type": type]])
        case .description:
            guard let description = value.first else { return }
            sendUpdateProductRequest(with: urlString + ".json", method: .put, params: ["product": ["body_html": description]])
        case .addImage:
            guard let urlString = value.first else { return }
            // Check if URL is Valid
            let urlRegEx = "((?:http|https)://)?(?:www\\.)?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?"
            if NSPredicate(format: "SELF MATCHES %@", urlRegEx).evaluate(with: urlString) {
                sendUpdateProductRequest(with: urlString + "/images.json", method: .post, params: ["image": ["src": urlString]])
            } else {
                self.error?("The URL you added is not valid!")
            }
            
        case .addSizeColor:
            guard value.count > 0 else { return }
            let size = value[0]
            let color = value[1]
            createVariant(size: size, color: color)
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
    
    private func createVariant(size: String, color: String) {
        let urlString = K.baseURL + "/products/\(productID)/variants.json"
        let params = [
            "variant": [
                "option1": size,
                "option2": color
            ] as [String : Any]
        ]
        
        AF.request(urlString, method: .post, parameters: params, headers: K.APIHeader).response { response in
            switch response.result {
            case .success(let data):
                guard let data = data, let dataString = String(data: data, encoding: .utf8) else { return }
                if dataString.contains("error") {
                    print(dataString)
                } else {
                    self.saved?(true)
                }
                
            case .failure(let error):
                self.error?(error.localizedDescription)
            }
        }
    }
}
