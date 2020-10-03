//
//  PushService.swift
//  RTRS
//
//  Created by Vlada Calic on 27.09.16.
//  Copyright © 2016 Byrccom. All rights reserved.
//

import UIKit
import UserNotifications
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate struct Constants {
    static let categoryID = "NotCategory"
    static let wifiAction = "WiFiAction"
    static let DeviceTokenKey = "PushServiceDeviceTokenKey"
}

let iOSSuavooDeviceType = 1

final class PushService : NSObject {
    
    var token : String?
    var lastNotification: Date? = nil
    
    // var storedToken : String? {
    //     return Default.s[Constants.DeviceTokenKey] as? String
    // }
    
    // MARK: - Public
    func registerForPushNotifications() {
        #if !(targetEnvironment(simulator))
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {[weak self] (granted, error) in
                    if let sself = self, granted {
                        UNUserNotificationCenter.current().delegate = sself
                        //sself.setupActionCategories()
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                })
        #endif
    }
    
    func registerForRemoteNotification() {
        if isRegisteredForRemoteNotification() == false {
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    func handleReceivedRemoteNotification(_ notificationInfo:[AnyHashable: Any]) {
        // let userInfo : [String : Any] = notificationInfo as! [String:Any]
    }
    
    func handleReceivedLocalNotification(_ notification:UNNotification) {
        if UIApplication.shared.applicationState == .active {
            //todo
            
        }
    }
    
    func handleRegisterError(_ error:NSError) {
        debugPrint("Error registering for notifications: \(error)")
    }
    
    func isRegisteredForRemoteNotification() -> Bool {
        return UIApplication.shared.isRegisteredForRemoteNotifications
    }
    
}


extension PushService : UNUserNotificationCenterDelegate {
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void) {
        
        handleReceivedRemoteNotification(notification.request.content.userInfo)
        completionHandler([.alert, .badge, .sound])
    }
    
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Swift.Void) {
        handleReceivedRemoteNotification(response.notification.request.content.userInfo)
        
        //if response.actionIdentifier == Constants.wifiAction {
        // if let delegate = UIApplication.shared.delegate as? AppDelegate {
            // delegate.appService.openSystemWifiSettings()
        //}
        //}
        
        completionHandler()
        
    }
}

