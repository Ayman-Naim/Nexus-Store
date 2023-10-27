//
//  productDetailsCell.swift
//  Nexus-Store
//
//  Created by Mustafa on 19/10/2023.
//

import UIKit
import Kingfisher
import Cosmos
protocol CustomNibCellProtocol:AnyObject{
    func didTapButtonInCell(_ cell: productDetailsCell)
    
}
class productDetailsCell: UICollectionViewCell {
    
    @IBOutlet weak var favoriteIcon: UIButton!
    @IBOutlet weak var rating: CosmosView!
    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak var productName: UILabel!
    
    @IBOutlet weak var productPrice: UILabel!
    var delegate:CustomNibCellProtocol?
    override func awakeFromNib() {
        super.awakeFromNib()
        favoriteIcon.setImage(UIImage(systemName: K.favoriteIconNotSave,withConfiguration: UIImage.SymbolConfiguration(scale: .medium)), for: .normal)
      
       
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addingShadowWithEffectToCell()
        
        
    }
    
    @IBAction func pressFavoriteButton(_ sender: Any) {
        delegate?.didTapButtonInCell(self)
        
    }
    func ConfigureProductDetails(product:Product?){
        if let image = URL(string: (product?.image?.src)!){
            productImage.kf.setImage(with:image )
        }
        productName.text = product?.title
        productPrice.text = "$\(product?.variants?.first?.price ?? "300")"

    }
    
    

   
}
