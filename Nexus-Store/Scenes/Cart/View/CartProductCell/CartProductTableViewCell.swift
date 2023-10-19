//
//  CartProductTableViewCell.swift
//  Nexus-Store
//
//  Created by Khater on 18/10/2023.
//

import UIKit

protocol CartProductCell: AnyObject {
    func addProduct(_ product: Int)
    func updateQuantity(_ quantity: String)
}

protocol CartProductCellDelegate: AnyObject {
    func deleteProduct()
    func incrementQuantity()
    func decrementQuantity()
}

class CartProductTableViewCell: UITableViewCell {
    
    static let identifier = "CartProductTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "CartProductTableViewCell", bundle: nil)
    }
    
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    
    
    weak var delegate: CartProductCellDelegate?
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        delegate?.deleteProduct()
    }
    
    @IBAction func minusButtonPressed(_ sender: UIButton) {
        delegate?.decrementQuantity()
    }
    
    @IBAction func plusButtonPressed(_ sender: UIButton) {
        delegate?.incrementQuantity()
    }
}


// MARK: - CartProductCell
extension CartProductTableViewCell: CartProductCell {
    func addProduct(_ product: Int) {
//        productImageView.image
        productTitleLabel.text = ""
        priceLabel.text = ""
    }
    
    func updateQuantity(_ quantity: String) {
        quantityLabel.text = quantity
    }
}
