//
//  ProductColorDelegation.swift
//  Nexus-Store
//
//  Created by Mustafa on 20/10/2023.
//

import UIKit
class ProductSizeDelegation: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    var size = ["S","M","L","XL"]
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return size.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SizeColorCell.identifier, for: indexPath) as! SizeColorCell
        
        cell.sizeColorLabel.text = size[indexPath.row]
        indexPath.row == 0 ? cell.backGroundView.configureDesignOfcellSelected(label: cell.sizeColorLabel) :  cell.backGroundView.configureDesignOfCellNotSelected(label: cell.sizeColorLabel)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 35, height: 35)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Specify the section you want to loop through
        let section = 0
        // Get the number of items in the section
        let itemCount = collectionView.numberOfItems(inSection: section)
        // Create a countable range of index paths for the section
        let indexPaths = (0..<itemCount).map { IndexPath(item: $0, section: section) }
        // Loop through the cells in the section
        for index in indexPaths {
            if let cell = collectionView.cellForItem(at: index) as? SizeColorCell {
                cell.backGroundView.configureDesignOfCellNotSelected(label: cell.sizeColorLabel)
                if  index.row == indexPath.row{
                    cell.backGroundView.configureDesignOfcellSelected(label: cell.sizeColorLabel)
                }
            }
           
        }
    }

    
    
}
