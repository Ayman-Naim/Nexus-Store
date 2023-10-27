//
//  UICollectionVIew+Extension.swift
//  Nexus-Store
//
//  Created by Mustafa on 20/10/2023.
//

import UIKit


extension UICollectionViewCell{
    func addingShadowWithEffectToCell(){
        layer.cornerRadius = 16
        layer.shadowRadius = 5.0
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 3.3, height: 5.7)
        layer.shadowOpacity = 0.7
        layer.masksToBounds = false
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        backgroundColor = .clear
      //  contentView.backgroundColor = .white

    }
}
