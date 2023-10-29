//
//  ProductImageCollectionViewCell.swift
//  Nexus-Admin
//
//  Created by Khater on 27/10/2023.
//

import UIKit

class ProductImageCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ProductImageCollectionViewCell"
    
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "App-logo")
        imageView.tintColor = .label
        imageView.backgroundColor = .white
        return imageView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(productImageView)
        
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: topAnchor),
            productImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            productImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            productImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setProductImage(withURLString urlString: String){
        productImageView.setImage(withURLString: urlString)
    }
}
