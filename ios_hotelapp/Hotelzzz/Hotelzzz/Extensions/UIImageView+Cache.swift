//
//  UIImageView+Cache.swift
//  Hotelzzz
//
//  Created by Mark Jeschke on 7/26/18.
//  Copyright © 2018 Hipmunk, Inc. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<AnyObject, UIImage>()

extension UIImageView {
    func loadImageUsingUrlString(url: URL?) {
        image = nil
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) {
            self.image = imageFromCache
            return
        }
        guard let url = url else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                assert(false, error as! String)
                return
            }
            guard let data = data else { return }
            DispatchQueue.main.async { [weak self] in
                guard let imageToCache = UIImage(data: data) else { return }
                imageCache.setObject(imageToCache, forKey: url as AnyObject)
                self?.image = imageToCache
                self?.alpha = 0
                UIView.animate(withDuration: 0.5, animations: { [weak self] in
                    self?.alpha = 1.0
                })
            }
        }.resume()
    }
}
