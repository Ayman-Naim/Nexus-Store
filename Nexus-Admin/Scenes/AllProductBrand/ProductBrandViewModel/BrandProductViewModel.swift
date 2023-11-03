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
    func retriveProductBrandDetails()->[ProductMustafa]?
    func retrivedBumberOfBrandProduct()->Int?
    func bindAvalibleQuatitiyOfProduct(singleProduct:ProductMustafa?)->Int?
    func bindPriceOfProdunctId(productId:ProductMustafa)
    func retriveProductDetails()->ProductMustafa?
    var bindDataofBrandProductDetails:(()->Void)? {set get}
    
    
}
class BrandProductViewModel:BrandProductProtocol{
  
    
    
    
   
    
 
    
 
    
    var bindDataofBrandProduct: (() -> Void)?
    var bindDataofBrandProductDetails: (() -> Void)?
    
   
    
    
    //collections/413225648364/products.json
    
    let apiManager = AdminNetManger.SharedApiManger
    
    private(set) var brandId:Int
    private(set) var product:ProductMustafa? {
        didSet{
            if let validBindBrandProduct = bindDataofBrandProductDetails{
               validBindBrandProduct()
            }
        }
    }
    private(set) var brandProduct:[ProductMustafa]?{
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
        print("EndPoint \(BaseUrl.BrandProduct.enpoint)")
        apiManager.fetchDataaa(url: BaseUrl.BrandProduct, decodingModel: AllProductsResponseMustafa.self) { result in
            
            switch result{
            case .success(let brandProduct):
                self.brandProduct = brandProduct.result
            case.failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    func retriveProductBrandDetails() -> [ProductMustafa]? {
        return brandProduct
    }
    
    func retrivedBumberOfBrandProduct() -> Int? {
        return brandProduct?.count
    }
    
    
    func bindAvalibleQuatitiyOfProduct(singleProduct:ProductMustafa?) -> Int? {
        var quantity = 0
        if let variants = singleProduct?.variants{
            for variant in variants {
                quantity = quantity + (variant.inventoryQuantity ?? 0 )
            }
            // You Can add this line is the same as the above
            // compactMap -> Return Array of Int Which containts quntity for each variant
            // reduce -> Add all array to gether (0 -> Strat index, + -> add operiton)
            //quantity = variants.compactMap({ $0.inventoryQuantity }).reduce(0, +)
        }
        return quantity
    }
    
    
    func bindPriceOfProdunctId(productId:ProductMustafa) {
        BaseUrl.productId = "\(productId.id)"
        print("EndPoint \(BaseUrl.productDetails.enpoint)")

        apiManager.fetchDataaa(url: BaseUrl.productDetails, decodingModel: SingleProductResponseMustafa.self) { result in
            switch result{
            case .success(let product):
                self.product = product.result
            case .failure(let error):
                print(String(describing: error))

                
            }
        }
    }
    
    
    func retriveProductDetails() -> ProductMustafa? {
        return product
    }
    
    
    
    
}
