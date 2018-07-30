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
    
    var hotelName: String = "" {
        didSet {
            print("\(hotelName)")
        }
    }
    
    var hotelAddress: String = "" {
        didSet {
            print("hotelAddress: \(hotelAddress)")
        }
    }
    
    var hotelImageURL: String = "" {
        didSet {
            print("hotelPrice: \(hotelImageURL)")
        }
    }
    var hotelPriceText: String =  ""
    
    var hotelPrice: Int = 0 {
        didSet {
            hotelPriceText = String("$\(hotelPrice)")
        }
    }
    
    @IBOutlet var hotelNameLabel: UILabel!
    @IBOutlet var hotelAddressLabel: UILabel!
    @IBOutlet var hotelPriceLabel: UILabel!
    @IBOutlet var hotelImageView: UIImageView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hotelNameLabel.text = hotelName
        hotelNameLabel.font = .brandBoldFont(size: 20.0)
        hotelPriceLabel.text = hotelPriceText
        hotelPriceLabel.font = .brandBoldFont(size: 25.0)
        hotelPriceLabel.textColor = .primaryBrandColor
        hotelAddressLabel.text = hotelAddress
        hotelImageView.layer.masksToBounds = true
        let replacedDimensionsURL = hotelImageURL.replacingOccurrences(of: "100", with: "600")
        hotelImageView.loadImageUsingUrlString(url: URL(string: replacedDimensionsURL))
    }
}
