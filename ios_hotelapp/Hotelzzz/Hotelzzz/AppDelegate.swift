//
//  AppDelegate.swift
//  Hotelzzz
//
//  Created by Steve Johnson on 3/21/17.
//  Copyright © 2017 Hipmunk, Inc. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        customizeAppearance()
        return true
    }
    
    private func customizeAppearance() {
        
        let navTitleAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor.secondaryBrandColor,
            NSAttributedStringKey.font : UIFont.brandSemiBoldFont(size: 18.0)
        ]
        
        let largeTitleAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor.primaryBrandColor,
            NSAttributedStringKey.font : UIFont.brandRegularFont(size: 35.0)
        ]
        
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.tintColor = .primaryBrandColor
        navBarAppearance.titleTextAttributes = navTitleAttributes
//        navBarAppearance.barTintColor = .white
//        navBarAppearance.isTranslucent = false
        if #available(iOS 11.0, *) {
            navBarAppearance.largeTitleTextAttributes = largeTitleAttributes
        }
        
        let navButtonAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor.primaryBrandColor,
            NSAttributedStringKey.font : UIFont.brandRegularFont(size: 15.0)
        ]
        
        let barButtonAppearance = UIBarButtonItem.appearance()
        barButtonAppearance.setTitleTextAttributes(navButtonAttributes, for: .normal)
        barButtonAppearance.setTitleTextAttributes(navButtonAttributes, for: .highlighted)
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.primaryBrandColor]
        
        UILabel.appearance().font = UIFont.brandRegularFont(size: 16.0)
        UILabel.appearance().backgroundColor = .clear

    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

