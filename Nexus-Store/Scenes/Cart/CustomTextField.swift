//
//  CustomTextField.swift
//  Nexus-Store
//
//  Created by Khater on 19/10/2023.
//

import UIKit

@IBDesignable
class CustomTextField: UITextField {
    
    @IBInspectable var image: UIImage? {
        didSet {
            if let image = image {
                setupLeftView()
            }
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 16 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLeftView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLeftView()
    }
    
    private func setupLeftView() {
        self.leftViewMode = .always
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 18, height: self.frame.height))
        createImageView(in: leftView)
        self.leftView = leftView
    }
    
    private func createImageView(in superView: UIView) {
        superView.subviews.forEach { $0.removeFromSuperview() }
        let imageView = UIImageView(image: self.image)
        imageView.contentMode = .scaleAspectFit

        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        superView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: superView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: superView.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: superView.widthAnchor, multiplier: 0.8),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
    }
}
