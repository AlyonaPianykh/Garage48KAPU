//
//  AppDelegate.swift
//  KAPU
//
//  Created by Vasyl Khmil on 3/4/17.
//  Copyright © 2017 Vasyl Khmil. All rights reserved.
//

import UIKit
import CoreData
import FirebaseCore
import IQKeyboardManagerSwift
import UserNotifications
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FIRApp.configure()
        IQKeyboardManager.sharedManager().enable = true
        
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        PushManager.shared.handle(userInfo)
    }
}

