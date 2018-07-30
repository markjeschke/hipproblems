//
//  UIButton+CTAs.swift
//  Hotelzzz
//
//  Created by Mark Jeschke on 7/26/18.
//  Copyright © 2018 Hipmunk, Inc. All rights reserved.
//

import UIKit

public extension UIButton {
    
    public func primaryCTA(size: CGFloat) {
        setTitleColor(.white, for: .normal)
        layer.cornerRadius = bounds.size.height/2
        layer.backgroundColor = UIColor.primaryBrandColor.cgColor
        layer.borderColor = UIColor.primaryBrandColor.cgColor
        layer.borderWidth = 1
        layer.masksToBounds = true
        titleLabel?.font = UIFont.brandSemiBoldFont(size: size)
    }
    
    public func secondaryCTA(size: CGFloat) {
        setTitleColor(.primaryBrandColor, for: .normal)
        layer.cornerRadius = bounds.size.height/2
        layer.borderColor = UIColor.primaryBrandColor.cgColor
        layer.borderWidth = 1
        layer.masksToBounds = true
        titleLabel?.font = UIFont.brandSemiBoldFont(size: size)
    }
    
    

    @objc public class var primaryBrandColor: UIColor {
        return UIColor(red: 51/255, green: 148/255, blue: 222/255, alpha: 1)
    }
    
    @objc public class var secondaryBrandColor: UIColor {
        return UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)
    }
}
