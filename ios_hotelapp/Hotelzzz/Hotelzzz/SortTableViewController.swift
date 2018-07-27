//
//  SortTableViewController.swift
//  Hotelzzz
//
//  Created by Mark Jeschke on 7/26/18.
//  Copyright © 2018 Hipmunk, Inc. All rights reserved.
//

import UIKit

class SortTableViewController: UITableViewController {
    
    let sortOptionsDictionary = [
        "Price – Lowest": "priceAscend",
        "Price – Highest": "priceDescend",
        "Name": "name"
    ]
    
    var typeList:[String] {
        get {
            return Array(sortOptionsDictionary.keys)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: .zero)

        let navButtonAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor.primaryBrandColor,
            NSAttributedStringKey.font : UIFont.brandBoldFont(size: 15.0)
        ]
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissModalView))
        doneButton.setTitleTextAttributes(navButtonAttributes, for: .normal)
        doneButton.setTitleTextAttributes(navButtonAttributes, for: .selected)
        doneButton.accessibilityLabel = "Done"
        doneButton.accessibilityIdentifier = "doneButton"
        navigationItem.rightBarButtonItem = doneButton
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissModalView))
        doneButton.setTitleTextAttributes(navButtonAttributes, for: .normal)
        doneButton.setTitleTextAttributes(navButtonAttributes, for: .selected)
        doneButton.accessibilityLabel = "Cancel"
        doneButton.accessibilityIdentifier = "cancelButton"
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    @objc func dismissModalView() {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortOptionsDictionary.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let row = indexPath.row
        let rowDataKey = typeList[row]
        
        cell.textLabel?.text = rowDataKey
        cell.detailTextLabel?.text = sortOptionsDictionary[rowDataKey]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        if let rowDataValue = sortOptionsDictionary[typeList[row]] {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationSortOrderKey),
                    object: nil,
                    userInfo: [
                        "sortOrder": rowDataValue
                ])
            dismissModalView()
        }
    }

}
