//
//  CircularCollectionViewCell.swift
//  Nexus-Admin
//
//  Created by Khater on 28/10/2023.
//

import UIKit

class CircularCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CircularCollectionViewCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray3
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cornerRadius = frame.width / 2
    }
    
    func setTitle(_ title: String){
        titleLabel.text = title
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray3.cgColor
    }
    
    override var isSelected: Bool {
        didSet{
            backgroundColor = isSelected ? .label : .clear
            titleLabel.textColor = isSelected ? .systemBackground : .systemGray3
        }
    }
}
