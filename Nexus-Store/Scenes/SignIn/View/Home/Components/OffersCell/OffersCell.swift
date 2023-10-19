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
        // Initialization code
        self.layer.cornerRadius = 40
        self.OfferImage.layer.cornerRadius = 40 
    }

    
}
