//
//  UIFont+BrandFonts.swift
//  DoorDashLite
//
//  Created by Mark Jeschke on 7/19/18.
//  Copyright © 2018 Mark Jeschke. All rights reserved.
//

import UIKit

public extension UIFont {
    @objc public static func brandRegularFont(size: CGFloat) -> UIFont {
        return montserratRegular(size: size)
    }
    
    @objc public static func brandBoldFont(size: CGFloat) -> UIFont {
        return montserratBold(size:size)
    }
    
    @objc public static func brandLightFont(size: CGFloat) -> UIFont {
        return montserratLight(size:size)
    }
    
    public static func montserratRegular(size: CGFloat) -> UIFont {
        if let font = UIFont(name: "Montserrat-Regular", size: size) {
            return font
        }
        return UIFont.brandRegularFont(size: size)
    }
    
    public static func montserratBold(size: CGFloat) -> UIFont {
        if let font = UIFont(name: "Montserrat-Bold", size: size) {
            return font
        }
        return UIFont.boldSystemFont(ofSize: size)
    }
    
    public static func montserratLight(size: CGFloat) -> UIFont {
        if let font = UIFont(name: "Montserrat-Light", size: size) {
            return font
        }
        return UIFont.systemFont(ofSize: size)
    }
}
