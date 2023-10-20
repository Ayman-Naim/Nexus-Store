//
//  CustomFooterSepertator.swift
//  Nexus-Store
//
//  Created by Mustafa on 19/10/2023.
//

import UIKit

class CustomFooterSepertator: UICollectionReusableView {
    @IBOutlet weak var FooterLineSeperator: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        FooterLineSeperator.layer.backgroundColor = UIColor(red: 0.904, green: 0.9, blue: 0.9, alpha: 1).cgColor

    }
    
}
