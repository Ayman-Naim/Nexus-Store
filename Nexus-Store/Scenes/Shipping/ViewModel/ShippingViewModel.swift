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
    
    // 6921948365036
    private var customerID: Int?
    private var customerAdresses: [Address] = [] {
        didSet {
            DispatchQueue.main.async {
                self.reload?()
            }
        }
    }
    
    
    // MARK: - Clouser
    var reload: (() -> Void)?
    
    
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
    func setCustomerID(_ id: Int) {
        self.customerID = id
    }
    
    func getCustomerAddresses() {
        guard let customerID = customerID else { return }
        let url = baseURL + "/customers/\(customerID)/addresses.json"
        AF.request(url, method: .get, headers: header).responseDecodable(of: CustomerAddressResponse.self) { response in
            switch response.result {
            case .success(let addressesResponse):
                guard let addresses = addressesResponse.results else { return }
                self.customerAdresses = addresses
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func updateCustomerDefaultAddress(withAddressID addressID: Int) {
        guard let customerID = customerID else { return }
        let url = baseURL + "/customers/\(customerID)/addresses/\(addressID)/default.json"
        AF.request(url, method: .put, headers: header).responseDecodable(of: CustomerAddressResponse.self) { response in
            switch response.result {
            case .success(_):
                self.getCustomerAddresses()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func setDraftOrderAddress() {
        guard let customerID = customerID else { return }
        guard let selectedAddress = customerAdresses.first(where: { $0.isDefault }) else { return }
        
        let draftOrderService = DraftOrderService()
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
                
                
                for order in draftOrders {
                    AF.request("https://ios-q1-new-capital-admin1-2023.myshopify.com/admin/api/2023-01/draft_orders/\(order.id).json", method: .put, parameters: params, headers: self.header).response { response in
                        switch response.result {
                        case .success(let data):
                            guard let data = data else { return }
                            print(String(data: data, encoding: .utf8) ?? "No Data")
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
                
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
