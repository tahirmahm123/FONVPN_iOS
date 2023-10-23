//
//  NotificationHandler.swift
//
//  Created by LEI on 7/23/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

import Foundation
import CocoaLumberjack
import FirebaseMessaging
import CocoaLumberjack
import Alamofire

class NotificationHandler: NSObject, AppLifeCycleProtocol, MessagingDelegate, UNUserNotificationCenterDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        
        application.registerForRemoteNotifications()
        if let launchOptions = launchOptions, let userInfo = launchOptions[UIApplication.LaunchOptionsKey.remoteNotification] as? [AnyHashable: Any], let origin = userInfo["origin"] as? String {
        }
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format:"%02X", $1)})
        print(deviceTokenString)
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
        let hidden = (userInfo["hidden"] as? String ?? "") == "true"
        if hidden {
            print("message is hidden")
            let prevMsg = userDefaults.string(forKey: "NotificationDescription")
            userDefaults.set("\(prevMsg ?? ""), \(userInfo["title"] ?? "")", forKey: "NotificationDescription")
            completionHandler(.noData)
        }else {
            print("showing alert")
            completionHandler(.noData)
        }
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        print("offline messages: \(userDefaults.string(forKey: "NotificationDescription") ?? "")")
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
        Task {
            await ApiManager.shared.updateNotificationToken(token: fcmToken ?? "")
        }
    }
    
        // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification) async
    -> UNNotificationPresentationOptions {
        let userInfo = notification.request.content.userInfo
        
            // With swizzling disabled you must let Messaging know about the message, for Analytics
            // Messaging.messaging().appDidReceiveMessage(userInfo)
        
            // ...
        
            // Print full message.
        print(userInfo)
            //        print()
        let hidden = (userInfo["hidden"] as? String ?? "") == "true"
        if hidden {
            print("message is hidden")
            let prevMsg = userDefaults.string(forKey: "NotificationDescription")
            userDefaults.set("\(prevMsg ?? ""), \(userInfo["title"] ?? "")", forKey: "NotificationDescription")
            return []
        }else {
            print("showing alert")
            return [[.alert, .sound]]
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse) async {
        let userInfo = response.notification.request.content.userInfo
        let hidden = (userInfo["hidden"] as? String ?? "") == "true"
        if hidden {
            print("message is hidden")
            let prevMsg = userDefaults.string(forKey: "NotificationDescription")
            userDefaults.set("\(prevMsg ?? ""), \(userInfo["title"] ?? "")", forKey: "NotificationDescription")
        }else {
            print("showing alert")
        }
        print(userInfo)
    }
    

}

extension Data {
    func hexString() -> String {
        // "Array" of all bytes:
        let bytes = UnsafeBufferPointer<UInt8>(start: (self as NSData).bytes.bindMemory(to: UInt8.self, capacity: self.count), count:self.count)
        // Array of hex strings, one for each byte:
        let hexBytes = bytes.map { String(format: "%02hhx", $0) }
        // Concatenate all hex strings:
        return hexBytes.joined(separator: "")
    }
}
