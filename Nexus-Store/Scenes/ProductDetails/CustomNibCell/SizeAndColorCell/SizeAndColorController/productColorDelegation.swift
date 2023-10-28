//
//  productSizeDelegation.swift
//  Nexus-Store
//
//  Created by Mustafa on 20/10/2023.
//

import UIKit
class ProductColorDelegation: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    
    
    var itemDetails:Product
    
    init(itemDetails:Product) {
      
        self.itemDetails = itemDetails
       
    }
   
    var colors:[UIColor] = [  #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1) , #colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1) , #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1) , #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1) ]
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Color \(itemDetails.options?[1].values)")
        return itemDetails.options?[1].values?.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SizeColorCell.identifier, for: indexPath) as! SizeColorCell
        cell.backGroundView.configureDesignOfCellNotSelected(label: cell.sizeColorLabel)
        cell.backGroundView.backgroundColor = UIColor.createSystemColor(from: itemDetails.options?[1].values?[indexPath.row])
        cell.sizeColorLabel.textColor = UIColor.getContrastColor(for: cell.backGroundView.backgroundColor ?? UIColor.white)
        cell.sizeColorLabel.text =  indexPath.row == 0  ?   "✓" : ""
        
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
                cell.sizeColorLabel.text = ""
                if  index.row == indexPath.row{
                    cell.sizeColorLabel.text = "✓"
                }
            }
           
        }
        
        
        
    }

    
   
}
