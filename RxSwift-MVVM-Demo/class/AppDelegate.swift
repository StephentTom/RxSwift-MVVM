//
//  AppDelegate.swift
//  RxSwift-MVVM-Demo
//
//  Created by Mr.Hong on 2019/9/28.
//  Copyright © 2019 Mr.Hong. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        window = UIWindow(frame: UIScreen.main.bounds)
//        if #available(iOS 13.0, *) {
//            2
//        } else {
//            window = UIWindow(frame: UIScreen.main.bounds)
//        }
        setNetwork()
        
        return true
    }
}

