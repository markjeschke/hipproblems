//
//  SortTableViewController.swift
//  Hotelzzz
//
//  Created by Mark Jeschke on 7/26/18.
//  Copyright © 2018 Hipmunk, Inc. All rights reserved.
//

import UIKit

class SortTableViewController: UITableViewController {
    
    var currentRowSelection = -1
    
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
        
        title = "Sort Hotels by:"
        
        tableView.tableFooterView = UIView(frame: .zero)

        let navButtonAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor.primaryBrandColor,
            NSAttributedStringKey.font : UIFont.brandRegularFont(size: 15.0)
        ]
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissModalView))
        cancelButton.setTitleTextAttributes(navButtonAttributes, for: .normal)
        cancelButton.setTitleTextAttributes(navButtonAttributes, for: .selected)
        cancelButton.accessibilityLabel = "Cancel"
        cancelButton.accessibilityIdentifier = "cancelButton"
        navigationItem.leftBarButtonItem = cancelButton
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveSortOrder))
        saveButton.setTitleTextAttributes(navButtonAttributes, for: .normal)
        saveButton.setTitleTextAttributes(navButtonAttributes, for: .selected)
        saveButton.accessibilityLabel = "Save"
        saveButton.accessibilityIdentifier = "saveButton"
        navigationItem.rightBarButtonItem = saveButton
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @objc func saveSortOrder() {
        if let rowDataValue = sortOptionsDictionary[typeList[currentRowSelection]] {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationSortOrderKey),
                                            object: nil,
                                            userInfo: [
                                                "sortOrder": rowDataValue
                ])
        }
        dismissModalView()
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
        let rowDataKey = typeList[indexPath.row]
        cell.textLabel?.text = rowDataKey
        
        if (currentRowSelection == indexPath.row) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let row = indexPath.row
        let previousRowSelection = currentRowSelection
        currentRowSelection = row
        
        let oldIndexPath = IndexPath(row: previousRowSelection, section: 0)
        let newIndexPath = IndexPath(row: currentRowSelection, section: 0)
        var indexPaths = [oldIndexPath]
        if oldIndexPath.row != newIndexPath.row {
            indexPaths.append(newIndexPath)
        }
        tableView.reloadRows(at: indexPaths, with: UITableViewRowAnimation.fade)
    }

}
