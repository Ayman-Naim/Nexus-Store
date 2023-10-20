//
//  SocialTableViewCell.swift
//  Nexus-Store
//
//  Created by Ahmed Ashraf on 19/10/2023.
//

import UIKit

class SocialTableViewCell: UITableViewCell {

    @IBOutlet weak var labelSocial: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
