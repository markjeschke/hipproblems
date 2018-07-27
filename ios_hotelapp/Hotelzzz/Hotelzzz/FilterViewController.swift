//
//  FilterViewController.swift
//  Hotelzzz
//
//  Created by Mark Jeschke on 7/26/18.
//  Copyright © 2018 Hipmunk, Inc. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {
    
    let minValue = 100
    let maxValue = 501
    var newMaxValue = 0
    var currentPrice = "Any"
    

    @IBOutlet var pricePerNightLabel: UILabel!
    @IBOutlet var priceMinLabel: UILabel!
    @IBOutlet var priceMaxLabel: UILabel!
    @IBOutlet var averagePriceLabel: UILabel!
    @IBOutlet var priceFilterSlider: UISlider!
    
    @IBAction func updatePriceLabelAction(_ sender: UISlider) {
        if Int(sender.value) > (maxValue-1) {
            currentPrice = "Any"
            newMaxValue = -1
        } else {
            currentPrice = "$\(Int(sender.value))"
            newMaxValue = Int(sender.value)
        }
        pricePerNightLabel.text = "Price per night: \(currentPrice)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navButtonAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor.primaryBrandColor,
            NSAttributedStringKey.font : UIFont.brandSemiBoldFont(size: 14.0)
        ]
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissModalView))
        cancelButton.setTitleTextAttributes(navButtonAttributes, for: .normal)
        cancelButton.setTitleTextAttributes(navButtonAttributes, for: .selected)
        cancelButton.accessibilityLabel = "Cancel"
        cancelButton.accessibilityIdentifier = "cancelButton"
        navigationItem.leftBarButtonItem = cancelButton
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissModalView))
        doneButton.setTitleTextAttributes(navButtonAttributes, for: .normal)
        doneButton.setTitleTextAttributes(navButtonAttributes, for: .selected)
        doneButton.accessibilityLabel = "Done"
        doneButton.accessibilityIdentifier = "doneButton"
        navigationItem.rightBarButtonItem = doneButton
        
        priceFilterSlider.minimumValue = Float(minValue)
        priceFilterSlider.maximumValue = Float(maxValue)
        priceFilterSlider.value = Float(maxValue)
        priceFilterSlider.minimumTrackTintColor = .primaryBrandColor
        priceFilterSlider.isContinuous = true
        
        priceMinLabel.text = "$\(minValue)"
        priceMaxLabel.text = "$\(maxValue-1)"
        averagePriceLabel.text = "Avg. $\(Int(priceFilterSlider.value)/2)"
        pricePerNightLabel.text = "Price per night: \(currentPrice)"

    }
    
    func setPrice() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationPriceFilterKey),
                                        object: nil,
                                        userInfo: [
                                            "priceMin": minValue,
                                            "priceMax": newMaxValue
            ])
    }
    
    @objc func dismissModalView() {
        setPrice()
        self.dismiss(animated: true, completion: nil)
    }

}
