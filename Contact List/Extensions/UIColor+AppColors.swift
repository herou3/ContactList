//
//  UIColor+AppColors.swift
//  Contact List

import UIKit

// MARK: - Common
extension UIColor {
    static func color(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    // MARK: - AppColors
    class var darkslategray: UIColor {
        return color(47, 79, 79)
    }
    
    class var slategray: UIColor {
        return color(112, 128, 144)
    }
    
    class var averageRaiting: UIColor {
        return color(124, 252, 0)
    }
    
    class var lightslategray: UIColor {
        return color(119, 136, 153)
    }
    
    class var dimgray: UIColor {
        return color(105, 105, 105)
    }
    
    class var appPrimary: UIColor {
        return color(169, 169, 169)
    }
    
    class var silver: UIColor {
        return color(192, 192, 192)
    }
    
    class var gainsboro: UIColor {
        return color(220, 220, 220)
    }
}
