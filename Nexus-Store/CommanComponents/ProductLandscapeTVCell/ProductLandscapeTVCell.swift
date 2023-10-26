//
//  ProductLandscapeTVCell.swift
//  Nexus-Store
//
//  Created by Khater on 18/10/2023.
//

import UIKit

protocol ProductLandscapeCell: AnyObject {
    func setProduct(_ product: CartProduct)
    func hideButtons()
    func hideQuantity()
}

protocol ProductLandscapeCellDelegate: AnyObject {
    func didDeleteProduct(withID id: Int)
    func didUpdateProductQuantity(forProductID id: Int, with quantity: Int)
}

extension ProductLandscapeCellDelegate {
    func didDeleteProduct(withID id: Int) {}
    func didUpdateProductQuantity(forProductID id: Int, with quantity: Int) {}
}

class ProductLandscapeTVCell: UITableViewCell {
    
    // MARK: - Static Properties
    static let height: CGFloat = 160
    
    static let identifier = "ProductLandscapeTVCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "ProductLandscapeTVCell", bundle: nil)
    }
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    
    
    // MARK: - Variables
    weak var delegate: ProductLandscapeCellDelegate?
    private var productID: Int?
    
    private var quantity: Int = 1 {
        didSet { updateQuantity() }
    }
    
    // MARK: - IBActions
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        if let productID = productID {
            delegate?.didDeleteProduct(withID: productID)
        }
    }
    
    @IBAction func minusButtonPressed(_ sender: UIButton) {
        quantity -= 1
    }
    
    @IBAction func plusButtonPressed(_ sender: UIButton) {
        quantity += 1
    }
    
    // MARK: - Helpers
    private func updateQuantity() {
        if quantity <= 0 {
            quantity = 1
            return
        }
        
        quantityLabel.text = "\(quantity)"
        if let productID = productID {
            delegate?.didUpdateProductQuantity(forProductID: productID, with: quantity)
        }
    }
}


// MARK: - ProductLandscapeCell
extension ProductLandscapeTVCell: ProductLandscapeCell {
    func setProduct(_ product: CartProduct) {
        productID = product.id
        productImageView.setImage(withURLString: product.image)
        productTitleLabel.text = product.title
        priceLabel.text = "$\(product.price)"
        quantityLabel.text = "\(product.quantity)"
    }
    
    func hideButtons() {
        deleteButton.isHidden = true
        plusButton.isHidden = true
        minusButton.isHidden = true
    }
    
    func hideQuantity() {
        minusButton.superview?.isHidden = true
    }
}
