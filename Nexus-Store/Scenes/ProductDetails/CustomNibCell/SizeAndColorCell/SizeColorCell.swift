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
        backGroundView.configureDesignOfCellNotSelected(label: sizeColorLabel)

    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        backGroundView.configureDesignOfCellNotSelected(label: sizeColorLabel)

    }
    override var isSelected: Bool {
        didSet{
            if isSelected {
                backGroundView.configureDesignOfcellSelected(label: sizeColorLabel)
            }else {
                backGroundView.configureDesignOfCellNotSelected(label: sizeColorLabel)
            }
        }
    }
 
    
}
