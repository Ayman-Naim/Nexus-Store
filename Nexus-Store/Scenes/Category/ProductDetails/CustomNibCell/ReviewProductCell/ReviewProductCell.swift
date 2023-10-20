//
//  ReviewProductCell.swift
//  Nexus-Store
//
//  Created by Mustafa on 19/10/2023.
//

import UIKit
import Cosmos

class ReviewProductCell: UICollectionViewCell {

    
    
    static let identifier = "ReviewProductCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "ReviewProductCell", bundle: nil)
    }
    
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var reviewerImage: UIImageView!
    
    @IBOutlet weak var reviewName: UILabel!
    
    @IBOutlet weak var rating: CosmosView!
    
    @IBOutlet weak var reviewerDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cosmaticsForReViewCell()
    }

}

//MARK: - Adding Cosmatics for Review Cell
extension ReviewProductCell {
    
    //Adding Shadow in Layer to the view of reviews cell
    func cosmaticsForReViewCell(){
        var shadows = UIView()
        shadows.frame = backGroundView.frame
        shadows.clipsToBounds = false
        backGroundView.addSubview(shadows)
        let shadowPath0 = UIBezierPath(roundedRect: shadows.bounds, cornerRadius: 8)
        let layer0 = CALayer()
        layer0.shadowPath = shadowPath0.cgPath
        layer0.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05).cgColor
        layer0.shadowOpacity = 1
        layer0.shadowRadius = 25
        layer0.shadowOffset = CGSize(width: 0, height: 1)
        layer0.bounds = shadows.bounds
        layer0.position = shadows.center
        shadows.layer.addSublayer(layer0)
    }
    
    
    
}
