//
//  ProductDetailsViewController.swift
//  Nexus-Store
//
//  Created by Mustafa on 20/10/2023.
//

import UIKit
import Cosmos

class ProductDetailsViewController: UIViewController {
         

  
    static let storyBoardName = "ProductDetails"
    static let identifier = "ProductDetails"
    
    @IBOutlet weak var showFavoriteOrNot: UIButton!
    
    @IBOutlet weak var numberOfItems: UILabel!
    
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var stepperView: UIView!
    @IBOutlet weak var reviewCollectionView: UICollectionView!
    @IBOutlet weak var productImageCollection: UICollectionView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var rating: CosmosView!
    @IBOutlet weak var productBrand: UILabel!
    @IBOutlet weak var descriptionOfProduct: UILabel!
    @IBOutlet weak var colorCollectionView: UICollectionView!
    @IBOutlet weak var sizeCollectionView: UICollectionView!
    @IBOutlet weak var imageIndicator: UIPageControl!
    @IBOutlet weak var avalibleQuantity: UILabel!
    var productItemDetails:Product?
    var numberOfAvalibleItems:Int?
    let wishListServices = WishListService()
    var favoriteProducts:[Product]?
    let custemerId:Int = 6899149865196
    var constatPriceOfItem:Double?
    
    
    var numberOfItemsUpdates:Int = 0 {
        didSet{
            numberOfItems.text = "\(numberOfItemsUpdates)"
            let price =  Double (numberOfItemsUpdates) * constatPriceOfItem!
            itemPrice.text = "$\(String(format: "%.2f", price))"
            if numberOfAvalibleItems != 0{
                
                avalibleQuantity.text = "\(numberOfAvalibleItems!  - ( numberOfItemsUpdates )) Item"
                
            }
            
        }
    }
    let productRatting:Double = 5
    var productDetailsViewModel:ProductDetailsDelegation?
    var productSizeDelegation:ProductSizeDelegation?
    var productColorDelegation:ProductColorDelegation?
    var productImageDelegation: ProdutImageDelegation?
    let productReviewDelegation = ProductReviewDelegation(numberOfReviews: 2)
    
    
    
    
    //MARK: - Conigure ViewWill Appear
    override func viewDidAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        self.addLogoToNavigationBarItem(logoImage: K.darkModeLogo)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ConfigureCallNetworlForProduct()
        productImageCollection.contentInsetAdjustmentBehavior = .never
        checkCustomerFavoriteProduct()
       
        
    }

    
    @IBAction func addItem(_ sender: Any) {
     
        if let fullText = avalibleQuantity.text?.components(separatedBy: " "){
            let number = fullText[0]
            
            if let actualNumber = Int (number){
                if numberOfItemsUpdates < (actualNumber/3){
                    numberOfItemsUpdates += 1
                }
            }
        }
        
    }
    
    
    @IBAction func removeItem(_ sender: UIButton) {
        if numberOfItemsUpdates > 0{
            numberOfItemsUpdates -= 1
            
        }
        
        
    }
    
    
    
    @IBAction func setOrRemoveFavorite(_ sender: UIButton) {
        if  sender.currentImage == UIImage(systemName:  K.favoriteIconNotSave,withConfiguration: UIImage.SymbolConfiguration(scale: .large)){
            sender.setImage(UIImage(systemName: K.favoriteIconSave,withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
            wishListServices.addToWishList(productID: productItemDetails!.id, toCustomer: custemerId) { error in
                if let error = error{
                    print("There is an error Try Solve It!")
                }else{return}
            }
           
        }else{
            
            sender.setImage(UIImage(systemName: K.favoriteIconNotSave,withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
            wishListServices.removeWishList(productID: productItemDetails!.id, fromCustomer: custemerId) { error in
                if let error = error{
                    print("There is an error Try Solve It!")
                }else{return}
            }
        }
        
    }
    
    
    func checkCustomerFavoriteProduct(){
        wishListServices.getWishlist(forCustom: custemerId) { result in
            switch result{
            case.success(let favoriteProduct):
                self.favoriteProducts = favoriteProduct
                self.checkIsFavorite()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    func checkIsFavorite(){
        let checkProductExistance = favoriteProducts?.filter({$0.id ==  productItemDetails?.id})
        if productItemDetails?.id == checkProductExistance?.first?.id {
            showFavoriteOrNot.setImage(UIImage(systemName: K.favoriteIconSave,withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
        }
        else{
            showFavoriteOrNot.setImage(UIImage(systemName: K.favoriteIconNotSave,withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
          
        }
    }
    
    
}




//MARK: - Adding Cosmatics to UIView
extension ProductDetailsViewController{
    
    func configureDataSourceofImageCollection(){
        productImageCollection.dataSource = productImageDelegation
        productImageCollection.delegate = productImageDelegation
        sizeCollectionView.dataSource = productSizeDelegation
        sizeCollectionView.delegate = productSizeDelegation
        colorCollectionView.dataSource = productColorDelegation
        colorCollectionView.delegate =  productColorDelegation
        reviewCollectionView.dataSource = productReviewDelegation
        reviewCollectionView.delegate = productReviewDelegation
        self.productImageCollection.register(ProductImageCell.nib(), forCellWithReuseIdentifier: ProductImageCell.identifier)
        self.sizeCollectionView.register(SizeColorCell.nib(), forCellWithReuseIdentifier: SizeColorCell.identifier)
        self.colorCollectionView.register(SizeColorCell.nib(), forCellWithReuseIdentifier: SizeColorCell.identifier)
        self.reviewCollectionView.register(ReviewProductCell.nib(), forCellWithReuseIdentifier: ReviewProductCell.identifier)
        
        
        
    }
    

    
    //MARK: - Configure Details of Product
    func configureDetailsOfProduct(){
        
        productName.text = productDetailsViewModel?.bindProductNameOfProduct()
        productBrand.text = productDetailsViewModel?.bindProductTypeOfProduct()
        descriptionOfProduct.text = productDetailsViewModel?.bindProductDescriptionOfProduct()
        itemPrice.text = productDetailsViewModel?.bindProductPriceOfProduct()
        
    }
    
    //MARK: - Configure Details of Quantity Product
    func avalibleQuntatity(){
        avalibleQuantity.text = productDetailsViewModel?.bindAvaliableQuantityOfProduct()
        if let fullText = productDetailsViewModel?.bindAvaliableQuantityOfProduct()?.components(separatedBy: " "){
            let number = fullText[0]
            if let actualNumber = Int (number){
                numberOfAvalibleItems = actualNumber
            }
            
        }
    }
    
    //MARK: - Set Rating for Product
    func setRattingToProduct(){
        rating.rating = productRatting.randomValue
    }
    
    
    
    func ConfigureCallNetworlForProduct(){
        productDetailsViewModel?.priceOfEveryProduct()
        productDetailsViewModel?.bindDataFromProductID = { [weak self] in
            self?.productItemDetails = self?.productDetailsViewModel?.bindDataForProductDetails()
            self?.constatPriceOfItem = self?.getSinglePriceOfItem()
            self?.productSizeDelegation = ProductSizeDelegation(itemDetails: (self?.productDetailsViewModel?.bindDataForProductDetails())! , with:(self?.avalibleQuantity)!)
            self?.productColorDelegation = ProductColorDelegation(itemDetails: (self?.productDetailsViewModel?.bindDataForProductDetails())!)
            self?.productImageDelegation = ProdutImageDelegation(collectionView: (self?.productImageCollection)!, with: self!.imageIndicator,itemDetails: (self?.productDetailsViewModel?.bindDataForProductDetails())!)
            self?.productImageDelegation?.layoutSetup()
            self?.configureDetailsOfProduct()
            self?.avalibleQuntatity()
            self?.setRattingToProduct()
            self?.configureDataSourceofImageCollection()
            DispatchQueue.main.async {
                self?.productImageCollection.reloadData()
                self?.sizeCollectionView.reloadData()
                self?.colorCollectionView.reloadData()
                self?.reviewCollectionView.reloadData()
                
            }
        }
        
    }
    
    func getSinglePriceOfItem()->Double?{
        let number = productDetailsViewModel?.bindProductPriceOfProduct()?.components(separatedBy: "$")
        if let actualPrice = Double((number?[1])!){
            return Double(actualPrice)
        }
      return nil
    }
    
    
  
}




