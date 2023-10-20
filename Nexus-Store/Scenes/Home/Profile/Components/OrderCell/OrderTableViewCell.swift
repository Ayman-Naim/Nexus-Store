//
//  OrderTableViewCell.swift
//  Nexus-Store
//
//  Created by ayman on 19/10/2023.
//

import UIKit

class OrderTableViewCell: UITableViewCell {
    @IBOutlet weak var orderNo: UILabel!
    
    @IBOutlet weak var orderView: UIView!
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var quantity: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
       config()
        // Configure the view for the selected state
    }
    
    func config(){
        self.orderView.layer.cornerRadius = 10
        self.contentView.layer.cornerRadius = 10
        //shadow
        self.contentView.layer.borderWidth = 0.0
        self.contentView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 50).cgColor//UIColor.black.cgColor
        self.contentView.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.contentView.layer.shadowRadius = 4.0
        self.contentView.layer.shadowOpacity = 1
        self.contentView.layer.masksToBounds = false //<-
        
    }
    //for cell space in between
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
}
