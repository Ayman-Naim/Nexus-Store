//
//  SizeColorCell.swift
//  Nexus-Store
//
//  Created by Mustafa on 19/10/2023.
//

import UIKit

class SizeColorCell: UICollectionViewCell {

    
    static let identifier = "SizeColorCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "SizeColorCell", bundle: nil)
    }
    
    @IBOutlet weak var sizeColorLabel: UILabel!
    @IBOutlet weak var backGroundView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    //Animation
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        self.addingShadowWithEffect()
//
//    }

}
