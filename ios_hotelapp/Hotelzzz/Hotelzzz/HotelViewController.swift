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
            title = hotelName
        }
    }
    
    var hotelIdText: String = ""
    
    var hotelId: Int = 0 {
        didSet {
            print("hotelId: \(hotelId)")
            hotelIdText = String(hotelId)
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
            hotelPriceText = String(hotelPrice)
        }
    }
    
    @IBOutlet var hotelNameLabel: UILabel!
    @IBOutlet var hotelAddressLabel: UILabel!
    @IBOutlet var hotelIdLabel: UILabel!
    @IBOutlet var hotelPriceLabel: UILabel!
    @IBOutlet var hotelImageView: UIImageView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hotelNameLabel.text = hotelName
        hotelPriceLabel.text = hotelPriceText
        hotelIdLabel.text = hotelIdText
        hotelAddressLabel.text = hotelAddress
        let replacedDimensionsURL = hotelImageURL.replacingOccurrences(of: "100", with: "600")
        hotelImageView.loadImageUsingUrlString(url: URL(string: replacedDimensionsURL))
    }
}
