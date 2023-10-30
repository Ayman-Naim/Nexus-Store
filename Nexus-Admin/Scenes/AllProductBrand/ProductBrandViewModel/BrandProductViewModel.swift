//
//  BrandProductViewModel.swift
//  Nexus-Admin
//
//  Created by Mustafa on 29/10/2023.
//

import Foundation


protocol BrandProductProtocol{
    
    var bindDataofBrandProduct:(()->Void)? {set get}
    func fetchAllProductForBrand()
    func retriveProductBrandDetails()->[Product]?
    func retrivedBumberOfBrandProduct()->Int?
    func bindAvalibleQuatitiyOfProduct(singleProduct:Product?)->Int?
    func bindPriceOfProdunctId(productId:Product)
    func retriveProductDetails()->Product?
    var bindDataofBrandProductDetails:(()->Void)? {set get}
    
    
}
class BrandProductViewModel:BrandProductProtocol{
  
    
    
    
   
    
 
    
 
    
    var bindDataofBrandProduct: (() -> Void)?
    var bindDataofBrandProductDetails: (() -> Void)?
    
   
    
    
    //collections/413225648364/products.json
    
    let apiManager = AdminNetManger.SharedApiManger
    
    private(set) var brandId:Int
    private(set) var product:Product? {
        didSet{
            if let validBindBrandProduct = bindDataofBrandProductDetails{
               validBindBrandProduct()
            }
        }
    }
    private(set) var brandProduct:[Product]?{
        didSet{
            if let validBindBrandProduct = bindDataofBrandProduct{
               validBindBrandProduct()
            }
        }
    }
    
    
    init(brandId:Int){
        self.brandId = brandId
    }
    
    
    
    func fetchAllProductForBrand() {
        BaseUrl.brandId = "\(self.brandId)"
        apiManager.fetchDataaa(url: BaseUrl.BrandProduct, decodingModel: AllProductsResponse.self) { result in
            
            switch result{
            case .success(let brandProduct):
                self.brandProduct = brandProduct.result
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func retriveProductBrandDetails() -> [Product]? {
        return brandProduct
    }
    
    func retrivedBumberOfBrandProduct() -> Int? {
        return brandProduct?.count
    }
    
    
    func bindAvalibleQuatitiyOfProduct(singleProduct:Product?) -> Int? {
        var quantity = 0
        if let variants = singleProduct?.variants{
            for variant in variants {
                quantity = quantity + variant.inventoryQuantity
            }
            // You Can add this line is the same as the above
            // compactMap -> Return Array of Int Which containts quntity for each variant
            // reduce -> Add all array to gether (0 -> Strat index, + -> add operiton)
            //quantity = variants.compactMap({ $0.inventoryQuantity }).reduce(0, +)
        }
        return quantity
    }
    
    
    func bindPriceOfProdunctId(productId:Product) {
        BaseUrl.productId = "\(productId.id)"
        apiManager.fetchDataaa(url: BaseUrl.productDetails, decodingModel: SingleProductResponse.self) { result in
            switch result{
            case .success(let product):
                self.product = product.result
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
    }
    
    
    func retriveProductDetails() -> Product? {
        return product
    }
    
    
    
    
}
