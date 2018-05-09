//
//  AppDelegate.swift
//  Trade
//
//  Created by Aryeh Greenberg on 5/7/18.
//  Copyright © 2018 AGApps. All rights reserved.
//

import UIKit
import Parse
import SendBirdSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        SBDMain.initWithApplicationId("5D96AA5B-A934-44C6-8B88-B7F715FA0509")
        //Register parse subclasses
        Trade.registerSubclass()
        Item.registerSubclass()
        
        let parseSetup = ParseClientConfiguration { (server) in
            server.applicationId = "APPLICATION_ID"
            server.server = "http://192.168.1.169:1337/parse"
        }
        Parse.initialize(with: parseSetup)
        if PFUser.current() == nil {
            PFAnonymousUtils.logInInBackground()
            PFAnonymousUtils.logIn { (user, error) in
                if error == nil {
                    SBDMain.connect(withUserId: user!.objectId!, completionHandler: { (user, error) in
                        print("Connected to sendbird")
                    })
                }
               
            }
        }
        
        
        
        return true
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

