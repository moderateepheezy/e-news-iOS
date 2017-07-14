//
//  AppDelegate.swift
//  e-news-paper
//
//  Created by SimpuMind on 4/6/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit
import Firebase
import Google
import FBSDKLoginKit
import FBSDKCoreKit
import IQKeyboardManagerSwift
import FirebaseAuth
import FirebaseMessaging
import UserNotifications
import BSForegroundNotification

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UITabBar.appearance().tintColor = .black
        
        FirebaseApp.configure()
        
        Database.database().isPersistenceEnabled = true
        
        window =  UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        window?.rootViewController = MainTabBarController()
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        //Optionally add to ensure your credentials are valid:
        
        FBSDKLoginManager.renewSystemCredentials { (accoutCredentials, error) in
            
        }
        
        let vendorRef = Database.database().reference(withPath: "newspapers")
        vendorRef.keepSynced(true)
        
        let commentRef = Database.database().reference(withPath: "comments")
        commentRef.keepSynced(true)
        
        let newsRef = Database.database().reference(withPath: "news")
        newsRef.keepSynced(true)
        
        let subscriberRef = Database.database().reference(withPath: "subscriber")
        subscriberRef.keepSynced(true)
        
        IQKeyboardManager.sharedManager().enable = true
        
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .badge, .alert], completionHandler: { (granted, error) in })
            application.registerForRemoteNotifications()
        } else {
            // Fallback on earlier versions
            let notificationSettings = UIUserNotificationSettings(types: [.badge, .alert, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(notificationSettings)
            UIApplication.shared.registerForRemoteNotifications()
        }
        //checkChildAdded()
        registerNotifications()
        
        return true
    }
    
    private func registerNotifications() {
        
        let settings = UIUserNotificationSettings(types: [.alert, .sound, .badge], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(settings)
        createLocalNotification()
    }
    
    func createLocalNotification(){
        let localNotification = UILocalNotification()
        localNotification.fireDate = Date(timeIntervalSince1970: 10)
        localNotification.applicationIconBadgeNumber = 1
        localNotification.soundName = UILocalNotificationDefaultSoundName
        localNotification.userInfo = [
            "message": "A new item has been added!"
        ]
        
        localNotification.alertBody = "A new item has been added!"
        UIApplication.shared.scheduleLocalNotification(localNotification)
    }
    
    func takeActionWithNotification(localNotification: UILocalNotification){
        let tabbarController = self.window?.rootViewController as! UITabBarController
        tabbarController.selectedIndex = 0
    }
    
    
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        if application.applicationState == .active {
            
        }else{
            self.takeActionWithNotification(localNotification: notification)
        }
    }
    
    func checkChildAdded(){
        AppFirRef.newspaperRef.observe(.childChanged, with: { (snapshot) in
            self.registerNotifications()
            
            print("IT got here!!!")
        })
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
        // Print notification payload data
        print("Push notification received: \(data)")
    }
    
    func foregroundRemoteNotificationWasTouched(with userInfo: [AnyHashable: Any]) {
        //responseLabel.text = "touched"
    }
    
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable: Any], completionHandler: @escaping () -> Void) {
        //responseLabel.text = "action: \(identifier!)"
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable: Any], withResponseInfo responseInfo: [AnyHashable: Any], completionHandler: @escaping () -> Void) {
        //responseLabel.text = "textField: \(responseInfo[UIUserNotificationActionResponseTypedTextKey]!)"
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        FBSDKAppEvents.activateApp()
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
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        
        let googleDidHandle = GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation] as? String)
        
        let facebookDidHandle = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        return googleDidHandle || facebookDidHandle
        
    }
    
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        let googleDidHandle = GIDSignIn.sharedInstance().handle(url,
                                                                   sourceApplication: sourceApplication,
                                                                   annotation: annotation)
        
        let facebookDidHandle = FBSDKApplicationDelegate.sharedInstance().application(
            application,
            open: url,
            sourceApplication: sourceApplication,
            annotation: annotation)
        
        return googleDidHandle || facebookDidHandle
    }


}

