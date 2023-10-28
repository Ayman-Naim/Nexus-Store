//
//  ProductColorDelegation.swift
//  Nexus-Store
//
//  Created by Mustafa on 20/10/2023.
//

import UIKit




class ProductSizeDelegation: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
   
    
    var itemDetails:Product
    var setIndexPathCollectionForSize:String?
    var quatityLabel:UILabel
    
    var availableQuatity:Int?{
        didSet{
            if let availableQuatity = availableQuatity{
                quatityLabel.text =  "\(availableQuatity) items"
            }
        }
    }
    init(itemDetails:Product , with quatityLabel:UILabel) {
      
        self.itemDetails = itemDetails
        setIndexPathCollectionForSize = itemDetails.options?.first?.values?[0]
        self.quatityLabel = quatityLabel
        
       
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemDetails.options?.first?.values?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SizeColorCell.identifier, for: indexPath) as! SizeColorCell
        
        cell.sizeColorLabel.text = itemDetails.options?.first?.values?[indexPath.row]
        indexPath.row == 0 ? cell.backGroundView.configureDesignOfcellSelected(label: cell.sizeColorLabel) :  cell.backGroundView.configureDesignOfCellNotSelected(label: cell.sizeColorLabel)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 35, height: 35)
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Specify the section you want to loop through
        setIndexPathCollectionForSize = itemDetails.options?.first?.values?[indexPath.row]
        didSelectCertainSize()
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

    
    //MARK: - Select Item size for Product
    func didSelectCertainSize() {
        
        let numberOfItemAvalabile = itemDetails.variants?.filter({ $0.option1 == setIndexPathCollectionForSize })
        if let validQuatity = numberOfItemAvalabile?.first?.inventoryQuantity{
            self.availableQuatity = validQuatity
        }
    
    }
    
    
   
}
