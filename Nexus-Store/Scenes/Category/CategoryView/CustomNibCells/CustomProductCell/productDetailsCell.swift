//
//  productDetailsCell.swift
//  Nexus-Store
//
//  Created by Mustafa on 19/10/2023.
//

import UIKit
import Cosmos
protocol CustomNibCellProtocol:AnyObject{
    func didTapButtonInCell(_ cell: productDetailsCell)
    
}
class productDetailsCell: UICollectionViewCell {
    
    @IBOutlet weak var rating: CosmosView!
    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak var productName: UILabel!
    
    @IBOutlet weak var productPrice: UILabel!
    var delegate:CustomNibCellProtocol?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addingShadowWithEffectToCell()
        
    }
    
    @IBAction func pressFavoriteButton(_ sender: Any) {
        delegate?.didTapButtonInCell(self)
        
    }
    
    

}
