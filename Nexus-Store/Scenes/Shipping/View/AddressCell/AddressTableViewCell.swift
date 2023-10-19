//
//  AddressTableViewCell.swift
//  Nexus-Store
//
//  Created by Khater on 18/10/2023.
//

import UIKit

protocol AddressCell: AnyObject {
    func address(name: String, location: String)
    func didSelecteAddress(_ isSelected: Bool)
}


class AddressTableViewCell: UITableViewCell {
    
    static let identifier = "AddressTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "AddressTableViewCell", bundle: nil)
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
}


// MARK: - AddressCell
extension AddressTableViewCell: AddressCell {
    func address(name: String, location: String) {
        nameLabel.text = name
        addressLabel.text = location
    }
    
    func didSelecteAddress(_ isSelected: Bool) {
        if isSelected {
            containerView.backgroundColor = UIColor(named: "Title")
            nameLabel.textColor = UIColor(named: "Background")
            addressLabel.textColor = UIColor(named: "Background")
        } else {
            containerView.backgroundColor = UIColor(named: "Background")
            nameLabel.textColor = UIColor(named: "Title")
            addressLabel.textColor = UIColor(named: "Title")
        }
    }
}
