//
//  ProductImageDelegation.swift
//  Nexus-Store
//
//  Created by Mustafa on 23/10/2023.
//

import UIKit


//MARK: - Configure Data Source of Collection Image
class ProdutImageDelegation:NSObject ,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {
    
    
    
    var itemDetails:Product
    var productImageCollection:UICollectionView
    var imageIndicator:UIPageControl
    
    
    init( collectionView: UICollectionView , with imageIndicator: UIPageControl ,itemDetails:Product) {
        self.productImageCollection = collectionView
        self.imageIndicator = imageIndicator
        self.itemDetails = itemDetails
        self.imageIndicator.numberOfPages = itemDetails.images?.count ?? 0
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemDetails.images?.count ?? 0
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: ProductImageCell.identifier, for: indexPath) as! ProductImageCell
        if let imageExistance = itemDetails.images?[indexPath.row].src{
            cell.configureImageOfProduct(urlString: imageExistance)
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        return CGSize(width: productImageCollection.bounds.width , height: productImageCollection.bounds.height )
    }
    
    
    
    
    
    //MARK: - layout Animation for Image
    func layoutSetup(){
        let layout = UICollectionViewCompositionalLayout { sectionIndex, enviroment in
            switch sectionIndex {
            case 0 :
                return self.Offers()
            default:
                return self.Offers()
                
            }
        }
        self.productImageCollection.setCollectionViewLayout(layout, animated: true)
    }
    
    
    //MARK: - Setup CompitionalLayout Animation
    func Offers()-> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1)
                                              , heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1)
                                               , heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize
                                                       , subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        
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
    
    
    //MARK: - Display Animation of Image Indicator
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        imageIndicator.currentPage = indexPath.row
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if imageIndicator.currentPage == indexPath.row {
            imageIndicator.currentPage = collectionView.indexPath(for: collectionView.visibleCells.first!)!.row
        }
    }
}
