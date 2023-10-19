//
//  MainCategoryCell.swift
//  Nexus-Store
//
//  Created by Mustafa on 19/10/2023.
//

import UIKit

class MainCategoryCell: UICollectionViewCell {
    @IBOutlet weak var backgoundMainCategoryView: UIView!
    
    @IBOutlet weak var mainCategoryLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mainCategoryLabel.translatesAutoresizingMaskIntoConstraints = false

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       // self.addingShadowWithEffect()
    }
    
    //MARK: - Setup Design of Category Cell Not Selected
    func configureDesignOfcellSelected(){
        mainCategoryLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        
        backgoundMainCategoryView.layer.backgroundColor = UIColor(red: 0.062, green: 0.062, blue: 0.062, alpha: 1).cgColor

    }
    //MARK: - Setup Design of Category Cell Not Selected
    func configureDesignOfCellNotSelected(){
        
        
        mainCategoryLabel.textColor = UIColor(red: 0.58, green: 0.58, blue: 0.58, alpha: 1)
        backgoundMainCategoryView.layer.borderWidth = 2
        backgoundMainCategoryView.layer.borderColor = UIColor(red: 0.58, green: 0.58, blue: 0.58, alpha: 1).cgColor
        backgoundMainCategoryView.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor

        
        

    }

}

extension UICollectionViewCell{
    
    func addingShadowWithEffect(){
        layer.cornerRadius = 16
        layer.shadowRadius = 5.0
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 3.3, height: 5.7)
        layer.shadowOpacity = 0.7
        layer.masksToBounds = false
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        backgroundColor = .clear
    }
}
