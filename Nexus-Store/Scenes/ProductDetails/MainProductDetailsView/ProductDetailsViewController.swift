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
    
    
    var constatPriceOfItem:Double? {
        let number = productDetailsViewModel?.bindProductPriceOfProduct()?.components(separatedBy: "$")
       return Double(number![1])
    }
    
    
    var numberOfItemsUpdates:Int = 1 {
        didSet{
            numberOfItems.text = "\(numberOfItemsUpdates)"
            let price =  Double (numberOfItemsUpdates) * constatPriceOfItem!
            itemPrice.text = "$\(String(format: "%.2f", price))"
        }
    }
    let productRatting:Double = 5
    var productDetailsViewModel:ProductDetailsDelegation?
    lazy var productSizeDelegation = ProductSizeDelegation(itemDetails: (productDetailsViewModel?.bindDataForProductDetails())! , with:avalibleQuantity)
    lazy var productColorDelegation = ProductColorDelegation(itemDetails: (productDetailsViewModel?.bindDataForProductDetails())!)
    
    lazy var productImageDelegation = ProdutImageDelegation(collectionView: self.productImageCollection, with: imageIndicator,itemDetails: (productDetailsViewModel?.bindDataForProductDetails())!)
    
    
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
        configureDataSourceofImageCollection()
        productImageCollection.contentInsetAdjustmentBehavior = .never
        productImageDelegation.layoutSetup()
        configureDetailsOfProduct()
        avalibleQuntatity()
        setRattingToProduct()
        
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
        if numberOfItemsUpdates > 1{
            numberOfItemsUpdates -= 1
            
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
    }
    
    //MARK: - Set Rating for Product
    func setRattingToProduct(){
        
        rating.rating = productRatting.randomValue
    }
    
    
    
    
    
    
  
}




