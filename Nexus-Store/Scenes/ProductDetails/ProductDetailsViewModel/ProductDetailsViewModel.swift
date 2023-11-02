//
//  ProductDetailsViewModel.swift
//  Nexus-Store
//
//  Created by Mustafa on 27/10/2023.
//

import Foundation
import UIKit


//protocol ProductDetailsDelegation{
//
//
//
//    var bindDataFromProductID:(()->Void)? {get set}
//    func bindDataForProductDetails()->Product?
//    func bindProductNameOfProduct()->String?
//    func bindProductTypeOfProduct()->String?
//    func bindProductDescriptionOfProduct()->String?
//    func bindProductPriceOfProduct()->String?
//    func bindAvaliableQuantityOfProduct()->String?
//    func priceOfEveryProduct()
//
//
//
//
//
//}
//
//class ProductDetailsViewModel:ProductDetailsDelegation{
//
//    let apiNetworkManager = ApiManger.SharedApiManger
//    var bindDataFromProductID: (() -> Void)?
//    var ProductId:Int
//
//    var productItem:Product?  {
//
//        didSet{
//            if let validretrivedDataProduct = bindDataFromProductID{
//                validretrivedDataProduct()
//            }
//        }
//
//    }
//
//
//
//
//        init(for productID: Int) {
//            self.ProductId = productID
//        }
//
//
//
//    func bindDataForProductDetails()->Product? {productItem}
//    func bindProductNameOfProduct() -> String? {productItem?.title}
//    func bindProductTypeOfProduct() -> String? {productItem?.vendor}
//    func bindProductDescriptionOfProduct() -> String? {productItem?.bodyHtml}
//
//
//
//    func bindProductPriceOfProduct() -> String? {
//        if let priceitem = productItem?.variants?.first?.price {
//            return "$\(priceitem)"
//        }
//        return "$300"
//    }
//
//    func bindAvaliableQuantityOfProduct() -> String? {
//        let numberOfItemAvalabile = productItem?.variants?.filter({ $0.option1 == productItem?.options?.first?.values?[0] &&  $0.option2 == productItem?.options?[1].values?[0] })
//        if let quantityAvalible = numberOfItemAvalabile?.first?.inventoryQuantity{
//            return "\(quantityAvalible) item"
//        }
//        return nil
//    }
//
//
//    func priceOfEveryProduct() {
//        BaseUrl.CategoryPriceID = ProductId
//
//        apiNetworkManager.fetchData(url: BaseUrl.CategoryProductPrice, decodingModel: SingleProduct.self) { result in
//            switch result{
//            case .success(let product):
//                self.productItem = product.product
//            case .failure(let error):
//                print(String(describing: error))
//            }
//        }
//    }
//
//
//
//
//
//    func addProductToCart(){
//
//
////        let custemerId
////        let varientID
////        let Quatity
////        let imageUrl
//
//
//    }
//
//
//
//
//
//}


class ProductDetailsViewModel{
    
    //MARK: - Properties
    let apiNetworkManager = ApiManger.SharedApiManger
    let custemerId = UserDefaults.standard.integer(forKey: K.customerIdKey)
    var ProductId:Int
    var productItem:Product?
    let wishListServices = WishListService()
    var favoriteProducts:[Product] = [] {
        didSet{
            for favoriteProduct in favoriteProducts {
                if favoriteProduct.id == productItem?.id{
                    setProductAsFavorites?()
                }
            }
        }
    }
    var numberOfItemsUpdates:Int = 0 {
        didSet{
            updateQuatitySelect?()
        }
    }
   
    
    
    //MARK: - Initilization Of Product Details
    init(for productID: Int) {
        self.ProductId = productID
    }
    
    
    
    
    
    
    
    //MARK: - Closures
    var reload:(()->Void)?
    var isLoadingAnimation:((Bool)->Void)?
    var errorOccurs:((String)->Void)?
    var alertNotification:((_ title:String,_ message:String)->Void)?
    var setProductAsFavorites:(()->Void)?
    var updateQuatitySelect:(()->Void)?
    
 
    //MARK: - Computed Property
    
    var productItemDetails:Product? {productItem}
    var nameOfProduct:String? {productItem?.title}
    var nameProductBrand:String? {productItem?.vendor}
    var descriptionOfProduct:String? {productItem?.bodyHtml}
    var avalibleQuantity:Int? {
        if let numberOfItemAvalabile = productItem?.variants?.first?.inventoryQuantity{
            return numberOfItemAvalabile
        }
        return 0
    }
    var priceOfSingleItem:Double? {
        if let priceOfSingleProduct =  Double(productItem?.variants?.first?.price ?? "0.0"){
            return priceOfSingleProduct
        }
        return nil
        
    }
    var priceOfsingleProduct:String? {
        if let priceitem = productItem?.variants?.first?.price {
                    return "$\(priceitem)"
                }
                return "$300"
       }
    var numeberOfAvalibleQuantity:String?{
        if let numberOfItemAvalabile = productItem?.variants?.first?.inventoryQuantity{
            return "\(numberOfItemAvalabile) item"
            
        }
        return nil
        
    }
    var numberOfQuantityUpdates:Int? {numberOfItemsUpdates}
   
    
 
    
    //MARK: - Network Call For Price of Product
    
    func priceOfSingleProduct() {
        BaseUrl.CategoryPriceID = ProductId
         isLoadingAnimation?(true)
        apiNetworkManager.fetchData(url: BaseUrl.CategoryProductPrice, decodingModel: SingleProduct.self) { result in
            switch result{
            case .success(let product):
                self.productItem = product.product
                self.checkCustomerFavoriteProduct(for: self.custemerId)
                self.isLoadingAnimation?(false)
                self.reload?()
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }

    
    
    //MARK: - Adding New Item
    func addNewItemToCart(availableQuantity:String?){
        
        if let fullText = availableQuantity?.components(separatedBy: " "){
            let number = fullText[0]
            
            if let actualNumber = Int (number){
                if numberOfItemsUpdates < (actualNumber/3){
                    numberOfItemsUpdates += 1
                }else{
                    if actualNumber ==  0 {
                        alertNotification?("Out of Stock","This Item You choosen is out of Stock.")
                    }else{
                        alertNotification?("Maxmium Limit","You Reached Maximum Limit For You.")
                    }
                  
                }
            }
        }
    }
    
    //MARK: - Remove One Item
    func removeOneItemFromCart(){
        
        
        if numberOfItemsUpdates > 0{
            numberOfItemsUpdates -= 1
            
        }else{
            alertNotification?("Add Item","Please Add Item To Allow Decrease Quantity!")
        }
        
        
    }
    
    //MARK: - Set Or Remove Error
    func setOrRemoveFavoriteProduct(sender:UIButton){
        if  sender.currentImage == UIImage(systemName:  K.favoriteIconNotSave,withConfiguration: UIImage.SymbolConfiguration(scale: .large)){
            sender.setImage(UIImage(systemName: K.favoriteIconSave,withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
            wishListServices.addToWishList(productID: productItem!.id, toCustomer: custemerId) { error in
                if let error = error{
                    self.errorOccurs?(String(describing: error.localizedDescription))
                }else{return}
            }
            
        }else{
            
            sender.setImage(UIImage(systemName: K.favoriteIconNotSave,withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
            wishListServices.removeWishList(productID: productItem!.id, fromCustomer: custemerId) { error in
                if let error = error{
                    self.errorOccurs?(String(describing: error.localizedDescription))
                }else{return}
            }
        }
        
        
    }
    
    
    //MARK: - to Check Favorites Product Of Customer
    func checkCustomerFavoriteProduct(for custmerId:Int){
            isLoadingAnimation?(true)
            wishListServices.getWishlist(forCustom: custmerId) { result in
                switch result{
                case.success(let favoriteProduct):
                    self.favoriteProducts = favoriteProduct
                    self.isLoadingAnimation?(false)
                case .failure(let error):
                    self.errorOccurs?(String(describing: error.localizedDescription))
                }
            }
        }
    
    
    
    //MARK: - Decrease And Increase Quantity
    func updateAvalibleQuantity()->Double{
        print("Double price\(Double (numberOfItemsUpdates) * (priceOfSingleItem ?? 0.0))")
        return  Double (numberOfItemsUpdates) * (priceOfSingleItem ?? 0.0)
    }
    
    
    
    
}


