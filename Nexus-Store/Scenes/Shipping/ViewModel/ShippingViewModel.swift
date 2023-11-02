//
//  ShippingViewModel.swift
//  Nexus-Store
//
//  Created by Khater on 30/10/2023.
//

import Foundation
import Alamofire


class ShippingViewModel {
    
    // MARK: - Properties
    private let baseURL = "https://ios-q1-new-capital-admin1-2023.myshopify.com/admin/api/2023-01"
    private let header: HTTPHeaders = ["X-Shopify-Access-Token": "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"]
    
    
    private var customerID: Int
    private var customerAdresses: [Address] = [] {
        didSet {
            if let defaultIndex = customerAdresses.firstIndex(where: { $0.isDefault }) {
                let defaultAddress = customerAdresses.remove(at: defaultIndex)
                customerAdresses.insert(defaultAddress, at: 0)
            }
            DispatchQueue.main.async {
                self.reload?()
            }
        }
    }
    
    init(customerID: Int) {
        self.customerID = customerID
    }
    
    
    // MARK: - Clouser
    var reload: (() -> Void)?
    var loadingIndicator: ((Bool) -> Void)?
    var errorOccure: ((String) -> Void)?
    
    
    
    // MARK: - DataSource
    var numberOfRow: Int { customerAdresses.count }

    func config(cell: AddressTableViewCell, at index: Int) {
        let address = customerAdresses[index]
        cell.setAddress(address)
        cell.selecteAddress(address.isDefault)
    }
    
    func didSelectCell(at index: Int) {
        if !customerAdresses[index].isDefault {
            let addressID = customerAdresses[index].id
            updateCustomerDefaultAddress(withAddressID: addressID)
        }
    }
    
    
    // MARK: - Functions
    func getCustomerAddresses() {
        let url = baseURL + "/customers/\(customerID)/addresses.json"
        
        loadingIndicator?(true)
        
        AF.request(url, method: .get, headers: header).responseDecodable(of: CustomerAddressResponse.self) { response in
            
            DispatchQueue.main.async {
                self.loadingIndicator?(false)
            }
            
            switch response.result {
            case .success(let addressesRespone):
                guard let addresses = addressesRespone.results else { return }
                self.customerAdresses = addresses
            case .failure(let error):
                self.errorOccure?(error.localizedDescription)
            }
        }
    }
    
    private func updateCustomerDefaultAddress(withAddressID addressID: Int) {
        let url = baseURL + "/customers/\(customerID)/addresses/\(addressID)/default.json"
        
        loadingIndicator?(true)
        
        AF.request(url, method: .put, headers: header).responseDecodable(of: CustomerAddressResponse.self) { response in
            
            DispatchQueue.main.async {
                self.loadingIndicator?(false)
            }
            
            switch response.result {
            case .success(_):
                self.getCustomerAddresses()
            case .failure(let error):
                self.errorOccure?(error.localizedDescription)
            }
        }
    }
    
    func setAddressForOrder(navigate: @escaping () -> Void) {
        guard let selectedAddress = customerAdresses.first(where: { $0.isDefault }) else {
            errorOccure?("No Address is selected, Please select an address")
            return
        }
        
        let draftOrderService = DraftOrderService()
        
        loadingIndicator?(true)
        
        draftOrderService.customerDraftOrders(customerID: customerID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let draftOrders):
                guard let encodedAddress = try? JSONEncoder().encode(selectedAddress) else { return }
                guard let dicAddress = try? JSONSerialization.jsonObject(with: encodedAddress, options: [.fragmentsAllowed]) as? [String:Any] else { return }
                let params = [
                    "draft_order": [
                        "shipping_address": dicAddress
                    ]
                ]
                
                
                for orderIndex in draftOrders.indices {
                    AF.request("https://ios-q1-new-capital-admin1-2023.myshopify.com/admin/api/2023-01/draft_orders/\(draftOrders[orderIndex].id).json", method: .put, parameters: params, headers: self.header).response { response in
                        switch response.result {
                        case .success(_):
//                            guard let data = data else { return }
//                            print(String(data: data, encoding: .utf8) ?? "No Data")
                            if orderIndex == draftOrders.count - 1 {
                                DispatchQueue.main.async {
                                    self.loadingIndicator?(false)
                                    navigate()
                                }
                            }
                            
                        case .failure(let error):
                            DispatchQueue.main.async {
                                self.loadingIndicator?(false)
                            }
                            self.errorOccure?(error.localizedDescription)
                        }
                    }
                }
                
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.loadingIndicator?(false)
                }
                self.errorOccure?(error.localizedDescription)
            }
        }
    }
    
}
