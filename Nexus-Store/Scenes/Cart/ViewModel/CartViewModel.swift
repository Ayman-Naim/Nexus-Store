//
//  CartViewModel.swift
//  Nexus-Store
//
//  Created by Khater on 27/10/2023.
//

import Foundation


class CartViewModel {
    
    // MARK: - Properties
    private let customerID: Int
    private let service: CartService = CartService()
    private var cartProducts: [CartProduct] = [] {
        didSet {
            DispatchQueue.main.async {
                self.reload?()
            }
        }
    }
    
    
    init(customerID: Int) {
        self.customerID = customerID
    }
    
    
    // MARK: - Computed Properties
    var numberOfRows: Int { cartProducts.count }
    
    
    // MARK: - Closures
    var loadingIndicator: ((Bool) -> Void)?
    var reload: (() -> Void)?
    var errorOccure: ((String) -> Void)?
    var updateTotalPriceLabel: ((String) -> Void)?
    
    
    // MARK: - Functions
    func configCell(_ cell: ProductLandscapeCell, at index: Int) {
        let product = cartProducts[index]
        cell.setProduct(product)
        cell.setCell(id: product.variantID)
    }
    
    func fetchCartProducts() {
        loadingIndicator?(true)
        service.getCartProducts(forCustomerID: customerID) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.loadingIndicator?(false)
            }
            switch result {
            case .success(let cartProducts):
                self.cartProducts = cartProducts
                let totalPrice = cartProducts.map { $0.price * Double($0.quantity) }.reduce(0, +)
                let totalPricetext = "$" + String(format: "%.2f", totalPrice)
                DispatchQueue.main.async {
                    self.updateTotalPriceLabel?(totalPricetext)
                }
            case .failure(let error):
                self.errorOccure?(error.localizedDescription)
            }
        }
    }
    
    func didUpdateQuantity(forCellID id: Int, with quantity: Int){
        let variantID = id
        if let cartProduct = cartProducts.first(where: { $0.variantID == variantID }) {
            print("\(quantity)")
            loadingIndicator?(true)
            service.updateQuantity(ofProduct: cartProduct, withQuantity: quantity, toCustomer: customerID) { [weak self] error in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.loadingIndicator?(false)
                }
                if let error = error {
                    self.errorOccure?(error.localizedDescription)
                }
                self.fetchCartProducts()
            }
        }
    }
    
    func deleteProductFromCart(forCellID id: Int? = nil, at index: Int? = nil) {
        if let id = id {
            let variantID = id
            if let cartProduct = cartProducts.first(where: { $0.variantID == variantID }) {
               deleteCartProduct(cartProduct)
            }
        } else if let index = index {
            deleteCartProduct(cartProducts[index])
        }
    }
    
    private func deleteCartProduct(_ cartProduct: CartProduct){
        loadingIndicator?(true)
        service.removeProductFromCart(cartProduct, customerID: customerID) { [weak self] error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.loadingIndicator?(false)
            }
            if let error = error {
                self.errorOccure?(error.localizedDescription)
                return
            }
            self.fetchCartProducts()
        }
    }
}
