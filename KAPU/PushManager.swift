//
//  PushManager.swift
//  KAPU
//
//  Created by Vasyl Khmil on 3/4/17.
//  Copyright © 2017 Vasyl Khmil. All rights reserved.
//

import UIKit
import FirebaseMessaging
import UserNotifications

class PushManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = PushManager()
    
    private struct Constants {
        static let allFeedsTopic    = "topics/feeds"
        static let contentTypeKey   = "Content-Type"
        static let autherizationKey = "Authorization"
        static let jsonType         = "application/json"
        static let appKey           = "AAAAdV2mJOg:APA91bGi9ttU_rfnDKNEabTSICpOfvNT71L9qNTTri0TPkglJIfAo5VpD_9BUvHWSZLUo_ID2lleqqo2yJU0c3SLRGNHbRhJSItS3Unq8F7mQ8ZfUkwS03g2A077_UGwIH5TAr7v1XD5"
    }
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.ephemeral
        
        config.httpAdditionalHeaders = [
            Constants.contentTypeKey : Constants.jsonType,
            Constants.autherizationKey : Constants.appKey
        ]
        
        config.httpShouldSetCookies = false
        config.httpCookieAcceptPolicy = .never
        
        let session = URLSession(configuration: config)
        
        return session
    }()
    
    func subscribeToAllFeeds() {
        self.subscribeToNotifications()
        FIRMessaging.messaging().subscribe(toTopic: Constants.allFeedsTopic)
    }
    
    func sendNewFeed(with title: String, description: String, id: String) {
        FIRMessaging.messaging().sendMessage(["description" : description], to: Constants.allFeedsTopic, withMessageID: id, timeToLive: 60)
    }
    
    func handle(_ pushInfo: [AnyHashable: Any]) {
        
    }
    
    private func subscribeToNotifications() {
        if #available(iOS 10.0, *) {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
            UNUserNotificationCenter.current().delegate = self
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        
        UIApplication.shared.registerForRemoteNotifications()
    }
}
