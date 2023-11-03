//
//  ProductsOrderSheetViewModel.swift
//  Nexus-Store
//
//  Created by Khater on 03/11/2023.
//

import Foundation
import Alamofire


class ProductsOrderSheetViewModel {
    private let baseURL = "https://ios-q1-new-capital-admin1-2023.myshopify.com/admin/api/2023-01"
    private let header: HTTPHeaders = ["X-Shopify-Access-Token": "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"]
    
    
    // MARK: - Clouser
    var reload: (() -> Void)?
    var loadingIndicator: ((Bool) -> Void)?
    var errorOccure: ((String) -> Void)?
    
    
    
    // MARK: - Functions
    func fetchOrders() {
        
    }
    
    func fetchDefaultAddress() {
        let url = baseURL + "/customers/\(K.customerID)/addresses.json"
        
        loadingIndicator?(true)
        
        AF.request(url, method: .get, headers: header).responseDecodable(of: CustomerAddressResponse.self) { response in
            
            DispatchQueue.main.async {
                self.loadingIndicator?(false)
            }
            
            switch response.result {
            case .success(let addressesRespone):
                guard let addresses = addressesRespone.results else { return }
                let defaultAddress = addresses.first(where: { $0.isDefault })
                
            case .failure(let error):
                self.errorOccure?(error.localizedDescription)
            }
        }
    }
}
