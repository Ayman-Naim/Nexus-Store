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
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var reviewCollectionView: UICollectionView!
    @IBOutlet weak var productImageCollection: UICollectionView!
    @IBOutlet weak var productType: UILabel!
    @IBOutlet weak var rating: CosmosView!
    @IBOutlet weak var productBrand: UILabel!
    @IBOutlet weak var descriptionOfProduct: UILabel!
    @IBOutlet weak var colorCollectionView: UICollectionView!
    @IBOutlet weak var sizeCollectionView: UICollectionView!
    
  
    var productSizeDelegation = ProductSizeDelegation()
    var productColorDelegation = ProductColorDelegation()
    var productReviewDelegation = ProductReviewDelegation()
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.isTranslucent = false

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSourceofImageCollection()
      //  productImageCollection.contentInsetAdjustmentBehavior = .never
        contentView.translatesAutoresizingMaskIntoConstraints = false
       
        layoutSetup()
        // Do any additional setup after loading the view.
    }



}


//MARK: - Configure Data Source of Collection Image
extension ProductDetailsViewController:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {

    func configureDataSourceofImageCollection(){
        productImageCollection.dataSource = self
        productImageCollection.delegate = self
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


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
       

        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: ProductImageCell.identifier, for: indexPath) as! ProductImageCell

        cell.EntireSelectedImage.numberOfPages = 3
        cell.EntireSelectedImage.currentPage = indexPath.row
        cell.frame = productImageCollection.bounds
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
 
        return CGSize(width: productImageCollection.bounds.width, height: productImageCollection.bounds.height)
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

}


