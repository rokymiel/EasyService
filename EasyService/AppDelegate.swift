//
//  AppDelegate.swift
//  EasyService
//
//  Created by Михаил on 02.01.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISceneDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        let serviceAssembly = ServiceAssembly()
        let assembly = PresentationAssembly(serviceAssembly: serviceAssembly)
        window = UIWindow(frame: UIScreen.main.bounds)
        
        //        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        //        UIApplication.shared.windows.first?.rootViewController = PresentationAssembly().buildLoginController()
        self.window?.makeKeyAndVisible()
        //        Auth.auth().currentUser
        self.window?.rootViewController = MainNavigationController(presentationAssembly: assembly, serviceAssembly: serviceAssembly)
        //        do {
        //            try Auth.auth().signOut()
        //        } catch let signOutError as NSError {
        //          print ("Error signing out: %@", signOutError)
        //        }
        
        return true
    }
}
