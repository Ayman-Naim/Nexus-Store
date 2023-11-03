//
//  BrandsCollectionCell.swift
//  Nexus-Store
//
//  Created by ayman on 19/10/2023.
//

import UIKit

class BrandsCollectionCell: UICollectionViewCell {
    @IBOutlet weak var BrandName: UILabel!
    @IBOutlet weak var BrandLogo: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.BrandLogo.backgroundColor = .gray
        self.BrandLogo.layer.cornerRadius = self.BrandLogo.frame.size.width/2;
        self.BrandLogo.layer.masksToBounds = true
        self.BrandLogo.contentMode = .scaleAspectFill
       
//        self.layer.cornerRadius = self.layer.frame.size.width/2
//        self.layer.masksToBounds = true
        
    }


    
}
