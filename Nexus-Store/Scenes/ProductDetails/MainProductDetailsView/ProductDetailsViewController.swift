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
    
    var productDetailsViewModel:ProductDetailsDelegation?
    
    let productSizeDelegation = ProductSizeDelegation()
    let productColorDelegation = ProductColorDelegation()
    let productReviewDelegation = ProductReviewDelegation()
    
    lazy var productImageDelegation = ProdutImageDelegation(collectionView: self.productImageCollection, with: imageIndicator,itemDetails: (productDetailsViewModel?.bindDataForProductDetails())!)
    
    
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
        print("Data oF Items\(productImageDelegation.itemDetails)")
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
    

    
    
    func configureDetailsOfProduct(){
        
        productName.text = productDetailsViewModel?.bindProductNameOfProduct()
        productBrand.text = productDetailsViewModel?.bindProductTypeOfProduct()
        descriptionOfProduct.text = productDetailsViewModel?.bindProductDescriptionOfProduct()
        itemPrice.text = productDetailsViewModel?.bindProductPriceOfProduct()
        
    }
    
    
  
}


