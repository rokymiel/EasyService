//
//  AppDelegate.swift
//  EasyService
//
//  Created by Михаил on 02.01.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISceneDelegate, MessagingDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        let coreAssembly = CoreAssembly()
        let serviceAssembly = ServiceAssembly(coreAssembly: coreAssembly)
        let assembly = PresentationAssembly(serviceAssembly: serviceAssembly)
        window = UIWindow(frame: UIScreen.main.bounds)
        //
        //        //        self.window = UIWindow(frame: UIScreen.main.bounds)
        //
        //        //        UIApplication.shared.windows.first?.rootViewController = PresentationAssembly().buildLoginController()
        //
        //        //        Auth.auth().currentUser
        
        
        
        
        
        //        if #available(iOS 10.0, *) {
        // For iOS 10 display notification (sent via APNS)
        
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {v, error in
                print("QR", v)
                print("QQ", error)
                
            })
        //        } else {
        //            let settings: UIUserNotificationSettings =
        //                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        //            application.registerUserNotificationSettings(settings)
        //        }
        application.registerForRemoteNotifications()
//        DispatchQueue.main.async {
            self.window?.rootViewController = MainNavigationController(presentationAssembly: assembly, serviceAssembly: serviceAssembly)
            self.window?.makeKeyAndVisible()
            
//        }
        
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
            }
        }
        //        Messaging.messaging().shouldEstablishDirectChannel = false
        //
        //        Messaging.messaging().delegate = self
        
        
        //        do {
        //            try Auth.auth().signOut()
        //        } catch let signOutError as NSError {
        //          print ("Error signing out: %@", signOutError)
        //        }
        
        return true
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
    //    func application(_ application: UIApplication,
    //                      didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    //            Messaging.messaging().apnsToken = deviceToken
    //
    //    }
    
    
}


extension AppDelegate: UNUserNotificationCenterDelegate {
    //This method is to handle a notification that arrived while the app was running in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([[.alert, .sound]])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        completionHandler()
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        Messaging.messaging().appDidReceiveMessage(userInfo)
        completionHandler(.noData)
    }
}
