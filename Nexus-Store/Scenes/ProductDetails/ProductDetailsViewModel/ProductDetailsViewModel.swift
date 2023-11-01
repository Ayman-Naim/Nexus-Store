//
//  ProductDetailsViewModel.swift
//  Nexus-Store
//
//  Created by Mustafa on 27/10/2023.
//

import Foundation


protocol ProductDetailsDelegation{
    
    
    
    var bindDataFromProductID:(()->Void)? {get set}
    func bindDataForProductDetails()->Product?
    func bindProductNameOfProduct()->String?
    func bindProductTypeOfProduct()->String?
    func bindProductDescriptionOfProduct()->String?
    func bindProductPriceOfProduct()->String?
    func bindAvaliableQuantityOfProduct()->String?
    func priceOfEveryProduct()
    
    
    
    
}

class ProductDetailsViewModel:ProductDetailsDelegation{
    
    let apiNetworkManager = ApiManger.SharedApiManger
    var bindDataFromProductID: (() -> Void)?
    var ProductId:Int
    
    var productItem:Product?  {
        
        didSet{
            if let validretrivedDataProduct = bindDataFromProductID{
                validretrivedDataProduct()
            }
        }
        
    }
    
    
    
    
        init(for productID: Int) {
            self.ProductId = productID
        }
    
    
    
    func bindDataForProductDetails()->Product? {productItem}
    func bindProductNameOfProduct() -> String? {productItem?.title}
    func bindProductTypeOfProduct() -> String? {productItem?.vendor}
    func bindProductDescriptionOfProduct() -> String? {productItem?.bodyHtml}
    func bindProductPriceOfProduct() -> String? {
        if let priceitem = productItem?.variants?.first?.price {
            return "$\(priceitem)"
        }
        return "$300"
    }
    
    func bindAvaliableQuantityOfProduct() -> String? {
        let numberOfItemAvalabile = productItem?.variants?.filter({ $0.option1 == productItem?.options?.first?.values?[0] &&  $0.option2 == productItem?.options?[1].values?[0] })
        if let quantityAvalible = numberOfItemAvalabile?.first?.inventoryQuantity{
            return "\(quantityAvalible) item"
        }
        return nil
    }
    
    
    func priceOfEveryProduct() {
        BaseUrl.CategoryPriceID = ProductId
        
        apiNetworkManager.fetchData(url: BaseUrl.CategoryProductPrice, decodingModel: SingleProduct.self) { result in
            switch result{
            case .success(let product):
                self.productItem = product.product
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    
    
    
    
    func addProductToCart(){
        
        
//        let custemerId
//        let varientID
//        let Quatity
//        let imageUrl
        
        
    }
    
    
    
    
    
}




class ProductDetailsViewModuleRefactor{
    
    
    //MARK: - Properties
    var productItemDetails:Product?
    var numberOfAvalibleItems:Int?
    let wishListServices = WishListService()
    let custemerId:Int = 6899149865196
    var constatPriceOfItem:Double?
    
    
//    var favoriteProducts:[Product]?{
//        didSet{
//            if  let count = productItemDetails?.options?.first?.values?.count  {
//                if count > 0{
//                    let indexPath = IndexPath(item: 0, section: 0)
//                    
//                    sizeCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
//                    
//                    
//                }
//            }
//            
//        }
//    }
//    
//   
//    
//    var numberOfItemsUpdates:Int = 0 {
//        didSet{
//            numberOfItems.text = "\(numberOfItemsUpdates)"
//            let price =  Double (numberOfItemsUpdates) * constatPriceOfItem!
//            itemPrice.text = "$\(String(format: "%.2f", price))"
//            if numberOfAvalibleItems != 0{
//                
//                avalibleQuantity.text = "\(numberOfAvalibleItems!  - ( numberOfItemsUpdates )) Item"
//                
//            }
//        }
//    }
    let productRatting:Double = 5
    var productDetailsViewModel:ProductDetailsDelegation?
    var productSizeDelegation:ProductSizeDelegation?
    var productColorDelegation:ProductColorDelegation?
    var productImageDelegation: ProdutImageDelegation?
    let productReviewDelegation = ProductReviewDelegation(numberOfReviews: 2)
    
    
}
