//
//  UIView+Extension.swift
//  Nexus-Store
//
//  Created by Mustafa on 20/10/2023.
//

import UIKit


extension UIView{
    func addingShadowWithEffectToView(){
        let shadows = UIView()
        shadows.frame = self.frame
        shadows.clipsToBounds = false
        self.addSubview(shadows)
        let shadowPath0 = UIBezierPath(roundedRect: shadows.bounds, cornerRadius: 8)
        let layer0 = CALayer()
        layer0.shadowPath = shadowPath0.cgPath
        layer0.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05).cgColor
        layer0.shadowOpacity = 1
        layer0.shadowRadius = 25
        layer0.shadowOffset = CGSize(width: 0, height: 1)
        layer0.bounds = shadows.bounds
        layer0.position = shadows.center
        shadows.layer.addSublayer(layer0)

    }
    
    
    @IBInspectable var cornerRadius: CGFloat {
        set { layer.cornerRadius = newValue }
        get { layer.cornerRadius }
    }
    
    @IBInspectable var setShadow: Bool {
        set {
            if newValue {
                self.layer.shadowColor = UIColor.black.cgColor
                self.layer.shadowOpacity = 0.1
                self.layer.shadowOffset = .zero
                self.layer.shadowRadius = self.layer.cornerRadius
            }
        }
        
        get { false }
    }
    
    @IBInspectable var shadowOpacity: Float {
        set { layer.shadowOpacity = newValue }
        get { layer.shadowOpacity }
    }
}
