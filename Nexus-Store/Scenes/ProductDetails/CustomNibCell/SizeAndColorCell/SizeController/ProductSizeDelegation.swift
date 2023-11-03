//
//  ProductColorDelegation.swift
//  Nexus-Store
//
//  Created by Mustafa on 20/10/2023.
//

import UIKit




class ProductSizeDelegation: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
   
    
   
    let productViewModel:ProductDetailsViewModel
    
    init(viewModel:ProductDetailsViewModel) {
        self.productViewModel = viewModel
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productViewModel.productItemDetails?.options?.first?.values?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SizeColorCell.identifier, for: indexPath) as! SizeColorCell
        
        cell.sizeColorLabel.text = productViewModel.productItemDetails?.options?.first?.values?[indexPath.row]

        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 35, height: 35)
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Specify the section you want to loop through
        productViewModel.numberOfItemsUpdates = 0
        ProductDetailsViewModel.indexOfSize  = productViewModel.productItemDetails?.options?.first?.values?[indexPath.row]
        didSelectCertainSize()

    }

    
    //MARK: - Select Item size for Product
    func didSelectCertainSize() {
      
        let numberOfItemAvalabile = productViewModel.productItemDetails?.variants?.filter({ $0.option1 == ProductDetailsViewModel.indexOfSize &&  $0.option2 == ProductDetailsViewModel.indexOfColor })
        
        productViewModel.variaintID = numberOfItemAvalabile?.first?.id
        if let validQuatity = numberOfItemAvalabile?.first?.inventoryQuantity{
            self.productViewModel.availableQuatitySizeAndColor = validQuatity
            productViewModel.updateQuatitySelect!()
        }
        
        
    
    }
    
    
   
}
