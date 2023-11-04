//
//  PromoCodeTableViewCell.swift
//  Nexus-Admin
//
//  Created by Khater on 03/11/2023.
//

import UIKit


protocol PromoCodeCell: AnyObject {
    func setTitle(_ title: String)
    func setPromoCode(_ text: String)
    func setDiscount(_ text: String)
    func setStartDate(_ text: String)
    func setEndDate(_ text: String)
    func setUsageCount(_ text: String)
}


class PromoCodeTableViewCell: UITableViewCell {
    
    static let idenifier = "PromoCodeTableViewCell"
    static func nib() -> UINib { UINib(nibName: "PromoCodeTableViewCell", bundle: nil) }
    
    // MARK: - IBOutlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var promoCodeLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var usageLabe: UILabel!
    
}



// MARK: - PromoCodeCell
extension PromoCodeTableViewCell: PromoCodeCell {
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    func setPromoCode(_ text: String) {
        promoCodeLabel.text = text
    }
    
    func setDiscount(_ text: String) {
        discountLabel.text = text
    }
    
    func setStartDate(_ text: String) {
        startDateLabel.text = text
    }
    
    func setEndDate(_ text: String) {
        endDateLabel.text = text
    }
    
    func setUsageCount(_ text: String) {
        usageLabe.text = text
    }
    
    
}
