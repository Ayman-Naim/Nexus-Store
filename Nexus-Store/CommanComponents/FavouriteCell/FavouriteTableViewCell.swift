//
//  FavouriteTableViewCell.swift
//  Nexus-Store
//
//  Created by ayman on 19/10/2023.
//

import UIKit
import Cosmos
class FavouriteTableViewCell: UITableViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var ProductPrice: UILabel!
    @IBOutlet weak var productRate: CosmosView!
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
        self.productImage.layer.cornerRadius = 10
       
        //shadow
        self.contentView.layer.borderWidth = 0.0
        self.contentView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 50).cgColor//UIColor.black.cgColor
        self.contentView.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.contentView.layer.shadowRadius = 4.0
        self.contentView.layer.shadowOpacity = 1
        self.contentView.layer.masksToBounds = false //<-
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
}
