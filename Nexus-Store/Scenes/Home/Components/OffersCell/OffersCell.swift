//
//  OffersCell.swift
//  Nexus-Store
//
//  Created by ayman on 19/10/2023.
//

import UIKit

class OffersCell: UICollectionViewCell {

    @IBOutlet weak var pageIndicator: UIPageControl!
    @IBOutlet weak var OfferImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        config()
        
    }

    
    func config(){
        self.layer.cornerRadius = 40
        self.OfferImage.layer.cornerRadius = 40
        self.contentView.layer.borderWidth = 0.0
        self.contentView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 50).cgColor//UIColor.black.cgColor
        self.contentView.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.contentView.layer.shadowRadius = 4.0
        self.contentView.layer.shadowOpacity = 1
        self.contentView.layer.masksToBounds = false //<-
    }
    
}
