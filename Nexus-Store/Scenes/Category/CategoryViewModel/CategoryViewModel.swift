//
//  CategoryViewModel.swift
//  Nexus-Store
//
//  Created by Mustafa on 25/10/2023.
//

import Foundation
import UIKit




class CategoryViewModuleRefactor:CustomNibCellProtocol{
    
    //MARK: - Properteis
    
    private let apiNetworkManager = ApiManger.SharedApiManger
    private(set) var mainCategory = ["MEN","KIDS","SALE","WOMEN"]
    private(set) var subCategory = ["ALL","SHOES","T-SHIRT","ACCESSORIES"]
    let custemerId = UserDefaults.standard.integer(forKey: K.customerIdKey)
    static var selectedMainCategory = 0
    static var selectedSubCategory = 0
    var fromBrand = false
    var brandName = "ADIDAS"
    let wishListServices = WishListService()
    private var favoriteProducts:[Product] = []
    private var productForBrand:[Product] = []
    {
        didSet{
           
        }
    }
    private var filterProduct :[Product] = [] {
        didSet{
           
            if (fromBrand == false){
                print("All Product Count\(allProduct.count) || FilterProduct Count \(filterProduct.count)")
                if ((allProduct.count == filterProduct.count) ) {
                    self.reload?()
                }
                
                
            }
            
            else {
                print("Product Brand Count \(productForBrand.count) || FilterProduct Count \(filterProduct.count)")
                if ((allProduct.count == filterProduct.count))  {
                    self.filteraccodingToBrand(brandName: self.brandName)
                    filterProduct = productForBrand
                    productForBrand.removeAll()
                    self.reload?()
                    
                    
                }
            }
           
           
           
        }
    }
    private var allProduct:[Product] = []
    
    
    //MARK: - Coumputed Property
    var numberOfProduct:Int {filterProduct.count}
    var numberOfMainCategory:Int {mainCategory.count}
    var numberOfsubCategory:Int {subCategory.count}
    
    //MARK: - Closures
    var loadingAnimation:((Bool)->Void)?
    var reload:(()->Void)?
    var errorOccurs:((String)->Void)?
    
    
    //MARK: - Configure cell for Sub Category
    func mainCategoeyCellConfiguration(cell:MainCategoryCell , indexPath:IndexPath){
        cell.ConfigureLabelOfCell(label: mainCategory[indexPath.row])
        indexPath.row == CategoryViewModuleRefactor.selectedMainCategory ? cell.backgoundMainCategoryView.configureDesignOfcellSelected(label: cell.mainCategoryLabel) :  cell.backgoundMainCategoryView.configureDesignOfCellNotSelected(label: cell.mainCategoryLabel)
    }
    
    //MARK: - Configure cell for Sub Category
    func subCategoeyCellConfiguration(cell:MainCategoryCell , indexPath:IndexPath){
        cell.ConfigureLabelOfCell(label: subCategory[indexPath.row])
        indexPath.row == CategoryViewModuleRefactor.selectedSubCategory ? cell.backgoundMainCategoryView.configureDesignOfcellSelected(label: cell.mainCategoryLabel) :  cell.backgoundMainCategoryView.configureDesignOfCellNotSelected(label: cell.mainCategoryLabel)
    }
    
    
    
    //MARK: - Configure Cell For Product Details
    func ConfigureProductDetails(for cell:productDetailsCell,indexPath:IndexPath){
       
        if let imageUrl = URL(string: filterProduct[indexPath.row].image?.src ?? "") {
            cell.productImage.kf.setImage(with: imageUrl,placeholder: UIImage(named: "PlaceHolderImage"),options: [.callbackQueue(.mainAsync)]){
                sucsees in
                switch sucsees
                {
                case .success(let image):
                    
                    cell.productImage?.image = image.image
                    

                case .failure(_):
                    cell.productImage?.image = UIImage(named:"PlaceHolderImage")

                }
            }
        }
        cell.productName.text = filterProduct[indexPath.row].title
        cell.productPrice.text = "$\(filterProduct[indexPath.row].variants?.first?.price ?? "300")"
        cell.productId = filterProduct[indexPath.row].id
        cell.brandName.text = filterProduct[indexPath.row].vendor
        cell.setNotFavorites()
        for favoriteProduct in favoriteProducts {
            if favoriteProduct.id == filterProduct[indexPath.row].id{
                cell.setFavorite()
            }
        }
        cell.delegate = self

    }
    
    
    
    //MARK: - Get All Product filter to it's Category
    func getAllProduct(for mainCategory:Int){
        loadingAnimation?(true)

        BaseUrl.MainCategory = mainCategory
        apiNetworkManager.fetchData(url: BaseUrl.CategoryProduct , decodingModel: AllProduct.self) { result in
            switch result{
            case .success(let AllProducts):
                
                self.checkCustomerFavoriteProduct(for: self.custemerId)
                self.allProduct = AllProducts.products
                
                self.filterProduct.removeAll()
                self.favoriteProducts.removeAll()
               // self.allProduct.removeAll()

                for product in self.allProduct {
                    self.priceOfEveryProduct(for: product)
                }
                self.loadingAnimation?(false)
            case .failure(let error):
                self.errorOccurs?(String(describing: error.localizedDescription))
            }
        }
    }
    
    
    
    //MARK: - GET Data of Main And Sub Category
    
    func getSubCategoryData(for mainCategory: Int, with subCategory: String) {
        loadingAnimation?(true)

        BaseUrl.MainCategory = mainCategory
        BaseUrl.SubCategoryItem = subCategory
        apiNetworkManager.fetchData(url: BaseUrl.SubCategory , decodingModel: AllProduct.self) { result in
            
            switch result{
            case .success(let AllProducts):
                self.checkCustomerFavoriteProduct(for: self.custemerId)
                self.allProduct = AllProducts.products
                self.filterProduct.removeAll()
                self.favoriteProducts.removeAll()
               // self.allProduct.removeAll()
                for product in self.allProduct {
                    self.priceOfEveryProduct(for: product)
                }
                self.loadingAnimation?(false)
            case .failure(let error):
                self.errorOccurs?(String(describing: error.localizedDescription))
              
            }
        }
    }
   
    
    //MARK: - Get price of All
    func priceOfEveryProduct(for product:Product){
        BaseUrl.CategoryPriceID = product.id
          
        apiNetworkManager.fetchData(url: BaseUrl.CategoryProductPrice, decodingModel: SingleProduct.self) { result in
            switch result{
            case .success(let product):
                self.filterProduct.append(product.product)
               
            //    self.reload?()
            case .failure(let error):
                self.errorOccurs?(String(describing: error.localizedDescription))
            }
        }
        
    }
    
    
    
    //MARK: - to Check Favorites Product Of Customer
    func checkCustomerFavoriteProduct(for custmerId:Int){
        loadingAnimation?(true)
            wishListServices.getWishlist(forCustom: custmerId) { result in
                switch result{
                case.success(let favoriteProduct):
                    self.favoriteProducts = favoriteProduct
                    self.loadingAnimation?(false)
                    self.reload?()
                case .failure(let error):
                    self.errorOccurs?(String(describing: error.localizedDescription))
                }
            }
        }
    
    
    //MARK: - Check is the Content is Empty
    func bindNoProductFound()->Bool{
       
        return filterProduct.count == 0 ? false : true
        
    }
    
    
  
    
    
    //MARK: - To Check is All Product Category Or Not
    func CheckIsAllProductMainCategoryForAllProduct(for mainCategory:Int, with subCategory:String){
        
        if subCategory == K.all {
            getAllProduct(for: mainCategory)
        }else{
            getSubCategoryData(for: mainCategory, with: subCategory)
        }
        
       
        
        
    }
    
    
    
   //MARK: - Delegation of cell when Set Favorite
        func didTapButtonInCell(_ cell: productDetailsCell) {
            if  cell.favoriteIcon.currentImage == UIImage(systemName:  K.favoriteIconNotSave,withConfiguration: UIImage.SymbolConfiguration(scale: .medium)){
                cell.favoriteIcon.setImage(UIImage(systemName: K.favoriteIconSave,withConfiguration: UIImage.SymbolConfiguration(scale: .medium)), for: .normal)
                
                wishListServices.addToWishList(productID: cell.productId!, toCustomer: custemerId) { error in
                    if let error = error{
                        self.errorOccurs?(String(describing: error.localizedDescription))
                    }else{return}
                }
                
            }else{
                
                cell.favoriteIcon.setImage(UIImage(systemName: K.favoriteIconNotSave,withConfiguration: UIImage.SymbolConfiguration(scale: .medium)), for: .normal)
                wishListServices.removeWishList(productID: cell.productId!, fromCustomer: custemerId) { error in
                    if let error = error{
                        self.errorOccurs?(String(describing: error.localizedDescription))
                    }else{return}
                }
            }
        }
    
    
    
    //MARK:- Deliver Data about Filter Product
    func retrivedDataAboutProducts(for indexPath:IndexPath)->Product{
        return filterProduct[indexPath.row]
    }
    
    
    
    
    //MARK: - Filter Product According To Alphabetic
    func bindFilterProductAccordingAlphbetic() {
        loadingAnimation?(true)
        filterProduct =  filterProduct.sorted(by: {
            ($0.title ?? "Adel")  < ($1.title ?? "Mustafa")
        })
        loadingAnimation?(false)
        reload?()
    }
    
    //MARK: - Filter Product According To Price
    func bindFilterProductAccordingPrice() { loadingAnimation?(false)
        loadingAnimation?(true)
        filterProduct =  filterProduct.sorted(by: {
            Double($0.variants?.first?.price ?? "0" ) ?? 0 < Double($1.variants?.first?.price ?? "1") ?? 1
            
        })
        loadingAnimation?(false)
        reload?()
    }
    
    //MARK: - Filter according To Brand
    func filteraccodingToBrand(brandName:String){
      
        productForBrand =  filterProduct.filter({ $0.vendor == brandName
        })
        
      
        
    }
    
}
