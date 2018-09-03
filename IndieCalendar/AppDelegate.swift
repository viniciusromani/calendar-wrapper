//
//  AppDelegate.swift
//  IndieCalendar
//
//  Created by Vinicius Romani on 16/08/18.
//  Copyright © 2018 Vinicius Romani. All rights reserved.
//

import SwiftDate
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let viewController = ViewController()
        self.window?.rootViewController = viewController
        self.window?.makeKeyAndVisible()
//        
//        let alreadySelected = [Date() + 5.days,
//                               Date() + 6.days,
//                               Date() + 7.days]
//        
//        let dates = [Date(),
//                     Date() + 1.days,
//                     Date() + 2.days,
//                     Date() + 3.days,
//                     Date() + 4.days,
//                     Date() + 5.days,
//                     Date() + 6.days,
//                     Date() + 7.days,
//                     Date() + 8.days,
//                     Date() + 9.days,
//                     Date() + 10.days,
//                     Date() + 11.days,
//                     Date() + 12.days,
//                     Date() + 13.days,
//                     Date() + 14.days,
//                     Date() + 15.days,
//                     Date() + 16.days,
//                     Date() + 17.days,
//                     Date() + 18.days,
//                     Date() + 19.days,
//                     Date() + 20.days,
//                     Date() + 21.days,
//                     Date() + 22.days]
//        
//        for date in dates {
//            let next = alreadySelected.first { currentDate -> Bool in
//                let result = date.isAfter(date: currentDate)
//                print("date \(date) is after \(currentDate) ? \(result)")
//                
//                return result
//            }
//            
//            print("next \(next)")
//        }
//        
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

