//
//  ColorCell.swift
//  Nexus-Store
//
//  Created by Mustafa on 02/11/2023.
//

import UIKit

class ColorCell: UICollectionViewCell {
    
    
    static let identifier = "ColorCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "ColorCell", bundle: nil)
    }

    @IBOutlet weak var backGroundColor: UIView!
    
    @IBOutlet weak var choosenColor: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        choosenColor.text = ""
    }
    
    override var isSelected: Bool {
        didSet{
            if isSelected {
                choosenColor.text = "✓"
            }else {
                choosenColor.text = ""
            }
        }
    }

}
