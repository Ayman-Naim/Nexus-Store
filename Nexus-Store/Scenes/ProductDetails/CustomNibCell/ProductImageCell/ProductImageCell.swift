//
//  ProductImageCell.swift
//  Nexus-Store
//
//  Created by Mustafa on 19/10/2023.
//

import UIKit

class ProductImageCell: UICollectionViewCell {

    static let identifier = "ProductImageCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "ProductImageCell", bundle: nil)
    }
    
    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak var EntireSelectedImage: UIPageControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        productImage.gradientImagetoBottom()
        // Initialization code
    }

}

////MARK: - Edit UI UIImageView
//extension UIImageView {
//
//    func gradientImagetoBottom(){
//        let gradient1 = CAGradientLayer()
//        gradient1.startPoint = CGPoint(x: 0, y: 0)
//        gradient1.endPoint = CGPoint(x: 0, y: 1)
//        let whiteColor = UIColor.red
//        gradient1.colors = [whiteColor.withAlphaComponent(1.0).cgColor, whiteColor.withAlphaComponent(1.0).cgColor, whiteColor.withAlphaComponent(0).cgColor]
//        gradient1.locations = [NSNumber(value: 0), NSNumber(value: 0.5), NSNumber(value: 1)]
//        gradient1.frame = self.frame
//        self.layer.mask = gradient1
//
//    }
//
//}



//MARK: - Edit UI UIImageView
extension UIImageView {
    
    func gradientImagetoBottom(){
        let gradient1 = CAGradientLayer()
        gradient1.startPoint = CGPoint(x: 0.0, y: 0)
        gradient1.endPoint = CGPoint(x: 0.0, y: 1)
        let whiteColor = UIColor.white
        gradient1.colors = [whiteColor.withAlphaComponent(1.0).cgColor, whiteColor.withAlphaComponent(1.0).cgColor, whiteColor.withAlphaComponent(0.02).cgColor]
        gradient1.locations = [NSNumber(value: 0.0), NSNumber(value: 0.8), NSNumber(value: 1)]
        gradient1.frame = self.bounds
        self.layer.mask = gradient1
        
    }
    
}
