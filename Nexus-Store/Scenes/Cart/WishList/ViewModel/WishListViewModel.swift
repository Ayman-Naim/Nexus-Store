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
        let cartProduct = CartProduct(id: product.id, title: product.title, price: 0, image: product.image.urlString, quantity: 0)
        cell.setProduct(cartProduct)
        cell.hideQuantity()
    }
    
    func fetchProducts() {
        loadingIndicator?(true)
        service.getAllProducts(forCustom: userID) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.loadingIndicator?(false)
            }
            switch result {
            case .success(let products):
                self.wishList = products
                DispatchQueue.main.async {
                    self.reload?()
                }
            case .failure(let error):
                self.errorOccure?(error.localizedDescription)
            }
        }
    }
}


// MARK: - ProductLandscapeCellDelegate
extension WishListViewModel: ProductLandscapeCellDelegate {
    func didDeleteProduct(withID id: Int) {
        print(id)
    }
}
