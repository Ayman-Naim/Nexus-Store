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
    private let defaultImage = "https://drive.google.com/file/d/1RQkHsMruKLh_sAL4CROkRiThHkRkAPN9/view?usp=sharing.jpg"
    static func Nib()->UINib{return UINib(nibName: "productDetailsCell", bundle: nil)}
    static let identfier = "productDetailsCell"
    
    static let iconShapeNotFavorite = "heart"
    static let iconShapeFavorite = "heart.fill"
    
    @IBOutlet weak var avalibleInStock: UILabel!
    @IBOutlet weak var favoriteIcon: UIButton!
    @IBOutlet weak var rating: CosmosView!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    var productId:Int?
    var delegate:CustomNibCellProtocol?
    override func awakeFromNib() {
        super.awakeFromNib()
        favoriteIcon.isHidden = true
       
      
       
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addingShadowWithEffectToCell()
        
        
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        favoriteIcon.setImage(UIImage(systemName: productDetailsCell.iconShapeNotFavorite,withConfiguration: UIImage.SymbolConfiguration(scale: .medium)), for: .normal)

    }
    
    @IBAction func pressFavoriteButton(_ sender: Any) {
        delegate?.didTapButtonInCell(self)
        
    }
    func ConfigureProductDetails(product:Product?,inStock:Int?){
        
        if let imageUrl = product?.image?.src {
            productImage.kf.setImage(with: URL(string: imageUrl))
        }else{
            productImage.image = UIImage(named: "PlaceHolderImage")
        }
        productName.text = product?.title
        productPrice.text = "$\(product?.variants?.first?.price ?? "300")"
        productId = product?.id
        if let quatity =  inStock{
            avalibleInStock.text = "\(quatity) in Stock"
        }

    }
    
    
    func setFavorite(){

        favoriteIcon.setImage(UIImage(systemName: productDetailsCell.iconShapeFavorite,withConfiguration: UIImage.SymbolConfiguration(scale: .medium)), for: .normal)
       
    }
    
    

   
}

extension UICollectionViewCell{
    func addingShadowWithEffectToCell(){
        layer.cornerRadius = 16
        layer.shadowRadius = 5.0
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 3.3, height: 5.7)
        layer.shadowOpacity = 0.7
        layer.masksToBounds = false
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        backgroundColor = .clear
      //  contentView.backgroundColor = .white

    }
}
