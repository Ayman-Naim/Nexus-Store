//
//  HomeViewController.swift
//  Nexus-Store
//
//  Created by ayman on 18/10/2023.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var HomeCollectionView: UICollectionView!
    @IBOutlet weak var ProfileImage: UIImageView!
    
    @IBOutlet weak var SerachBarText: UISearchBar!
    @IBOutlet weak var UserName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        circleImage()
        collectionSetup()
        layoutSetup()
       
        SerachBarText.delegate = self
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
        self.navigationController?.pushViewController(CartViewController(), animated: true)
    }
    
    @IBAction func favouriteButtonClicked(_ sender: Any) {
        //
    }
    
    
    
    func circleImage(){
        self.ProfileImage.layer.cornerRadius = self.ProfileImage.frame.size.width/2;
        self.ProfileImage.layer.masksToBounds = true
        self.ProfileImage.contentMode = .scaleAspectFill
        
    }
    
    func collectionSetup(){
        self.HomeCollectionView.register(UINib(nibName: "OffersCell", bundle: nil), forCellWithReuseIdentifier: "OffersCell" )
        
        self.HomeCollectionView.register(UINib(nibName: "BrandsCollectionCell", bundle: nil), forCellWithReuseIdentifier: "BrandsCollectionCell" )
        self.HomeCollectionView.register(UINib(nibName: "SectionHeaderReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader")
        
       // collectionView.register(UINib(nibName: "CollectionReusableView", bundle: nil), forSupplementaryViewOfKind: "SectionHeaderElementKind", withReuseIdentifier: "headerView")
        
        self.HomeCollectionView.delegate = self
        self.HomeCollectionView.dataSource = self
       
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
                                               , heightDimension: .estimated(100))
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
   
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section{
        case 0 :
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OffersCell", for: indexPath) as! OffersCell
            cell.backgroundColor = .gray
            cell.OfferImage.image = UIImage(named: "offers")
            cell.pageIndicator.numberOfPages = 15
            cell.pageIndicator.currentPage = indexPath.row

            return cell
        case 1 :
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrandsCollectionCell", for: indexPath) as! BrandsCollectionCell
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OffersCell", for: indexPath) as! OffersCell
            cell.backgroundColor = .gray
            cell.OfferImage.image = UIImage(named: "offers")
            cell.pageIndicator.numberOfPages = 15
            cell.pageIndicator.currentPage = indexPath.row
            return cell
        }
        
       
        
        return UICollectionViewCell()
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
