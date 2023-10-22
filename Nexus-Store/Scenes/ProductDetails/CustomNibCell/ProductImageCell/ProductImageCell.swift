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
        // Initialization code
    }

}
