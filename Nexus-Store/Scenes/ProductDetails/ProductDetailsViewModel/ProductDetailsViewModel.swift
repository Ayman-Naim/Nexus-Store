//
//  ProductDetailsViewModel.swift
//  Nexus-Store
//
//  Created by Mustafa on 27/10/2023.
//

import Foundation
import UIKit


class ProductDetailsViewModel{
    
    //MARK: - Properties
    let apiNetworkManager = ApiManger.SharedApiManger
    let custemerId = UserDefaults.standard.integer(forKey: K.customerIdKey)
    var ProductId:Int
    let wishListServices = WishListService()
    var availableQuatitySizeAndColor = 0
    var variaintID:Int? = 0
    static var indexOfColor:String? = ""
    static var indexOfSize:String? = ""
    
    var productItem:Product?{
        didSet{
            ProductDetailsViewModel.indexOfSize = productItem?.options?.first?.values?[0]
            ProductDetailsViewModel.indexOfColor = productItem?.options?[1].values?[0]
            variaintID = productItem?.variants?.first?.id
            
            if let numberOfItemAvalabile = productItem?.variants?.first?.inventoryQuantity{
                availableQuatitySizeAndColor = numberOfItemAvalabile
            }
        }
    }
   
  
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
    var notifyAddedToCart:(()->Void)?
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
                print("DArta \(numberOfItemsUpdates) \(actualNumber/2) ")
                if ((actualNumber == 1) && (numberOfItemsUpdates <= 1))
                {
                    numberOfItemsUpdates += 1

                }
                else if ((numberOfItemsUpdates <= (actualNumber/2)) && (actualNumber != 0)){
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
    
    func addProductToCart(){
        guard let variaintID = variaintID else {
            self.errorOccurs?("Please select size and color for the product to add to the cart")
            return
        }
        
        guard let quantity = numberOfQuantityUpdates else {
            self.errorOccurs?("Please choose quantity for the product!")
            return
        }
        
        let cartService = CartService()
        
        self.isLoadingAnimation?(true)
        
        cartService.addProductToCart(forCustomerID: custemerId, variantID: variaintID, quantity: quantity, imageURLString: productItem?.image?.src ?? "") { [weak self] error in
            DispatchQueue.main.async {
                self?.isLoadingAnimation?(false)
            }
            if let error = error {
                self?.errorOccurs?(error.localizedDescription)
                return
            }
            self?.notifyAddedToCart?()
        }
    }
    
    
}


