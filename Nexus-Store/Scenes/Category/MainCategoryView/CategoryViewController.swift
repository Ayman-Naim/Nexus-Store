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
        navigationApperance()
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationApperance()
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
    
    // MARK: - Custom Cell of each section
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section{
        case 0 :
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.customCategoryCellIdetifier, for: indexPath) as! MainCategoryCell
            cell.mainCategoryLabel.text = mainCategory[indexPath.row]
            if (indexPath.row != 0) {
                cell.configureDesignOfCellNotSelected()
            }
            
            return cell
            
        case 1 :
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.customCategoryCellIdetifier, for: indexPath) as! MainCategoryCell
            cell.mainCategoryLabel.text = subCategory[indexPath.row]
            if (indexPath.row != 0) {
                cell.configureDesignOfCellNotSelected()
            }
            
            return cell
            
        case 2 :
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.customProductDetailsIdetifier, for: indexPath) as! productDetailsCell
            return cell
            
        default :
            return UICollectionViewCell()
            
        }
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
        
        CategoryCollectionView.register(UINib(nibName: K.customCategoryCellIdetifier, bundle: nil), forCellWithReuseIdentifier: K.customCategoryCellIdetifier)
        
        CategoryCollectionView.register(UINib(nibName:K.customCategoryCellIdetifier, bundle: nil), forCellWithReuseIdentifier: K.customCategoryCellIdetifier)
        
        CategoryCollectionView.register(UINib(nibName: K.customProductDetailsIdetifier, bundle: nil), forCellWithReuseIdentifier: K.customProductDetailsIdetifier)
        
       
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
            return     createFirstSection()
        case 1 :
            return    createFirstSection()
        case 2 :
            return    createSecondSection()
        default :
            return     createSecondSection()
        }
    }
    
    //MARK: - First Section For Compositional Layout
    func createFirstSection()-> NSCollectionLayoutSection{
        
        let inset:CGFloat = 0
        //item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1.2))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.31), heightDimension: .fractionalHeight(0.06))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        

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
       // group.contentInsets = NSDirectionalEdgeInsets(top: topInset, leading: leadingInset, bottom: bottomInset, trailing: trailingInset)
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    
    //MARK: - Custmize Apperance of Navigation Controller
    func navigationApperance(){
        
        
        let navigationBarAppearance = navigationController?.navigationBar

        navigationBarAppearance?.tintColor = UIColor.black
        navigationBarAppearance?.setBackgroundImage(UIImage(), for: .default)
        navigationBarAppearance?.shadowImage = UIImage()
        navigationBarAppearance?.isTranslucent = true
        // Set the font and text attributes for the navigation bar title
        let titleTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black, // Set the text color to white
            .font: UIFont.systemFont(ofSize: 32, weight: .regular) // Set the font and size
        ]
        navigationBarAppearance?.titleTextAttributes = titleTextAttributes

    }
    
    // MARK: - Setting Adding Favorite Button to NAvigation bar
    func configureFavoritueButton(){
        if let favoriteImage = UIImage(named: K.heartIcon) , let cartImage =  UIImage(named: K.cartIcon) ,let searchImage =  UIImage(named: K.searchIcon) {
            let favorite = UIBarButtonItem(image: favoriteImage, style: .plain, target: self, action:nil)
            let cart = UIBarButtonItem(image: cartImage, style: .plain, target: self, action:nil)
            let search = UIBarButtonItem(image: searchImage, style: .plain, target: self, action:nil)
            navigationItem.backButtonTitle = ""
            navigationItem.rightBarButtonItems = [favorite,cart]
            navigationItem.leftBarButtonItem = search
            navigationItem.rightBarButtonItems?.first?.tintColor = UIColor(red: 0.58, green: 0.58, blue: 0.58, alpha: 1)
            navigationItem.rightBarButtonItems?.last?.tintColor =  UIColor(red: 0.58, green: 0.58, blue: 0.58, alpha: 1)
            navigationItem.leftBarButtonItems?.last?.tintColor = UIColor(red: 0.58, green: 0.58, blue: 0.58, alpha: 1)
        }
        
        
    }
    
}
