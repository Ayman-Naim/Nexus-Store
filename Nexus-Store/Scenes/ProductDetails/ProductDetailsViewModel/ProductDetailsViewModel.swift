//
//  ProductDetailsViewModel.swift
//  Nexus-Store
//
//  Created by Mustafa on 27/10/2023.
//

import Foundation


protocol ProductDetailsDelegation{
    
    
    func bindDataForProductDetails()->Product
    func bindProductNameOfProduct()->String?
    func bindProductTypeOfProduct()->String?
    func bindProductDescriptionOfProduct()->String?
    func bindProductPriceOfProduct()->String?
    

}

class ProductDetailsViewModel:ProductDetailsDelegation{
   
    
    
   
    
    
    
    var productItem:Product
    
    init(products: Product) {
        self.productItem = products
    }
    
    
    
    func bindDataForProductDetails()->Product {productItem}
    func bindProductNameOfProduct() -> String? {productItem.title}
    func bindProductTypeOfProduct() -> String? {productItem.vendor}
    func bindProductDescriptionOfProduct() -> String? {productItem.bodyHtml}
    func bindProductPriceOfProduct() -> String? {
        if let priceitem = productItem.variants?.first?.price {
            return "$\(priceitem)"
        }
        return "$300"
    }
    
    
    
    
    
}
