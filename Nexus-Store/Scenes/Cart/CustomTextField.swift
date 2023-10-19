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
            setupLeftView()
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set { layer.cornerRadius = newValue }
        get { return layer.cornerRadius }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTextField()
    }
    
    private func setupTextField() {
        cornerRadius = 16
        self.backgroundColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00)
        
        setupLeftView()
    }
    
    private func setupLeftView() {
        self.leftViewMode = .always
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        
        let imageView = UIImageView(image: self.image)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = view.bounds
        view.addSubview(imageView)
        
        
        self.leftView = view
    }
}
