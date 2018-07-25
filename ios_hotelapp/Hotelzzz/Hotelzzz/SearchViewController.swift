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

enum SortId: String {
    case sortByName = "name"
    case priceAscend = "priceAscend"
    case priceDescend = "priceDescend"
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "YYYY-mm-dd"
    return formatter
}()

private func jsonStringify(_ obj: [AnyHashable: Any]) -> String {
    let data = try! JSONSerialization.data(withJSONObject: obj, options: [])
    return String(data: data, encoding: .utf8)!
}


class SearchViewController: UIViewController, WKScriptMessageHandler, WKNavigationDelegate, WKUIDelegate  {
    
    @IBAction func sortAction(sender: Any?) {
        selectSortId(sortBy: SortId.sortByName.rawValue)
    }

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
    
    struct Hotels {
        let hotel: Hotel
        let price: Int
    }
    
    struct Hotel {
        let id: Int
        let imageURL, name, address: String
    }
    
    private var _searchToRun: Search?
    private var _selectedHotel: Hotels?
    
    var price = 0
    var hotelDictionary = [String: AnyObject]()
    var address: String = ""
    var name: String = ""
    var imageURL: String = ""
    
    lazy var webView: WKWebView = {
        let webView = WKWebView(frame: CGRect.zero, configuration: {
            let config = WKWebViewConfiguration()
            config.userContentController = {
                let userContentController = WKUserContentController()

                // DECLARE YOUR MESSAGE HANDLERS HERE
                userContentController.add(self, name: "API_READY")
                userContentController.add(self, name: "HOTEL_API_HOTEL_SELECTED")
                userContentController.add(self, name: "HOTEL_API_RESULTS_READY")
                userContentController.add(self, name: "HOTEL_API_HOTEL_SORTED")

                return userContentController
            }()
            return config
        }())
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        self.view.addSubview(webView)
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[webView]|", options: [], metrics: nil, views: ["webView": webView]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[webView]|", options: [], metrics: nil, views: ["webView": webView]))
        return webView
    }()
    
    fileprivate func selectSortId(sortBy: String) {
        self.webView.evaluateJavaScript("window.JSAPI.setHotelSort(\"\(sortBy)\")",
            completionHandler: nil)
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
                    for (key, value) in (value as? Dictionary<String, AnyObject>)! {
                        switch key {
                        case "price":
                            price = value as! Int
                        case "hotel":
                            hotelDictionary = value as! [String: AnyObject]
                            address = hotelDictionary["address"] as! String
                            name = hotelDictionary["name"] as! String
                            imageURL = hotelDictionary["imageURL"] as! String
                        default:
                            print("default value")
                        }
                    }
                }
            }
            self.performSegue(withIdentifier: "hotel_details", sender: nil)
        case "HOTEL_API_RESULTS_READY":
             if let hotelResults = message.body as? Dictionary<String, AnyObject> {
                for (_, value) in hotelResults {
                    var resultPlural = "result"
                    if value.count != 1 {
                        resultPlural = resultPlural+"s"
                    }
                    title = "\(String(value.count)) \(resultPlural)"
                }
            }
        case "HOTEL_API_HOTEL_SORTED":
            let sortId = SortId.priceAscend
            self.webView.evaluateJavaScript(
                "window.JSAPI.setHotelSort(\(sortId))",
                completionHandler: nil)
            print("priceAscend")
        default: break
        }
    }
    
    // MARK: - Segue to HotelViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "hotel_details" {
            let controller = segue.destination as! HotelViewController
            controller.hotelName = name
            controller.hotelPrice = price
            controller.hotelAddress = address
            controller.hotelImageURL = imageURL
        }
    }
}
