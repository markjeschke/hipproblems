////
////  Hotel.swift
////  Hotelzzz
////
////  Created by Mark Jeschke on 7/24/18.
////  Copyright © 2018 Hipmunk, Inc. All rights reserved.
////
//
//import Foundation
//
//typealias Hotels = [HotelResult]
//
//struct HotelResult {
//    let price: Double
//    let hotel: [Hotel]
//    
//    var asJSONString: String {
//        return jsonStringify([
//            "price": price
//            ])
//    }
//}
//
//struct Hotel {
//    let id: Int
//    let name: String
//    let address: String
//    let imageURL: String?
//    
//    var asJSONString: String {
//        return jsonStringify([
//            "id": id,
//            "name": name,
//            "address": address,
//            "imageURL": imageURL ?? "placeholder"
//            ])
//    }
//}
//
//private func jsonStringify(_ obj: [AnyHashable: Any]) -> String {
//    let data = try! JSONSerialization.data(withJSONObject: obj, options: [])
//    return String(data: data, encoding: .utf8)!
//}
