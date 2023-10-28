//
//  UIColor+Extension.swift
//  Nexus-Store
//
//  Created by Mustafa on 27/10/2023.
//

import UIKit


extension UIColor{
    
   static func getContrastColor(for backgroundColor: UIColor) -> UIColor {
        if backgroundColor.isLighterColor() {
            return UIColor.black
        } else {
            return UIColor.white
        }
    }

    
    static func createSystemColor(from colorName: String?) -> UIColor? {
        switch colorName {
        case "red":
            return UIColor.systemRed
        case "green":
            return UIColor.systemGreen
        case "blue":
            return UIColor.systemBlue
        case "orange":
            return UIColor.systemOrange
        case "yellow":
            return UIColor.systemYellow
        case "pink":
            return UIColor.systemPink
        case "purple":
            return UIColor.systemPurple
        case "teal":
            return UIColor.systemTeal
        case "indigo":
            return UIColor.systemIndigo
        case "gray":
            return UIColor.systemGray
        case "gray2":
            return UIColor.systemGray2
        case "gray3":
            return UIColor.systemGray3
        case "gray4":
            return UIColor.systemGray4
        case "gray5":
            return UIColor.systemGray5
        case "gray6":
            return UIColor.systemGray6
        case "label":
            return UIColor.label
        case "white":
            return UIColor.white
        case "black":
            return UIColor.black
        case "beige":
            return UIColor.gray
        case "light_brown":
            return UIColor.brown
            

       
        default:
            return nil
        }
    }

    
    func isLighterColor() -> Bool {
        guard let components = self.cgColor.components else { return true }
        let brightness = ((components[0] * 299) + (components[1] * 587))  / 886
        return brightness > 0.7
    }
    

    
}


    
