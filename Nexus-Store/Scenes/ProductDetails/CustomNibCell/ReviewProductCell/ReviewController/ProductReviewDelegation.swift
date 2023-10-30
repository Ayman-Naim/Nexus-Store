//
//  ProductReviewDelegation.swift
//  Nexus-Store
//
//  Created by Mustafa on 20/10/2023.
//

import UIKit
class ProductReviewDelegation: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    var reviews:[Review]?
    
    
     init(numberOfReviews:Int){
         reviews = [Review]()
        for _ in 0 ... numberOfReviews{
            reviews?.append(AllReview.goodReview[AllReview.goodReview.count.randomValue])
            reviews?.append(AllReview.badReview[AllReview.badReview.count.randomValue])
            reviews?.shuffle()
        }
    }
  
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviews?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewProductCell.identifier, for: indexPath) as! ReviewProductCell
        if let review = reviews?[indexPath.row]{
            cell.ConfigureReviewForProduct(review: review)
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 300, height: 150)
    }

    
    
}
