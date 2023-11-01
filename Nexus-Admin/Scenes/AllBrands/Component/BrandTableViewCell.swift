//
//  BrandTableViewCell.swift
//  Nexus-Admin
//
//  Created by ayman on 01/11/2023.
//

import UIKit

class BrandTableViewCell: UITableViewCell {

    @IBOutlet weak var brandName: UILabel!
    @IBOutlet weak var brandImage: UIImageView!
    static  let identifier = "BrandCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
       config()
        
    }
    func config(){
        self.layer.cornerRadius = 10
        self.contentView.layer.cornerRadius = 10
        self.brandImage.layer.cornerRadius = 10
       
        //shadow
        self.contentView.layer.borderWidth = 0.0
        self.contentView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 50).cgColor//UIColor.black.cgColor
        self.contentView.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.contentView.layer.shadowRadius = 4.0
       // self.contentView.layer.shadowOpacity = 1
        self.contentView.layer.masksToBounds = false //<-
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
    
}
