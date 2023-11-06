//
//  OrderDetailsSheetViewModel.swift
//  Nexus-Store
//
//  Created by Khater on 03/11/2023.
//

import Foundation
import Alamofire


class OrderDetailsSheetViewModel {
    private let baseURL = "https://ios-q1-new-capital-admin1-2023.myshopify.com/admin/api/2023-01"
    private let header: HTTPHeaders = ["X-Shopify-Access-Token": "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"]
    
    
    private var defaultAddress: Address?
    private var products: [CartProduct] = []
    
    let cartService = CartService()
    
    
    // MARK: - Clouser
    var reload: (() -> Void)?
    var loadingIndicator: ((Bool) -> Void)?
    var errorOccure: ((_ title: String, _ message: String) -> Void)?
    
    
    // MARK: - DataSource
    func numberOfRow(in section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return products.count
        default: return 0
        }
    }
    
    func configAddress(_ cell: AddressCell) {
        guard let address = defaultAddress else { return }
        cell.selecteAddress(true)
        cell.setAddress(address)
    }
    
    func configProduct(_ cell: ProductLandscapeCell, at index: Int) {
        let product = products[index]
        cell.hideButtons()
        cell.setCell(id: product.draftOrderID)
        cell.setProduct(product)
        cartService.imageForProduct(withProductID: product.productID) { imageURL in
            cell.setImage(with: imageURL)
        }
    }
    
    
    
    // MARK: - Functions
    func fetchOrders() {
        loadingIndicator?(true)
        
        cartService.getCartProducts(forCustomerID: K.customerID) { result in
            DispatchQueue.main.async {
                self.loadingIndicator?(false)
            }
            switch result {
            case .success(let products):
                self.products = products
                DispatchQueue.main.async {
                    self.reload?()
                }
            case .failure(let error):
                self.errorOccure?("Orders", error.localizedDescription)
            }
        }
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
                if let defaultAddress = addresses.first(where: { $0.isDefault }) {
                    self.defaultAddress = defaultAddress
                    DispatchQueue.main.async {
                        self.reload?()
                    }
                }
                
            case .failure(let error):
                self.errorOccure?("Address", error.localizedDescription)
            }
        }
    }
}
