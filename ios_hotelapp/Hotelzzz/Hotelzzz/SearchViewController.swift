//
//  SearchViewController.swift
//  Hotelzzz
//
//  Created by Steve Johnson on 3/22/17.
//  Copyright © 2017 Hipmunk, Inc. All rights reserved.
//

import Foundation
import WebKit
import UIKit

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "YYYY-mm-dd"
    return formatter
}()

private func jsonStringify(_ obj: [AnyHashable: Any]) -> String {
    let data = try! JSONSerialization.data(withJSONObject: obj, options: [])
    return String(data: data, encoding: .utf8)!
}

class SearchViewController: UIViewController, WKScriptMessageHandler, WKNavigationDelegate, WKUIDelegate, FilterViewControllerDelegate, SortTableViewControllerDelegate  {
    var userDefaults = UserDefaults.standard
    
    struct Search {
        let location: String
        let dateStart: Date
        let dateEnd: Date

        var asJSONString: String {
            return jsonStringify([
                "location": location,
                "dateStart": dateFormatter.string(from: dateStart),
                "dateEnd": dateFormatter.string(from: dateEnd)
            ])
        }
    }

    fileprivate  var _searchToRun: Search?
    fileprivate var price = 0
    fileprivate var hotelDictionary = [String: AnyObject]()
    fileprivate var address: String = ""
    fileprivate var name: String = ""
    fileprivate var imageURL: String = ""
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var activityIndicatorVerticalLayoutConstraint: NSLayoutConstraint!
    
    lazy var webView: WKWebView = {
        let webView = WKWebView(frame: CGRect.zero, configuration: {
            let jScript = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width, initial-scale=1.0, user-scalable=no'); document.getElementsByTagName('head')[0].appendChild(meta);"
            let wkUScript = WKUserScript(source:jScript, injectionTime:.atDocumentEnd, forMainFrameOnly:true)
            let config = WKWebViewConfiguration()
            config.userContentController = {
                let userContentController = WKUserContentController()
                userContentController.addUserScript(wkUScript)
                // DECLARE YOUR MESSAGE HANDLERS HERE
                userContentController.add(self, name: "API_READY")
                userContentController.add(self, name: "HOTEL_API_HOTEL_SELECTED")
                userContentController.add(self, name: "HOTEL_API_RESULTS_READY")

                return userContentController
            }()
            return config
        }())
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        webView.alpha = 0
        self.view.addSubview(webView)
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[webView]|", options: [], metrics: nil, views: ["webView": webView]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[webView]|", options: [], metrics: nil, views: ["webView": webView]))
        return webView
    }()
    
    // View Lifecycles
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startLoadingIndicator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
    }
    
    // MARK: Prepare segues via identifiers.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case .some("hotel_details"):
            _handleHotelDetailsSegue(destination: segue.destination,
                                     name: NSLocalizedString(name, comment: ""),
                                     address: NSLocalizedString(address, comment: ""),
                                     price: price,
                                     imageURL: NSLocalizedString(imageURL, comment: ""))
        case .some("select_sort_order"):
            _handleSortOrderSegue(destination: segue.destination,
                                  currentRowSelection: 0)
        case .some("select_filters"):
            _handleFiltersSegue(destination: segue.destination,
                                priceMin: 100,
                                priceMax: 500)
        default:
            fatalError("Can't handle this segue")
        }
    }
    
    // MARK: Segue handlers from SearchViewController.
    private func _handleHotelDetailsSegue(destination: UIViewController, name: String, address: String, price: Int, imageURL: String) {
        guard let hotelVC = destination as? HotelViewController else {
                fatalError("Segue destination has unexpected type")
        }
        hotelVC.navigationItem.title = name
        hotelVC.selectedName = name
        hotelVC.selectedAddress = address
        hotelVC.selectedPrice = price
        hotelVC.selectedImageURL = imageURL
    }
    
    private func _handleSortOrderSegue(destination: UIViewController, currentRowSelection: Int) {
        guard let navVC = destination as? UINavigationController,
            let sortVC = navVC.topViewController as? SortTableViewController else {
                fatalError("Segue destination has unexpected type")
        }
        sortVC.currentRowSelection = currentRowSelection
        sortVC.delegate = self
    }
    
    private func _handleFiltersSegue(destination: UIViewController, priceMin: Int, priceMax: Int) {
        guard let navVC = destination as? UINavigationController,
            let filtersVC = navVC.topViewController as? FilterViewController else {
                fatalError("Segue destination has unexpected type")
        }
        filtersVC.priceMin = priceMin
        filtersVC.priceMax = priceMax
        filtersVC.delegate = self
    }
    
    // MARK: Delegate callbacks with values from each selection.
    func sortOrderSelector(viewController: SortTableViewController, didSelectSortOrder: String) {
        selectSortId(sortBy: didSelectSortOrder)
    }
    
    func filterSelector(viewController: FilterViewController, priceMin: Int, priceMax: Int) {
        setPrice(min: priceMin, max: priceMax)
    }
    
    func selectSortId(sortBy: String) {
        self.webView.evaluateJavaScript("window.JSAPI.setHotelSort(\"\(sortBy)\");",
            completionHandler: nil)
    }
    
    func setPrice(min: Int, max: Int) {
        var setHotelFilters = "window.JSAPI.setHotelFilters({priceMin: \(min), priceMax: \(max)});"
        if max == -1 {
            setHotelFilters = "window.JSAPI.setHotelFilters({priceMin: \(min), priceMax: null});"
        }
        self.webView.evaluateJavaScript(setHotelFilters, completionHandler: nil)
    }

    func search(location: String, dateStart: Date, dateEnd: Date) {
        _searchToRun = Search(location: location, dateStart: dateStart, dateEnd: dateEnd)
        self.webView.load(URLRequest(url: URL(string: "http://hipmunk.github.io/hipproblems/ios_hotelapp/")!))
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let alertController = UIAlertController(title: NSLocalizedString("Could not load page", comment: ""), message: NSLocalizedString("Looks like the server isn't running.", comment: ""), preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Bummer", comment: ""), style: .default, handler: nil))
        self.navigationController?.present(alertController, animated: true, completion: nil)
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("message.name: \(message.name)")
        switch message.name {
        case "API_READY":
            guard let searchToRun = _searchToRun else { fatalError("Tried to load the page without having a search to run") }
            self.webView.evaluateJavaScript(
                "window.JSAPI.runHotelSearch(\(searchToRun.asJSONString))",
                completionHandler: nil)
        case "HOTEL_API_HOTEL_SELECTED":
            if let selectedHotel = message.body as? Dictionary<String, AnyObject> {
                for (_, value) in selectedHotel {
                    for (key, value) in (value as! Dictionary<String, AnyObject>) {
                        switch key {
                        case "price":
                            price = value as! Int
                        case "hotel":
                            hotelDictionary = value as! [String: AnyObject]
                            address = hotelDictionary["address"] as! String
                            name = hotelDictionary["name"] as! String
                            imageURL = hotelDictionary["imageURL"] as! String
                        default:
                            break
                        }
                    }
                }
            }
            self.performSegue(withIdentifier: "hotel_details", sender: nil)
        case "HOTEL_API_RESULTS_READY":
            activityIndicatorVerticalLayoutConstraint.constant = view.frame.size.height
            // Fade in the webView when the results are ready for display.
             UIView.animate(withDuration: 0.5, delay: 0.3, options: .curveEaseIn, animations: {
                self.view.layoutIfNeeded()
                self.webView.alpha = 1
                self.activityIndicatorView.alpha = 0
            }) { [unowned self] (show) in
                // Stop the loading indicator.
                self.activityIndicatorView.stopAnimating()
            }
            setPrice(min: 0, max: userDefaults.integer(forKey: "priceMax"))
            let defaultSortOrderRow = userDefaults.integer(forKey: "sortOrder")
            let orderRow = Array(sortOptionsDictionary.values)[defaultSortOrderRow]
            selectSortId(sortBy: orderRow)
             if let hotelResults = message.body as? Dictionary<String, AnyObject> {
                for (_, value) in hotelResults {
                    var hotelCountPlural = "hotel"
                    if value.count != 1 {
                        hotelCountPlural = hotelCountPlural+"s"
                    }
                    title = "\(String(value.count)) \(hotelCountPlural)"
                }
            }
        default:
            break
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        insertContentsOfCSSFile(into: webView)
    }
    
    func insertContentsOfCSSFile(into webView: WKWebView) {
        guard let path = Bundle.main.path(forResource: "styles", ofType: "css") else { return }
        let cssString = try! String(contentsOfFile: path).trimmingCharacters(in: .whitespacesAndNewlines)
        let jsString = "var style = document.createElement('style'); style.innerHTML = '\(cssString)'; document.head.appendChild(style);"
        webView.evaluateJavaScript(jsString, completionHandler: nil)
    }
    
    func startLoadingIndicator() {
        activityIndicatorView.alpha = 0
        activityIndicatorView.activityIndicatorViewStyle = .whiteLarge
        activityIndicatorView.isHidden = false
        activityIndicatorView.color = UIColor.primaryBrandColor
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorVerticalLayoutConstraint.constant = 20
        activityIndicatorView.startAnimating()
        // Drop the activityIndicator with a springy bounce for playfulness.
        UIView.animate(withDuration: 0.75, delay: 0.0, usingSpringWithDamping: 0.65, initialSpringVelocity: 1.0, options: .curveEaseIn, animations: { [unowned self] in
            self.view.layoutIfNeeded()
            self.activityIndicatorView.alpha = 1
            self.activityIndicatorVerticalLayoutConstraint.constant = 0
        }) { [unowned self] (show) in
            self.view.layoutIfNeeded()
            // Repeat the loading indicator bouncing animation.
            self.activityIndicatorVerticalLayoutConstraint.constant = 15
            UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut, .repeat, .autoreverse], animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
}
