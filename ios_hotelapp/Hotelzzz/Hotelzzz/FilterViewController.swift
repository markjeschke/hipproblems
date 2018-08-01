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
    
    var minValue = 0
    var maxValue = 0
    
    var priceMin: Int? {
        didSet {
            if let priceMin = priceMin {
                minValue = priceMin
            }
        }
    }
    
    var priceMax: Int? {
        didSet {
            if let priceMax = priceMax {
                maxValue = priceMax
            }
        }
    }
    
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
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissModalView))
        navigationItem.leftBarButtonItem = cancelButton
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveData))
        saveButton.setTitleTextAttributes(ctaButtonAttributes, for: .normal)
        saveButton.setTitleTextAttributes(ctaButtonAttributes, for: .highlighted)
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

        let grabDefaultsForPriceMax = userDefaults.integer(forKey: "priceMax")
        if grabDefaultsForPriceMax == -1 {
            userDefaults.set(minValue, forKey: "priceMin")
            userDefaults.set(maxValue+1, forKey: "priceMax")
        } else {
            newMaxValue = userDefaults.integer(forKey: "priceMax")
            priceFilterSlider.value = Float(newMaxValue)
            if newMaxValue > maxValue {
                currentPrice = "Any"
            } else {
                currentPrice = "$\(newMaxValue)"
            }
            pricePerNightLabel.text = "Price per night: \(currentPrice)"
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
