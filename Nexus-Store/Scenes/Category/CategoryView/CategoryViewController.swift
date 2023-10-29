//
//  CategoryViewController.swift
//  Nexus-Store
//
//  Created by Mustafa on 19/10/2023.
//

import UIKit

class CategoryViewController: UIViewController {
    @IBOutlet weak var CategoryCollectionView: UICollectionView!
    
    let mainCategory = ["MEN","KIDS","SALE","WOMEN"]
    let subCategory = ["ALL","SHOES","T-SHIRT","ACCESSORIES"]
    
    let productSection = IndexSet(integer: 2)
    var forMainCategory:Int = K.menID
    var flagSubCategory = 0
    var categoryProductProtocol:CategoryViewModelDelgation?
    
    var fromBrand:Bool?
    var vendor:String?
    var vendorProductList:[Product]?
    let wishListServices = WishListService()
    var favoriteProducts:[Product]? {
        didSet{
            DispatchQueue.main.async {
                self.CategoryCollectionView.reloadSections(self.productSection)
                self.isLoadingIndicatorAnimating = false
                self.CategoryCollectionView.isUserInteractionEnabled = true
            }
        }
    }
    let custemerId:Int = 6899149865196
    var products:[Product]? {
        didSet{
            if products?.count == 0 && filterProduct.count == 0{
                
                self.CategoryCollectionView.reloadSections(self.productSection)
                
            }
        }
    }
    var filterProduct :[Product] = [] {
        didSet {
            if Array(Set(filterProduct)).count == products?.count  && filterProduct.count != 0  {
                
                DispatchQueue.main.async {
                    self.products?.removeAll()
                    if self.fromBrand != nil {
                        self.vendorProductList = self.filterProduct.filter({ $0.vendor == self.vendor })
                        self.products = self.vendorProductList
                    }else{
                        self.products = self.filterProduct
                    }
                  //  self.CategoryCollectionView.reloadSections(self.productSection)
                    self.isLoadingIndicatorAnimating = false
                    self.CategoryCollectionView.isUserInteractionEnabled = true
                    
                }
            }
        }
    }
    
    var endPoint = BaseUrl.CategoryProduct
    
    
    
    
    
    //MARK: - Set All Data when Will Appear
    override func viewWillAppear(_ animated: Bool) {
        self.isLoadingIndicatorAnimating = true
        self.CategoryCollectionView.isUserInteractionEnabled = false
        checkCustomerFavoriteProduct()
       
    }
    
    //MARK: - Conigure ViewWill Appear
    override func viewDidAppear(_ animated: Bool) {
        self.addLogoToNavigationBarItem(logoImage: K.darkModeLogo)
        if fromBrand != nil{
            tabBarController?.tabBar.isHidden = true
        }
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        if fromBrand != nil{
            tabBarController?.tabBar.isHidden = false
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        registerCollectionViewByCell()
        CategoryCollectionView.collectionViewLayout = createCompositionalLayout()
        configureFavoritueButton()
        ConfigureFetchDataFromApi(with: K.menID)
        checkCustomerFavoriteProduct()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
    func ConfigureFetchDataFromApi(with endPointFilter:Int){
        BaseUrl.MainCategory = endPointFilter
        categoryProductProtocol = CategoryViewModel()
        self.CategoryCollectionView.isUserInteractionEnabled = false
        categoryProductProtocol?.getAllProduct(with: BaseUrl.CategoryProduct)
        categoryProductProtocol?.fetchProductToCategoryView = { [weak self] in
            self?.products = self?.categoryProductProtocol?.RetiviedProductResult()
            self?.CategoryCollectionView.isUserInteractionEnabled = true
            self?.allProductofMainCategory()
        }
        
        
    }
    
    
    
    
}


//MARK: - Conform Delegation And Data Source for Category Collection

extension CategoryViewController : UICollectionViewDelegate,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout {
    
    // MARK: - Number of section in Collection View
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    // MARK: - Number of item in each Collection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section{
        case 0:
            return 4
        case 1:
            return 4
        case 2:
            return products?.count ?? 0
        default:
            return 0
        }
    }
    
    //MARK: - Selection Product Details
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.section {
            
        case 0:
            ChangeMainAndSubColor(collectionView: collectionView, indexPath: indexPath, section: 0)
            switch indexPath.row{
            case 0:
                GetMainCategoryData(with : K.menID)
                forMainCategory = K.menID
            case 1:
                GetMainCategoryData(with : K.kidID)
                forMainCategory =  K.kidID
            case 2:
                GetMainCategoryData(with : K.saleID)
                forMainCategory =  K.saleID
            case 3:
                GetMainCategoryData(with : K.womenID)
                forMainCategory =  K.womenID
                
            default:
                print("Finish")
            }
            
            
        case 1:
            ChangeMainAndSubColor(collectionView: collectionView, indexPath: indexPath, section: 1)
            switch indexPath.row{
            case 0:
                GetMainCategoryData(with : forMainCategory)
                flagSubCategory = 0
            case 1:
                GetSubCategoryData(for: forMainCategory, with: K.shoes)
                flagSubCategory = 1
            case 2:
                GetSubCategoryData(for: forMainCategory, with: K.tShirt)
                flagSubCategory = 2
            case 3:
                GetSubCategoryData(for: forMainCategory, with: K.accessories)
                flagSubCategory = 3
            default:
                print("Finish")
                
            }
            
        case 2:
            if let product = products?[indexPath.row] {
                let storyboard = UIStoryboard(name:ProductDetailsViewController.storyBoardName , bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: ProductDetailsViewController.identifier) as! ProductDetailsViewController
                let productDetailsViewModel = ProductDetailsViewModel(for: product.id)
                vc.productDetailsViewModel = productDetailsViewModel
                vc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                vc.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        default:
            print("Done")
        }
        
        
        
    }
    
    // MARK: - Custom Cell of each section
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section{
        case 0 :
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.customCategoryCellIdetifier, for: indexPath) as! MainCategoryCell
            cell.mainCategoryLabel.text = mainCategory[indexPath.row]
            
            indexPath.row == 0 ? cell.backgoundMainCategoryView.configureDesignOfcellSelected(label: cell.mainCategoryLabel) :  cell.backgoundMainCategoryView.configureDesignOfCellNotSelected(label: cell.mainCategoryLabel)
            
            return cell
            
        case 1 :
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.customCategoryCellIdetifier, for: indexPath) as! MainCategoryCell
            cell.mainCategoryLabel.text = subCategory[indexPath.row]
            
            indexPath.row == 0 ? cell.backgoundMainCategoryView.configureDesignOfcellSelected(label: cell.mainCategoryLabel) :  cell.backgoundMainCategoryView.configureDesignOfCellNotSelected(label: cell.mainCategoryLabel)
            
            return cell
            
        case 2 :
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.customProductDetailsIdetifier, for: indexPath) as! productDetailsCell
            cell.ConfigureProductDetails(product: products?[indexPath.row])
            cell.delegate = self
            
            if let favoriteProducts = favoriteProducts{
                for favoriteProduct in favoriteProducts{
                    if  favoriteProduct.id == products?[indexPath.row].id{
                        
                        cell.setFavorite()
                        
                    }
                }
            }
            return cell
            
        default :
            return UICollectionViewCell()
            
        }
    }
    
    
    //MARK: Header Functions
    func supplementtryFooter()->NSCollectionLayoutBoundarySupplementaryItem{
        
        .init(layoutSize: .init(widthDimension:.fractionalWidth(1), heightDimension: .absolute(1)), elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom )
        
    }
    
    
    // MARK: - Setting Header of each section
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionFooter{
            let sectionFooter = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Seperator", for: indexPath) as! CustomFooterSepertator
            
            switch indexPath.section {
            case 0 :
                
                return sectionFooter
                
                
            default:
                return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Cell", for: indexPath)
            }
        }
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Cell", for: indexPath)
    }
    
    
    
    
}


//MARK: - Adding functionality and Logic of Category Collection
extension CategoryViewController{
    
    // MARK: - ConfigureCollectionView
    func configureCollectionView(){
        CategoryCollectionView.delegate = self
        CategoryCollectionView.dataSource = self
        
    }
    
    //MARK: -  Configure Collection View Register
    
    func registerCollectionViewByCell(){
        
        self.CategoryCollectionView!.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "Cell")
        
        
        CategoryCollectionView.register(UINib(nibName: K.customCategoryCellIdetifier, bundle: nil), forCellWithReuseIdentifier: K.customCategoryCellIdetifier)
        
        CategoryCollectionView.register(UINib(nibName:K.customCategoryCellIdetifier, bundle: nil), forCellWithReuseIdentifier: K.customCategoryCellIdetifier)
        
        CategoryCollectionView.register(UINib(nibName: K.customProductDetailsIdetifier, bundle: nil), forCellWithReuseIdentifier: K.customProductDetailsIdetifier)
        CategoryCollectionView.register(UINib(nibName: K.customFooterNib, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "Seperator")
        
        
    }
    
    
    // MARK: - create Compositional Layout
    func createCompositionalLayout()-> UICollectionViewCompositionalLayout  {
        let layout = UICollectionViewCompositionalLayout { [weak self] (index , enviroment) -> NSCollectionLayoutSection? in
            return self?.createSectionFor(index: index, environment: enviroment)
        }
        return layout
    }
    
    func createSectionFor( index:Int , environment : NSCollectionLayoutEnvironment)-> NSCollectionLayoutSection{
        
        switch index {
        case 0 :
            return     createFirstSection(withFooter:true)
        case 1 :
            return     createFirstSection(withFooter:false)
        case 2 :
            return     createSecondSection()
        default :
            return     createSecondSection()
        }
    }
    
    //MARK: - First Section For Compositional Layout
    func createFirstSection(withFooter:Bool)-> NSCollectionLayoutSection{
        
        let inset:CGFloat = 5
        //item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        // item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.31), heightDimension: .fractionalHeight(0.06))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: 0, bottom: inset, trailing: inset)
        section.boundarySupplementaryItems = withFooter == true ? [self.supplementtryFooter()] : []
        
        return section
    }
    
    //MARK: - Second Section For Compositional Layout
    func createSecondSection() -> NSCollectionLayoutSection {
        let topInset: CGFloat = 10
        let bottomInset: CGFloat = 5
        let leadingInset: CGFloat = 5
        let trailingInset: CGFloat = 5
        
        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: topInset, leading: leadingInset, bottom: bottomInset, trailing: trailingInset)
        
        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(270))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    
    
    
    
    // MARK: - Setting Adding Favorite Button to NAvigation bar
    func configureFavoritueButton(){
        if let favoriteImage = UIImage(named: K.heartIcon) , let cartImage =  UIImage(named: K.cartIcon) ,let searchImage =  UIImage(named: K.searchIcon) {
            let favorite = UIBarButtonItem(image: favoriteImage, style: .plain, target: self, action:#selector(favoriteButtonPressed))
            let cart = UIBarButtonItem(image: cartImage, style: .plain, target: self, action: #selector(cartBarButtonPressed))
            let search = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(searchBarButtonClicked))
            navigationItem.backButtonTitle = ""
            navigationItem.rightBarButtonItems = [favorite,cart]
            navigationItem.leftBarButtonItem = search
            navigationItem.rightBarButtonItems?.first?.tintColor = UIColor(red: 0.58, green: 0.58, blue: 0.58, alpha: 1)
            navigationItem.rightBarButtonItems?.last?.tintColor =  UIColor(red: 0.58, green: 0.58, blue: 0.58, alpha: 1)
            navigationItem.leftBarButtonItems?.last?.tintColor = UIColor(red: 0.58, green: 0.58, blue: 0.58, alpha: 1)
        }
        
        
    }
    
    
    @objc private func cartBarButtonPressed() {
        self.navigationController?.pushViewController(CartViewController(), animated: true)
    }
    
    @objc private func searchBarButtonClicked() {
        SearchViewController.present(on: self)
    }
    @objc private func favoriteButtonPressed() {
        self.navigationController?.pushViewController(WishListViewController(), animated: true)
    }
    
    //MARK: - Change Color of Main and Sub Category
    func ChangeMainAndSubColor(collectionView:UICollectionView,indexPath:IndexPath,section:Int){
        // Get the number of items in the section
        let itemCount = collectionView.numberOfItems(inSection: section)
        // Create a countable range of index paths for the section
        let indexPaths = (0..<itemCount).map { IndexPath(item: $0, section: section) }
        // Loop through the cells in the section
        for index in indexPaths {
            if let cell = collectionView.cellForItem(at: index) as? MainCategoryCell {
                cell.backgoundMainCategoryView.configureDesignOfCellNotSelected(label: cell.mainCategoryLabel)
                if  index.row == indexPath.row{
                    cell.backgoundMainCategoryView.configureDesignOfcellSelected(label: cell.mainCategoryLabel)
                }
            }
            
        }
    }
    
}


//MARK: - Changing Product According Main And SubCategory

extension CategoryViewController {
    
    //MARK: - Get all Data Needed Main Catgory
    func GetMainCategoryData(with mainCategory:Int){
        
        BaseUrl.MainCategory = mainCategory
        self.CategoryCollectionView.isUserInteractionEnabled = false
        categoryProductProtocol?.getAllProduct(with: BaseUrl.CategoryProduct)
        categoryProductProtocol?.fetchProductToCategoryView = { [weak self] in
            self?.products?.removeAll()
            self?.filterProduct.removeAll()
            self?.products = self?.categoryProductProtocol?.RetiviedProductResult()
            self?.switchsubCategory(flagNumber: self!.flagSubCategory)
            self?.CategoryCollectionView.isUserInteractionEnabled = true
            
        }
        
        
        
    }
    
    func switchsubCategory(flagNumber:Int){
        if flagNumber == 0 {
            self.CategoryCollectionView.isUserInteractionEnabled = false
            categoryProductProtocol?.getAllProduct(with: BaseUrl.CategoryProduct)
            categoryProductProtocol?.fetchProductToCategoryView = { [weak self] in
                self?.products?.removeAll()
                self?.filterProduct.removeAll()
                self?.products = self?.categoryProductProtocol?.RetiviedProductResult()
                self?.allProductofMainCategory()
                self?.CategoryCollectionView.isUserInteractionEnabled = true
                
            }
            
        }
        
        else if flagNumber == 1 {
            GetSubCategoryData(for: forMainCategory, with: K.shoes)
        }
        else if flagNumber == 2 {
            GetSubCategoryData(for: forMainCategory, with: K.tShirt)
        }
        else if flagNumber == 3 {
            GetSubCategoryData(for: forMainCategory, with: K.accessories)
        }
        
    }
    
    
    //MARK: - Get all Data Needed sub Catgory
    
    func GetSubCategoryData(for mainCategory:Int , with subCategory:String){
        
        self.CategoryCollectionView.isUserInteractionEnabled = false
        categoryProductProtocol?.getSubCategoryData(for: mainCategory, with: subCategory, Handeler: { products in
            self.products?.removeAll()
            self.filterProduct.removeAll()
            self.products = products
            self.allProductofMainCategory()
            self.CategoryCollectionView.isUserInteractionEnabled = true
            
            
            
        })
    }
    
    //MARK: - Get all Data Needed Price
    func allProductofMainCategory(){
        if let validProducts =  products {
            self.isLoadingIndicatorAnimating = !validProducts.isEmpty
            self.CategoryCollectionView.isUserInteractionEnabled = validProducts.isEmpty
            self.filterProduct.removeAll()
            
            for product in validProducts{
                categoryProductProtocol?.priceOfEveryProduct(for:product, Handeler: { productItem in
                    
                    if productItem.id == product.id {
                        self.filterProduct.append(productItem)
                    }
                })
                
            }
        }
        
        
    }
}

//MARK: - Set Favorite to the product
extension CategoryViewController : CustomNibCellProtocol{
    func didTapButtonInCell(_ cell: productDetailsCell) {
        
        
        
        
        if  cell.favoriteIcon.currentImage == UIImage(systemName:  K.favoriteIconNotSave,withConfiguration: UIImage.SymbolConfiguration(scale: .medium)){
            cell.favoriteIcon.setImage(UIImage(systemName: K.favoriteIconSave,withConfiguration: UIImage.SymbolConfiguration(scale: .medium)), for: .normal)
            
            wishListServices.addToWishList(productID: cell.productId!, toCustomer: custemerId) { error in
                if let error = error{
                    print(error.localizedDescription)
                }else{return}
            }
            
        }else{
            cell.favoriteIcon.setImage(UIImage(systemName: K.favoriteIconNotSave,withConfiguration: UIImage.SymbolConfiguration(scale: .medium)), for: .normal)
            
            
            wishListServices.removeWishList(productID: cell.productId!, fromCustomer: custemerId) { error in
                if let error = error{
                    print(error.localizedDescription)
                }else{return}
            }
        }
        
       
        
    }
    
    
    func checkCustomerFavoriteProduct(){
        wishListServices.getWishlist(forCustom: custemerId) { result in
            switch result{
            case.success(let favoriteProduct):
                self.favoriteProducts = favoriteProduct
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    

    
    
}

