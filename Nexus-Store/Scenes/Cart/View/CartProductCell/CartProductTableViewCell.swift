//
//  CartProductTableViewCell.swift
//  Nexus-Store
//
//  Created by Khater on 18/10/2023.
//

import UIKit

protocol CartProductCell: AnyObject {
    func addProduct(_ product: CartProduct)
    func showAsOrder()
}

protocol CartProductCellDelegate: AnyObject {
    func deleteProduct(withID id: Int)
    func didUpdateQuantity(forProductID id: Int, with quantity: Int)
}

class CartProductTableViewCell: UITableViewCell {
    
    static let height: CGFloat = 160
    
    static let identifier = "CartProductTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "CartProductTableViewCell", bundle: nil)
    }
    
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    
    
    private var productID: Int?
    
    private var quantity: Int = 1 {
        didSet {
            if quantity == 0 {
                quantity = oldValue
            }
            quantityLabel.text = "\(quantity)"
            if let productID = productID {
                delegate?.didUpdateQuantity(forProductID: productID, with: quantity)
            }
        }
    }
    
    
    weak var delegate: CartProductCellDelegate?
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        if let productID = productID {
            delegate?.deleteProduct(withID: productID)
        }
    }
    
    @IBAction func minusButtonPressed(_ sender: UIButton) {
        quantity -= 1
    }
    
    @IBAction func plusButtonPressed(_ sender: UIButton) {
        quantity += 1
    }
}


// MARK: - CartProductCell
extension CartProductTableViewCell: CartProductCell {
    func addProduct(_ product: CartProduct) {
        productID = product.id
        productImageView.setImage(withURLString: product.image)
        productTitleLabel.text = product.title
        priceLabel.text = "$\(product.price)"
        quantityLabel.text = "\(product.quantity)"
    }
    
    func showAsOrder() {
        deleteButton.isHidden = true
        plusButton.isHidden = true
        minusButton.isHidden = true
    }
}
