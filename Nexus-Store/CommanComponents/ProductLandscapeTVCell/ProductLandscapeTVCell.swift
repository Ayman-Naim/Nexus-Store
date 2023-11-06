//
//  ProductLandscapeTVCell.swift
//  Nexus-Store
//
//  Created by Khater on 18/10/2023.
//

import UIKit

protocol ProductLandscapeCell: AnyObject {
    func setCell(id: Int)
    func setProduct(_ product: CartProduct)
    func hideButtons()
    func hideQuantity()
    func setImage(with imageURLString: String)
}

protocol ProductLandscapeCellDelegate: AnyObject {
    func didDeleteProduct(withID id: Int)
    func didUpdateProductQuantity(forCellID id: Int, with quantity: Int)
}

extension ProductLandscapeCellDelegate {
    func didDeleteProduct(withID id: Int) {}
    func didUpdateProductQuantity(forCellID id: Int, with quantity: Int) {}
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
    @IBOutlet weak var sizeColorLabel: UILabel!
    
    
    // MARK: - Variables
    weak var delegate: ProductLandscapeCellDelegate?
    private var cellID: Int?
    
    private var quantity: Int = 1
    
    // MARK: - IBActions
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        if let cellID = cellID {
            delegate?.didDeleteProduct(withID: cellID)
        }
    }
    
    @IBAction func minusButtonPressed(_ sender: UIButton) {
        quantity -= 1
        if let cellID = cellID {
            delegate?.didUpdateProductQuantity(forCellID: cellID, with: quantity)
        }
    }
    
    @IBAction func plusButtonPressed(_ sender: UIButton) {
        quantity += 1
        if let cellID = cellID {
            delegate?.didUpdateProductQuantity(forCellID: cellID, with: quantity)
        }
    }
    
    // MARK: - Helpers
//    private func updateQuantity() {
//        if quantity == 0 {
//            if let cellID = cellID {
//                delegate?.didUpdateProductQuantity(forCellID: cellID, with: quantity)
//            }
//            return
//        }
//
//        quantityLabel.text = "\(quantity)"
//        if let cellID = cellID {
//            delegate?.didUpdateProductQuantity(forCellID: cellID, with: quantity)
//        }
//    }
}


// MARK: - ProductLandscapeCell
extension ProductLandscapeTVCell: ProductLandscapeCell {
    func setCell(id: Int) {
        cellID = id
    }
    
    func setProduct(_ product: CartProduct) {
        productImageView.setImage(withURLString: product.image)
        productTitleLabel.text = product.title
//        priceLabel.text = "$\(product.price)"
        priceLabel.text = ConvertPrice.share.changePrice(price: String(product.price))
        quantityLabel.text = "\(product.quantity)"
        quantity = product.quantity
        
        if let sizeColor = product.sizeColor {
            sizeColorLabel.isHidden = false
            sizeColorLabel.text = product.sizeColor

        } else {
            sizeColorLabel.isHidden = true
        }
    }
    
    func hideButtons() {
        deleteButton.isHidden = true
        plusButton.isHidden = true
        minusButton.isHidden = true
    }
    
    func hideQuantity() {
        minusButton.superview?.isHidden = true
    }
    
    func setImage(with imageURLString: String) {
        productImageView.setImage(withURLString: imageURLString)
    }
}
