//
//  BrandProductsViewController.swift
//  Nexus-Admin
//
//  Created by Mustafa on 28/10/2023.
//

import UIKit

class BrandProductsViewController: UIViewController {
    
 
    @IBOutlet weak var brandProductCollection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDelegationAndDataSource()

        // Do any additional setup after loading the view.
    }


    
    func configureDelegationAndDataSource(){
        
        brandProductCollection.delegate = self
        brandProductCollection.dataSource = self
        brandProductCollection.register(productDetailsCell.Nib(), forCellWithReuseIdentifier: productDetailsCell.identfier)
    }
   

}

//MARK: - Set Delegation and DataSource

extension BrandProductsViewController:UICollectionViewDelegate,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: productDetailsCell.identfier, for: indexPath) as! productDetailsCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 270)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 25, bottom: 10, right: 25)
    }
    
}




