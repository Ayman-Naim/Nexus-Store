//
//  CategoryViewController.swift
//  Nexus-Store
//
//  Created by Mustafa on 19/10/2023.
//

import UIKit

class CategoryViewController: UIViewController {
    @IBOutlet weak var CategoryCollectionView: UICollectionView!
    @IBOutlet weak var listFilterButton: UIButton!
    @IBOutlet weak var alphapiticFilter: UIButton!
    @IBOutlet weak var PriceFilterButton: UIButton!
    private let categoryViewModuleRefactor = CategoryViewModuleRefactor()
    var forMainCategory:Int = K.menID
    var forSubCategory:String = K.all
    var checkApperane = 0
    var flagShowFilter = false
    var fromBrand = false
    var vendor:String = ""
   
    
    
    //MARK: - Set All Data when Will Appear
    override func viewWillAppear(_ animated: Bool) {
        
        forMainCategory = K.menID
        forSubCategory = K.all
        CategoryViewModuleRefactor.selectedMainCategory = 0
        CategoryViewModuleRefactor.selectedSubCategory = 0
        DispatchQueue.main.async {
            self.CategoryCollectionView.reloadSections(IndexSet(integer: 0))
            self.CategoryCollectionView.reloadSections(IndexSet(integer: 1))

        }
        
        if fromBrand == true {
           
            categoryViewModuleRefactor.CheckIsAllProductMainCategoryForAllProduct(for: forMainCategory, with: forSubCategory)
            navigationItem.leftBarButtonItem?.isHidden  = true
        }
        if checkApperane != 1{
            categoryViewModuleRefactor.CheckIsAllProductMainCategoryForAllProduct(for: forMainCategory, with: forSubCategory)

        }
        
    }
    
    //MARK: - Configure ViewWill Appear
    override func viewDidAppear(_ animated: Bool) {
        self.addLogoToNavigationBarItem(logoImage: K.darkModeLogo)
      
    }
    
    
    //MARK: - Configure Will DisAppear
    override func viewWillDisappear(_ animated: Bool) {
        checkApperane = 0
        navigationItem.leftBarButtonItem?.isHidden  = false

        
    }
    
    //MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        checkApperane = 1
        configureCollectionView()
        registerCollectionViewByCell()
        CategoryCollectionView.collectionViewLayout = createCompositionalLayout()
        bindViewModel()
       
        configureFavoritueButton()
        loadShadowToButton(listFilterButton)
        loadShadowToButton(alphapiticFilter)
        loadShadowToButton(PriceFilterButton)
        if fromBrand == false{
            categoryViewModuleRefactor.CheckIsAllProductMainCategoryForAllProduct(for: forMainCategory, with: forSubCategory)
        }
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    

    
    
    @IBAction func ListToChooseFilter(_ sender: UIButton) {
           showFiltersButton()
    }
    
    @IBAction func filterProductAlphabeticButton(_ sender: Any) {
        
        categoryViewModuleRefactor.bindFilterProductAccordingAlphbetic()
        
    }
    @IBAction func filterProductPriceButton(_ sender: UIButton) {
        
        categoryViewModuleRefactor.bindFilterProductAccordingPrice()
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
            return categoryViewModuleRefactor.numberOfMainCategory
        case 1:
            return categoryViewModuleRefactor.numberOfsubCategory
        case 2:
            self.isContentEmptyViewHidden = categoryViewModuleRefactor.numberOfProduct != 0
            return  categoryViewModuleRefactor.numberOfProduct
        default:
            return 0
        }
    }
    
    
    
    
    
    //MARK: - Selection Product Details
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.section {
            
        case 0:
            
            switch indexPath.row{
            case 0:
                forMainCategory =  K.menID
                CategoryViewModuleRefactor.selectedMainCategory = 0
            case 1:
                forMainCategory =  K.kidID
                CategoryViewModuleRefactor.selectedMainCategory = 1

            case 2:
                forMainCategory = K.saleID
                CategoryViewModuleRefactor.selectedMainCategory = 2

            case 3:
                forMainCategory = K.womenID
                CategoryViewModuleRefactor.selectedMainCategory = 3

                
            default:
                print("Finish")
            }
            
            
            categoryViewModuleRefactor .CheckIsAllProductMainCategoryForAllProduct(for: forMainCategory, with: forSubCategory)
            ChangeMainAndSubColor(collectionView: collectionView, indexPath: indexPath, section: 0)
            
        case 1:
            
            
            switch indexPath.row{
            case 0:
                forSubCategory = K.all
                CategoryViewModuleRefactor.selectedSubCategory = 0
            case 1:
                forSubCategory = K.shoes
                CategoryViewModuleRefactor.selectedSubCategory = 1

            case 2:
                forSubCategory = K.tShirt
                CategoryViewModuleRefactor.selectedSubCategory = 2

            case 3:
                forSubCategory = K.accessories
                CategoryViewModuleRefactor.selectedSubCategory = 3

            default:
                print("Finish")
                
            }
            categoryViewModuleRefactor .CheckIsAllProductMainCategoryForAllProduct(for: forMainCategory, with: forSubCategory)
            ChangeMainAndSubColor(collectionView: collectionView, indexPath: indexPath, section: 1)
            
        case 2:
          
            let product = categoryViewModuleRefactor.retrivedDataAboutProducts(for: indexPath)
                let storyboard = UIStoryboard(name:ProductDetailsViewController.storyBoardName , bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: ProductDetailsViewController.identifier) as! ProductDetailsViewController
                let productDetailsViewModel = ProductDetailsViewModel(for: product.id)
                vc.productDetailsViewModel = productDetailsViewModel
                vc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                vc.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(vc, animated: true)
            
            
            
            
        default:
            print("Done")
        }
        
        
        
    }
    
    // MARK: - Custom Cell of each section
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section{
        case 0 :
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.customCategoryCellIdetifier, for: indexPath) as! MainCategoryCell
            categoryViewModuleRefactor.mainCategoeyCellConfiguration(cell: cell, indexPath: indexPath)
            
            return cell
            
        case 1 :
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.customCategoryCellIdetifier, for: indexPath) as! MainCategoryCell
            categoryViewModuleRefactor.subCategoeyCellConfiguration(cell: cell, indexPath: indexPath)
            
            return cell
            //
        case 2 :
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.customProductDetailsIdetifier, for: indexPath) as! productDetailsCell
            
            categoryViewModuleRefactor.ConfigureProductDetails(for: cell, indexPath: indexPath)
            
            return cell
            
        default :
            return UICollectionViewCell()
            
        }
        
        
    }
    
    //MARK: - Bind View of Category
    private func bindViewModel() {
        categoryViewModuleRefactor.loadingAnimation = { [weak self] isLoading in
            DispatchQueue.main.async {
                self?.isLoadingIndicatorAnimating = isLoading
            }
        }
        
        categoryViewModuleRefactor.reload = { [weak self] in
            DispatchQueue.main.async {
            
                self?.CategoryCollectionView.reloadSections(IndexSet(integer: 2))
               
                if self?.fromBrand == true {
                    self?.categoryViewModuleRefactor.filteraccodingToBrand(brandName: self!.vendor)
                    self?.CategoryCollectionView.reloadSections(IndexSet(integer: 2))
                }
                
               
            }
        }
        
        categoryViewModuleRefactor.errorOccurs = { [weak self] error in
            self?.isLoadingIndicatorAnimating = false
            Alert.show(on: self!, title: "Error", message: error)
        }
    }
    
    
    //MARK: - Change Highlight Of cell
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
    
    
}
//MARK: - Changing Product According Main And SubCategory
   
extension CategoryViewController {
        
        func loadShadowToButton(_ Button:UIButton){
            Button.layer.shadowColor = UIColor.black.cgColor
            Button.layer.shadowOffset = CGSize(width: 0, height: 2)
            Button.layer.shadowOpacity = 0.7
            Button.layer.shadowRadius = 4
        }
        
        func showFiltersButton(){
            
            self.PriceFilterButton.alpha = (flagShowFilter == false ) ? 0 : 1
            self.alphapiticFilter.alpha = (flagShowFilter == false) ? 0 : 1
            
            UIView.animate(withDuration: 0.8) {
                self.PriceFilterButton.isHidden = self.flagShowFilter
                self.alphapiticFilter.isHidden = self.flagShowFilter
                
                self.PriceFilterButton.alpha = ( self.flagShowFilter == false) ? 1 : 0
                self.alphapiticFilter.alpha = (self.flagShowFilter == false) ? 1 : 0
                
            }
            
            self.flagShowFilter = !self.flagShowFilter
            
        }
}

