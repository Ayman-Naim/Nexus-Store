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
    
    
    //MARK: - Conigure ViewWill Appear
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = K.categoryTitle
        
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        registerCollectionViewByCell()
        CategoryCollectionView.collectionViewLayout = createCompositionalLayout()
        configureFavoritueButton()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


//MARK: - Conform Delegation And Data Source for Category Collection

extension CategoryViewController : UICollectionViewDelegate,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout {
    
    // MARK: - Number od section in Collection View
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
            return 6
        default:
            return 0
        }
    }
    
    //MARK: - Selection Product Details
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       // let vc = ProductDetailsViewController(nibName: ProductDetailsViewController.identifier, bundle: nil)
        let storyboard = UIStoryboard(name:ProductDetailsViewController.storyBoardName , bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: ProductDetailsViewController.identifier) as! ProductDetailsViewController
         vc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
         vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
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
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(240))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
      
        // Section
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    



    // MARK: - Setting Adding Favorite Button to NAvigation bar
    func configureFavoritueButton(){
        if let favoriteImage = UIImage(named: K.heartIcon) , let cartImage =  UIImage(named: K.cartIcon) ,let searchImage =  UIImage(named: K.searchIcon) {
            let favorite = UIBarButtonItem(image: favoriteImage, style: .plain, target: self, action:nil)

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

    
}
