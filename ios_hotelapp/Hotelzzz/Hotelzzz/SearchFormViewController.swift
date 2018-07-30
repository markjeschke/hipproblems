//
//  ViewController.swift
//  Hotelzzz
//
//  Created by Steve Johnson on 3/21/17.
//  Copyright © 2017 Hipmunk, Inc. All rights reserved.
//

import UIKit

private enum DateType {
    case checkIn
    case checkOut
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()

class SearchFormViewController: UIViewController, DatePickerViewControllerDelegate {
    @IBOutlet var openDateStartPickerButton: UIButton!
    @IBOutlet var openDateEndPickerButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    
    var searchController = UISearchController(searchResultsController: nil)
    var searchBarLocationText = "San Francisco"
    var checkInDate: Date = Date() { didSet { _updateCheckIn() } }
    var checkOutDate: Date = Date()  { didSet { _updateCheckOut() } }
    fileprivate var _pickingDateType: DateType? = nil

    private func _updateCheckIn() {
        openDateStartPickerButton.setTitle(dateFormatter.string(from: checkInDate), for: .normal)
    }

    private func _updateCheckOut() {
        openDateEndPickerButton.setTitle(dateFormatter.string(from: checkOutDate), for: .normal)
    }
    
    private func formatSearchController() {
        searchController.dimsBackgroundDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.keyboardAppearance = .dark
        searchController.searchBar.barTintColor = .white
        searchController.searchBar.isTranslucent = true
        searchController.searchBar.returnKeyType = .done
        searchController.searchBar.autocapitalizationType = .words
        definesPresentationContext = true
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Hotelzzz"
        
        _updateCheckIn()
        _updateCheckOut()
        dateFormatter.timeStyle = .none
        formatSearchController()
        
//        searchButton.titleLabel?.font = .brandSemiBoldFont(size: 18.0)
//        searchButton.setTitleColor(.primaryBrandColor, for: .normal)
//        searchButton.titleLabel?.textColor = .primaryBrandColor
//        searchButton.layer.cornerRadius = searchButton.bounds.size.height/2
//        searchButton.layer.borderColor = UIColor.primaryBrandColor.cgColor
//        searchButton.layer.borderWidth = 1
//        searchButton.layer.masksToBounds = true
        
        searchButton.primaryCTA(size: 20)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .always
            navigationController?.navigationBar.prefersLargeTitles = true
            searchController.hidesNavigationBarDuringPresentation = false
        }
        searchController.searchBar.placeholder = searchBarLocationText.isEmpty ? "Search City" : searchBarLocationText
        UIView.animate(withDuration: 0.4) { [unowned self] in
            self.view.layoutIfNeeded()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case .some("pick_check_in_date"):
            _pickingDateType = .checkIn
            _handleDatePickerSegue(destination: segue.destination,
                                   date: self.checkInDate,
                                   title: NSLocalizedString("Check in", comment: ""))
        case .some("pick_check_out_date"):
            _pickingDateType = .checkOut
            _handleDatePickerSegue(destination: segue.destination,
                                   date: self.checkOutDate,
                                   title: NSLocalizedString("Check out", comment: ""))
        case .some("search"):
            guard let searchVC = segue.destination as? SearchViewController else {
                fatalError("Segue destination has unexpected type")
            }
            searchVC.search(location: self.searchBarLocationText , dateStart: self.checkInDate, dateEnd: self.checkOutDate)
        default:
            fatalError("Can't handle this segue")
        }
    }

    private func _handleDatePickerSegue(destination: UIViewController, date: Date, title: String) {
        guard let navVC = destination as? UINavigationController,
            let datePickerVC = navVC.topViewController as? DatePickerViewController else {
            fatalError("Segue destination has unexpected type")
        }
        datePickerVC.navigationItem.title = title
        datePickerVC.initialDate = date
        datePickerVC.delegate = self
    }

    func datePicker(viewController: DatePickerViewController, didSelectDate date: Date) {
        switch _pickingDateType {
        case .some(.checkIn): self.checkInDate = date
        case .some(.checkOut): self.checkOutDate = date
        default: return;
        }
    }
}

extension SearchFormViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        guard let firstSubview = searchBar.subviews.first else { return }
        firstSubview.subviews.forEach {
            ($0 as? UITextField)?.clearButtonMode = .whileEditing
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchController.searchBar.text else { return }
        if searchText != "" {
            searchBarLocationText = searchText
        }
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
}
