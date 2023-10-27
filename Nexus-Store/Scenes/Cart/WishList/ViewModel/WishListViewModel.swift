//
//  WishListViewModel.swift
//  Nexus-Store
//
//  Created by Khater on 25/10/2023.
//

import Foundation


class WishListViewModel {
    
    // MARK: - Properties
    private let userID = 6899149865196
    private let service: WishListService = WishListService()
    private var wishList: [Product] = []
    
    
    // MARK: - Computed Properties
    var numberOfRow: Int { wishList.count }
    
    // MARK: - Closures
    var loadingIndicator: ((Bool) -> Void)?
    var reload: (() -> Void)?
    var errorOccure: ((String) -> Void)?
    
    
    // MARK: - Functions
    func configCell(_ cell: ProductLandscapeCell, at index: Int) {
        let product = wishList[index]
        let price = product.variants?.first?.price ?? "5.0"
        let cartProduct = CartProduct(draftOrderID: 0, variantID: 0, title: product.title ?? "Not Found", price: Double(price)!, image: product.image?.src ?? "", quantity: 0)
        cell.setProduct(cartProduct)
        cell.setCell(id: product.id)
        cell.hideQuantity()
    }
    
    func fetchProducts() {
        loadingIndicator?(true)
        service.getWishlist(forCustom: userID) { [weak self] result in
            guard let self = self else { return }
            self.loadingIndicator?(false)
            switch result {
            case .success(let products):
                self.wishList = products
                self.reload?()
            case .failure(let error):
                self.errorOccure?(error.localizedDescription)
            }
        }
    }
    
    func removeFromWishList(at index: Int? = nil, withProductID productID: Int? = nil){
        loadingIndicator?(true)
        
        if let index = index {
            removeProduct(wishList[index].id)
        } else if let productID = productID {
            removeProduct(productID)
        }
    }
    
    private func removeProduct(_ id: Int) {
        service.removeWishList(productID: id, fromCustomer: userID) { [weak self] error in
            self?.loadingIndicator?(false)
            if let error = error {
                self?.errorOccure?(error.localizedDescription)
            } else {
                self?.wishList.removeAll(where: { $0.id == id })
                self?.reload?()
            }
        }
    }
}
