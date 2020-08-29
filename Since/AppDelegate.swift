//
//  AppDelegate.swift
//  Since
//
//  Created by Alok Karnik on 02/01/20.
//  Copyright © 2020 Alok Karnik. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        return true
    }
}
