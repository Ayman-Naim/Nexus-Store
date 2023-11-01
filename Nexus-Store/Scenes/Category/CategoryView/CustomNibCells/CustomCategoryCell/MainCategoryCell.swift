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
        backgoundMainCategoryView.configureDesignOfCellNotSelected(label:mainCategoryLabel)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override var isSelected: Bool {
        didSet{
            if isSelected {
                backgoundMainCategoryView.configureDesignOfcellSelected(label: mainCategoryLabel)
            }
        }
    }
    
    func ConfigureLabelOfCell(label:String){
        
        self.mainCategoryLabel.text = label
    }

    

}


//MARK: - Customize the View And Adding Cosmatics with shadow to Cell


extension UIView {
    
    //MARK: - Setup Design of Category Cell Not Selected
    func configureDesignOfCellNotSelected(label:UILabel){
        
        label.textColor = UIColor(red: 0.58, green: 0.58, blue: 0.58, alpha: 1)
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor(red: 0.58, green: 0.58, blue: 0.58, alpha: 1).cgColor
        self.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor

    }
    
    
    //MARK: - Setup Design of Category Cell Not Selected
    func configureDesignOfcellSelected(label:UILabel ){
        label.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        self.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        self.layer.backgroundColor = UIColor(red: 0.062, green: 0.062, blue: 0.062, alpha: 1).cgColor

    }
    
}
