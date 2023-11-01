//
//  HomeViewController.swift
//  Nexus-Store
//
//  Created by ayman on 18/10/2023.
//

import UIKit
import Kingfisher
class HomeViewController: UIViewController {
    var ViewModel = HomeVM()
    var brands = [SmartCollection]()
 
    @IBOutlet weak var PageControl: UIPageControl!
    @IBOutlet weak var HomeCollectionView: UICollectionView!
    @IBOutlet weak var ProfileImage: UIImageView!
    
    @IBOutlet weak var SerachBarText: UISearchBar!
    @IBOutlet weak var UserName: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        circleImage()
        collectionSetup()
        layoutSetup()
        getBrands()
        setUserName()
        PageControl.numberOfPages = 15
        SerachBarText.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func layoutSetup(){
        let layout = UICollectionViewCompositionalLayout { sectionIndex, enviroment in
            switch sectionIndex {
            case 0 :
                return self.Offers()
            case 1 :
                return self.Brands()
            default:
                return self.Brands()
                
            }
        }
        self.HomeCollectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    
    @IBAction func CartButtonClicked(_ sender: Any) {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(CartViewController(), animated: true)
    }
    
    @IBAction func favouriteButtonClicked(_ sender: Any) {
        self.navigationController?.pushViewController(WishListViewController(), animated: true)
    }
    
    
    
    func circleImage(){
        self.ProfileImage.layer.cornerRadius = self.ProfileImage.frame.size.width/2;
        self.ProfileImage.layer.masksToBounds = true
        self.ProfileImage.contentMode = .scaleAspectFill
        self.ProfileImage.layer.borderWidth = 1.5
        
    }
    func setUserName(){
        let user = ViewModel.getUserData()
        switch user{
        case.success(let userEmail):
            UserName.text = userEmail
        case.failure(let error ):
            UserName.text = error.localizedDescription
            
        }
        
    }
    
    func collectionSetup(){
        self.HomeCollectionView.register(UINib(nibName: "OffersCell", bundle: nil), forCellWithReuseIdentifier: "OffersCell" )
        
        self.HomeCollectionView.register(UINib(nibName: "BrandsCollectionCell", bundle: nil), forCellWithReuseIdentifier: "BrandsCollectionCell" )
        self.HomeCollectionView.register(UINib(nibName: "SectionHeaderReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader")
        
        // collectionView.register(UINib(nibName: "CollectionReusableView", bundle: nil), forSupplementaryViewOfKind: "SectionHeaderElementKind", withReuseIdentifier: "headerView")
        
        self.HomeCollectionView.delegate = self
        self.HomeCollectionView.dataSource = self
        
        //setup the paging of offers
        //let paging
        
        
        
    }
    
    func Offers()-> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1)
                                              , heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1)
                                               , heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize
                                                       , subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0
                                                      , bottom: 0, trailing: 40)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 15
                                                        , bottom: 10, trailing: 0)
        section.orthogonalScrollingBehavior = .paging
        section.boundarySupplementaryItems = [self.supplementtryHeader()]
        
        //animation
        
        section.visibleItemsInvalidationHandler = { items, offset, environment in
            items.forEach { item in
                if item.representedElementCategory == .cell {
                    let distanceFromCenter = abs((item.frame.midX - offset.x) - environment.container.contentSize.width / 2.0)
                    let minScale: CGFloat = 0.8
                    let maxScale: CGFloat = 1.0
                    let scale = max(maxScale - (distanceFromCenter / environment.container.contentSize.width), minScale)
                    item.transform = CGAffineTransform(scaleX: scale, y: scale)
                }
            }
        }
        
        
        
        
        return section
    }
    
    
    func Brands()-> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(120)
                                              , heightDimension: .absolute(120))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(145)
                                               , heightDimension: .estimated(145))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, repeatingSubitem: item, count: 2)
        group.interItemSpacing = .fixed(15)
        
        
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 40)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 0)
        section.orthogonalScrollingBehavior = .paging
        section.boundarySupplementaryItems = [self.supplementtryHeader()]
        
        
        //animation
        
        section.visibleItemsInvalidationHandler = { items, offset, environment in
            items.forEach { item in
                if item.representedElementCategory == .cell {
                    let distanceFromCenter = abs((item.frame.midX - offset.x) - environment.container.contentSize.width / 2.0)
                    let minScale: CGFloat = 0.8
                    let maxScale: CGFloat = 1.0
                    let scale = max(maxScale - (distanceFromCenter / environment.container.contentSize.width), minScale)
                    item.transform = CGAffineTransform(scaleX: scale, y: scale)
                }
            }
        }
       
        return section
    }
    
   
    
    
}



extension HomeViewController :UICollectionViewDelegate,UICollectionViewDataSource{
    
    
    //MARK: - Display Animation of Image Indicator
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            PageControl.currentPage = indexPath.row
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if PageControl.currentPage == indexPath.row {
                PageControl.currentPage = collectionView.indexPath(for: collectionView.visibleCells.first!)!.row
            }
        }
        
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section{
        case 0 :
            return 15
        case 1 :
            return brands.count
            
        default:
            return 12
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section{
        case 0 :
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OffersCell", for: indexPath) as! OffersCell
            cell.backgroundColor = .gray
            cell.OfferImage.image = UIImage(named: "offers")
            
            
            return cell
        case 1 :
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrandsCollectionCell", for: indexPath) as! BrandsCollectionCell
            if let imageUrl = URL(string: self.brands[indexPath.row].image?.src ?? "") {
                cell.BrandLogo.kf.setImage(with: imageUrl,placeholder: UIImage(named: "App-logo"),options: [.callbackQueue(.mainAsync)]){
                    sucsees in
                    switch sucsees
                    {
                    case .success(let image):
                        
                        cell.BrandLogo?.image = image.image//self.resizeImage(image: image.image, newWidth: 1000/4)
                        

                    case .failure(_):
                        cell.BrandLogo?.image = UIImage(named:"App-logo")

                    }
                }
            }
            else{
                cell.BrandLogo.image = UIImage(named: "App-logo")
            }
            
            cell.BrandName.text = brands[indexPath.row].title
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OffersCell", for: indexPath) as! OffersCell
            cell.backgroundColor = .gray
            cell.OfferImage.image = UIImage(named: "offers")
            
            
            return cell
        }
        
        
       
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section{
        case 0 :
            // write to clipboard
            UIPasteboard.general.string = "\(indexPath.row)"
            // resd to clipboard
            guard let promo = UIPasteboard.general.string else{return}
            //Alett for promo copied
            Alert.show(on: self, title: "Offer Code", message: "the offer promo code is copied \(promo)", actions: [(UIAlertAction(title: "ok", style: .default))])
            
       
      
            
        case 1 :
            let vc = CategoryViewController()
            vc.fromBrand = true
            vc.forMainCategory = K.menID
            vc.forSubCategory = K.all
            CategoryViewModuleRefactor.selectedMainCategory = 0
            CategoryViewModuleRefactor.selectedSubCategory = 0
            vc.vendor = brands[indexPath.item].title ?? "ADIDAS"
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            print("nothing")
        }
        
    }
    
    //function for resieze the image
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {

        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
    
    
    //MARK: Header Functions
    func supplementtryHeader()->NSCollectionLayoutBoundarySupplementaryItem{
        
        .init(layoutSize: .init(widthDimension:.fractionalWidth(1), heightDimension: .estimated(50)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top )
        
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader{
            let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as! SectionHeaderReusableView
            
            switch indexPath.section {
            case 0 :
                sectionHeader.SectionHeader?.text = "Special Offers"
                return sectionHeader
                
            case 1 :
                sectionHeader.SectionHeader?.text = "Brands"
                return sectionHeader
                
            default:
                UICollectionViewCell()
            }
        }
        return UICollectionViewCell()
    }
    
    
    
    
    //MARK: Functions For Animation
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


// MARK: - SearchTextField
extension HomeViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        SearchViewController.present(on: self)
        return true
    }
}

extension HomeViewController{
  
    func getBrands(){
        ViewModel.getBrands { result in
            switch result{
            case .success(let brands):
                print(brands)
                self.brands = brands
                self.HomeCollectionView.reloadData()
                
            case .failure(let error):
                print(error)
                
                
            }
            
        }
    }
    
    
}
