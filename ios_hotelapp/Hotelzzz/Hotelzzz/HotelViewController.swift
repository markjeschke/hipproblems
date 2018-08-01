//
//  HotelViewController.swift
//  Hotelzzz
//
//  Created by Steve Johnson on 3/22/17.
//  Copyright © 2017 Hipmunk, Inc. All rights reserved.
//

import Foundation
import UIKit

class HotelViewController: UIViewController {
    
    var selectedName: String?
    var selectedAddress: String?
    var selectedPrice: Int?
    var selectedImageURL: String?
    
    @IBOutlet var hotelNameLabel: UILabel!
    @IBOutlet var hotelAddressLabel: UILabel!
    @IBOutlet var hotelPriceLabel: UILabel!
    @IBOutlet var hotelImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let name = selectedName {
            hotelNameLabel.text = name
        }
        hotelNameLabel.font = .brandBoldFont(size: 20.0)
        hotelNameLabel.textColor = .secondaryBrandColor
        if let price = selectedPrice {
            hotelPriceLabel.text = "$\(price)"
        }
        hotelPriceLabel.font = .brandBoldFont(size: 25.0)
        hotelPriceLabel.textColor = .pricingColor
        
        if let address = selectedAddress {
            hotelAddressLabel.text = address
            hotelAddressLabel.setLineSpacing(lineSpacing: 1.0, lineHeightMultiple: 1.2)
        }
        hotelImageView.layer.masksToBounds = true
        
        if let imageURL = selectedImageURL {
            let replacedDimensionsURL = imageURL.replacingOccurrences(of: "100", with: "600")
            hotelImageView.loadImageUsingUrlString(url: URL(string: replacedDimensionsURL))
        }
        
    }
    
}
