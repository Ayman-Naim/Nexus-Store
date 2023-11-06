//
//  productSizeDelegation.swift
//  Nexus-Store
//
//  Created by Mustafa on 20/10/2023.
//

import UIKit
class ProductColorDelegation: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    
    
  
    var productViewModel: ProductDetailsViewModel
    
    init(viewModel:ProductDetailsViewModel) {
      
        self.productViewModel = viewModel
    }
   
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
     //   print("Color \(itemDetails.options?[1].values)")
        return productViewModel.productItemDetails?.options?[1].values?.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.identifier, for: indexPath) as! ColorCell
        
        cell.backGroundColor.configureDesignOfCellNotSelected(label: cell.choosenColor)
        cell.backGroundColor.backgroundColor = UIColor.createSystemColor(from:  productViewModel.productItemDetails?.options?[1].values?[indexPath.row])
        cell.choosenColor.textColor = UIColor.getContrastColor(for: cell.backGroundColor.backgroundColor ?? UIColor.white)

        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 35, height: 35)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        productViewModel.numberOfItemsUpdates = 0
        ProductDetailsViewModel.indexOfColor  =  productViewModel.productItemDetails?.options?[1].values?[indexPath.row]
        didSelectCertainSize()
        
        
    }

    func didSelectCertainSize() {
        
        
        let numberOfItemAvalabile = productViewModel.productItemDetails?.variants?.filter({ $0.option1 == ProductDetailsViewModel.indexOfSize &&  $0.option2 == ProductDetailsViewModel.indexOfColor })
         
        productViewModel.variaintID = numberOfItemAvalabile?.first?.id
        
        if let varaint = numberOfItemAvalabile?.first{
            self.productViewModel.availableQuatitySizeAndColor = varaint.inventoryQuantity ?? 0
            self.productViewModel.priceOfItemIneachVariant  = varaint.price
            productViewModel.updateQuatitySelect!()
        }else{
            self.productViewModel.availableQuatitySizeAndColor = productViewModel.numberOfItemsUpdates
            self.productViewModel.priceOfItemIneachVariant = "0.0"
            productViewModel.updateQuatitySelect!()
        }

    }
   
}
