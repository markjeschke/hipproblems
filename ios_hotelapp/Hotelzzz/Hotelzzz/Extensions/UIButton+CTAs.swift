//
//  UIButton+CTAs.swift
//  Hotelzzz
//
//  Created by Mark Jeschke on 7/26/18.
//  Copyright © 2018 Hipmunk, Inc. All rights reserved.
//

import UIKit

let ctaButtonAttributes: [String: Any] = [
    NSAttributedStringKey.foregroundColor.rawValue: UIColor.primaryBrandColor,
    NSAttributedStringKey.font.rawValue : UIFont.brandSemiBoldFont(size: 15.0)
]

public extension UIButton {
    
    @objc public static func primaryCTA(size: CGFloat) -> UIButton {
        let button = UIButton(type: .system) as UIButton
        button.titleLabel?.font = UIFont.brandSemiBoldFont(size: size)
//        button.setAttributedTitle(ctaButtonAttributes, for: .normal)
        button.layer.cornerRadius = 20.0
        button.layer.borderColor = UIColor.primaryBrandColor.cgColor
        button.layer.borderWidth = 1.0
        return button
    }
    
    

    @objc public class var primaryBrandColor: UIColor {
        return UIColor(red: 51/255, green: 148/255, blue: 222/255, alpha: 1)
    }
    
    @objc public class var secondaryBrandColor: UIColor {
        return UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)
    }
}
