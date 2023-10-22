//
//  PaymentTableViewCell.swift
//  Nexus-Store
//
//  Created by ayman on 20/10/2023.
//

import UIKit

class PaymentTableViewCell: UITableViewCell {

    @IBOutlet weak var checkedBox: UIImageView!
    @IBOutlet weak var PayMethodName: UILabel!
    @IBOutlet weak var PaymMethodLogo: UIImageView!
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
        self.layer.cornerRadius = 15
        self.contentView.layer.cornerRadius = 15
       
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
}
