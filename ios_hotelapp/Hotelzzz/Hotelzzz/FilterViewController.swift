//
//  FilterViewController.swift
//  Hotelzzz
//
//  Created by Mark Jeschke on 7/26/18.
//  Copyright © 2018 Hipmunk, Inc. All rights reserved.
//

import Foundation
import UIKit

protocol FilterViewControllerDelegate: class {
    func filterSelector(viewController: FilterViewController, priceMin: Int, priceMax: Int)
}

class FilterViewController: UIViewController {
    weak var delegate: FilterViewControllerDelegate?
    
    var initialMinimumPrice: Int?
    var initialMaximumPrice: Int?
    
    var priceMin: Int?
    var priceMax: Int?
    
    var minValue = 100
    var maxValue = 500
    var newMaxValue = 501
    var currentPrice = "Any"
    
    let userDefaults = UserDefaults.standard

    @IBOutlet var pricePerNightLabel: UILabel!
    @IBOutlet var priceMinLabel: UILabel!
    @IBOutlet var priceMaxLabel: UILabel!
    @IBOutlet var averagePriceLabel: UILabel!
    @IBOutlet var priceFilterSlider: UISlider!
    
    @IBAction func updatePriceLabelAction(_ sender: UISlider) {
        if Int(sender.value) > maxValue {
            currentPrice = "Any"
            newMaxValue = (maxValue+1)
        } else {
            currentPrice = "$\(Int(sender.value))"
            newMaxValue = Int(sender.value)
        }
        pricePerNightLabel.text = "Price per night: \(currentPrice)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ctaButtonAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor.primaryBrandColor,
            NSAttributedStringKey.font : UIFont.brandSemiBoldFont(size: 15.0)
        ]
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissModalView))
        navigationItem.leftBarButtonItem = cancelButton
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveData))
        saveButton.setTitleTextAttributes(ctaButtonAttributes, for: .normal)
        saveButton.setTitleTextAttributes(ctaButtonAttributes, for: .selected)
        navigationItem.rightBarButtonItem = saveButton
        
        priceFilterSlider.minimumValue = Float(minValue)
        priceFilterSlider.maximumValue = Float(maxValue+1)
        priceFilterSlider.value = Float(maxValue+1)
        priceFilterSlider.minimumTrackTintColor = .primaryBrandColor
        priceFilterSlider.isContinuous = true
        
        priceMinLabel.text = "$\(minValue)"
        priceMaxLabel.text = "$\(maxValue)"
        averagePriceLabel.text = "Avg. $\(Int(priceFilterSlider.value)/2)"
        pricePerNightLabel.text = "Price per night: \(currentPrice)"

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let initialMinimumPrice = initialMinimumPrice {
            print("initialMinimumPrice: \(initialMinimumPrice)")
        }
        
        if let initialMaximumPrice = initialMaximumPrice {
            print("initialMaximumPrice: \(initialMaximumPrice)")
        }

        let grabDefaultsForPriceMax = userDefaults.integer(forKey: "priceMax")
        if grabDefaultsForPriceMax == -1 {
            userDefaults.set(minValue, forKey: "priceMin")
            userDefaults.set(maxValue+1, forKey: "priceMax")
            print("initialize priceMax = \(grabDefaultsForPriceMax)")
        } else {
            newMaxValue = userDefaults.integer(forKey: "priceMax")
            priceFilterSlider.value = Float(newMaxValue)
            if newMaxValue > maxValue {
                currentPrice = "Any"
            } else {
                currentPrice = "$\(newMaxValue)"
            }
            pricePerNightLabel.text = "Price per night: \(currentPrice)"
            print("newMaxValue = \(newMaxValue)")
        }
    }
    
    func setPrice() {
        if newMaxValue == (maxValue+1) {
            newMaxValue = -1
        }
        userDefaults.set(minValue, forKey: "priceMin")
        userDefaults.set(newMaxValue, forKey: "priceMax")
        priceMin = minValue
        priceMax = newMaxValue
        if let priceMin = priceMin, let priceMax = priceMax {
            delegate?.filterSelector(viewController: self, priceMin: priceMin, priceMax: priceMax)
            print("delegate from filter should fire")
        }
    }
    
    @objc func saveData() {
        setPrice()
        dismissModalView()
    }
    
    @objc func dismissModalView() {
        self.dismiss(animated: true, completion: nil)
    }

}
