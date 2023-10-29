//
//  BrandProductsViewController.swift
//  Nexus-Admin
//
//  Created by Mustafa on 28/10/2023.
//

import UIKit

class BrandProductsViewController: UIViewController {
    
 
    @IBOutlet weak var brandProductCollection: UICollectionView!
    
    
    
    
    var brandProductDelegation:BrandProductProtocol?
    var pricedProduct = [Product](){
        didSet{
            if pricedProduct.count == brandProducts?.count {
                self.brandProducts = self.pricedProduct
                DispatchQueue.main.async {
                    self.brandProductCollection.reloadData()
                }
            }
        }
    }
    
    var brandProducts:[Product]?{
        didSet{
            
            navigationItem.title = brandProducts?.first?.vendor
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDelegationAndDataSource()
        configureNetwoorkCall()
        addProductButton()

        // Do any additional setup after loading the view.
        
        
    }
    
    


    
    func configureDelegationAndDataSource(){
        
        brandProductCollection.delegate = self
        brandProductCollection.dataSource = self
        brandProductCollection.register(productDetailsCell.Nib(), forCellWithReuseIdentifier: productDetailsCell.identfier)
    }
    
    
    
    func configureNetwoorkCall(){
        
        brandProductDelegation?.fetchAllProductForBrand()
        brandProductDelegation?.bindDataofBrandProduct = { [weak self] in
            self?.brandProducts = self?.brandProductDelegation?.retriveProductBrandDetails()
            if let products = self?.brandProducts {
                for product in products {
                    self?.brandProductDelegation?.bindPriceOfProdunctId(productId: product)
                    self?.brandProductDelegation?.bindDataofBrandProductDetails = { [weak self] in
                        self?.pricedProduct.append((self?.brandProductDelegation?.retriveProductDetails())!)
                    }
                }
               
            }
            
           
        }
    }
   

}

//MARK: - Set Delegation and DataSource

extension BrandProductsViewController:UICollectionViewDelegate,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return brandProducts?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: productDetailsCell.identfier, for: indexPath) as! productDetailsCell
        cell.ConfigureProductDetails(product: brandProducts?[indexPath.row],inStock: brandProductDelegation?.bindAvalibleQuatitiyOfProduct(singleProduct: brandProducts?[indexPath.row]))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 270)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 25, bottom: 10, right: 25)
    }
    
}

//MARK: - Adding Function Nedded To Brand Controller
extension BrandProductsViewController {
    
    //MARK: - Addinf Right Button Navigation
    func addProductButton(){
        
        let addProduct = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addProductToBrand))
        
        navigationItem.rightBarButtonItem = addProduct
        
    }
    
    @objc func addProductToBrand(){
        
    }
    
}




