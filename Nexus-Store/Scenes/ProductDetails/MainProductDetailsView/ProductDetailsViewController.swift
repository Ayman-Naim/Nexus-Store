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

    let productRatting:Double = 5
    var productSizeDelegation:ProductSizeDelegation?
    var productColorDelegation:ProductColorDelegation?
    var productImageDelegation: ProdutImageDelegation?
    let productReviewDelegation = ProductReviewDelegation(numberOfReviews: 2)
    var productDetailsViewModel:ProductDetailsViewModel?
    
    //MARK: - Conigure ViewWill Appear
    override func viewDidAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        self.addLogoToNavigationBarItem(logoImage: K.darkModeLogo)
        
    }
    
    //MARK: - View Will Desappear
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        productDetailsViewModel?.priceOfSingleProduct()
        bindProductDetailsViewModule()
        productImageCollection.contentInsetAdjustmentBehavior = .never
        
        
        
        
    }
  
    
  //MARK: - Bind View Module in the Controller
    private func bindProductDetailsViewModule(){
        
        productDetailsViewModel?.reload = {[weak self] in
            
            self?.productSizeDelegation = ProductSizeDelegation(viewModel: (self?.productDetailsViewModel)!)
            self?.productColorDelegation = ProductColorDelegation(viewModel: (self?.productDetailsViewModel)!)
            self?.productImageDelegation = ProdutImageDelegation(collectionView: (self?.productImageCollection)!, with: self!.imageIndicator,itemDetails: (self?.productDetailsViewModel?.productItemDetails)!)
            self?.productImageDelegation?.layoutSetup()
            self?.configureDetailsOfProduct()
            self?.avalibleQuantity.text = self?.productDetailsViewModel?.numeberOfAvalibleQuantity
            self?.setRattingToProduct()
            self?.configureDataSourceofImageCollection()
          
            DispatchQueue.main.async {
               
                self?.productImageCollection.reloadData()
                self?.sizeCollectionView.reloadData()
                self?.colorCollectionView.reloadData()
                self?.reviewCollectionView.reloadData()
                
                let indexPath = IndexPath(item: 0, section: 0)
                self?.sizeCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
                let indexPath2 = IndexPath(item: 0, section: 0)
                self?.colorCollectionView.selectItem(at: indexPath2, animated: false, scrollPosition: [])
                
            }
            
           
            
        }
        
        
        
        productDetailsViewModel?.isLoadingAnimation = { [weak self] loading in
            DispatchQueue.main.async {
                self?.isLoadingIndicatorAnimating = loading
            }
        }
        
        
        
        productDetailsViewModel?.errorOccurs = { [weak self] error in
            guard let self = self else{return}
            isLoadingIndicatorAnimating = false
            Alert.show(on: self, title: "error", message: error)
        }
        
        
        productDetailsViewModel?.alertNotification = { [weak self] (titleAlert , messageAlert) in
            guard let self = self else{return}
            Alert.show(on: self, title: titleAlert , message: messageAlert)
            
        }
        
        
        productDetailsViewModel?.setProductAsFavorites = { [weak self] in
            DispatchQueue.main.async {
                self?.showFavoriteOrNot.setImage(UIImage(systemName: K.favoriteIconSave,withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
                }
            }
        
        
        
        productDetailsViewModel?.updateQuatitySelect = { [weak self] in
            
            DispatchQueue.main.async {
                if let stockAvalibity = self?.productDetailsViewModel?.numberOfItemsUpdates {
                    self?.numberOfItems.text = "\(stockAvalibity)"
                    self?.itemPrice.text = "$\(String(format: "%.2f", self?.productDetailsViewModel?.updateAvalibleQuantity() ?? "0.0"))"
                        self?.avalibleQuantity.text = "\((self?.productDetailsViewModel?.availableQuatitySizeAndColor ?? 0)  - (self?.productDetailsViewModel?.numberOfItemsUpdates ?? 0) ) item"
                        
                   
                    
                }
            }
        }
        
        
        
    }
    
    
    //MARK: - Increase Quatity of Item
    @IBAction func addItem(_ sender: Any) {
        productDetailsViewModel?.addNewItemToCart(availableQuantity: avalibleQuantity.text)
    }
    
    
    
    //MARK: - Decrease Quatity of Item
    @IBAction func removeItem(_ sender: UIButton) {
        productDetailsViewModel?.removeOneItemFromCart()
        
    }
    
    
    
    //MARK: - Set Item IS in Favorite Or Not

    @IBAction func setOrRemoveFavorite(_ sender: UIButton) {
        
        productDetailsViewModel?.setOrRemoveFavoriteProduct(sender:sender)
    }
    
    
   
    
    
   
    
    //MARK: - Test Add Promo Code To Product
    @IBAction func AddToCartButton(_ sender: UIButton) {
        
        if productDetailsViewModel?.numberOfItemsUpdates != 0 {

//            let vc = AddPromoCodeViewController()
//            let addPromoViewModel = AddPromoCodeViewModel()
//            vc.addPromoCodeViewModel = addPromoViewModel
//           // vc.addPromoCodeViewModel = AddPromoCodeViewModel()
//            let okAction = UIAlertAction(title: "OK", style: .default) { action in
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
//            Alert.show(on: self, title: "Congratulation", message: "You scussfully added the quatity to the Cart",actions: [okAction])
            productDetailsViewModel?.addProductToCart()
        }else{

            Alert.show(on: self, title: "No Quantity", message: "Please Select Qunatity From The Available Stock.")
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
        self.colorCollectionView.register(ColorCell.nib(), forCellWithReuseIdentifier: ColorCell.identifier)
        self.reviewCollectionView.register(ReviewProductCell.nib(), forCellWithReuseIdentifier: ReviewProductCell.identifier)
      

        
    }
    
    
    
    //MARK: - Configure Details of Product
    func configureDetailsOfProduct(){

        productName.text = productDetailsViewModel?.nameOfProduct
        productBrand.text = productDetailsViewModel?.nameProductBrand
        descriptionOfProduct.text = productDetailsViewModel?.descriptionOfProduct
        itemPrice.text = productDetailsViewModel?.priceOfsingleProduct

    }
    

    //MARK: - Set Rating for Product
    func setRattingToProduct(){
        rating.rating = productRatting.randomValue
    }
    
    
    
  

    
    
}




