//
//  AppDelegate.swift
//  Project_2Q_2019
//
//  Created by JUNHYEOK KWON on 2019/07/28.
//  Copyright © 2019 JUNHYEOK KWON. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    enum Environment {
        case debug
        case release

        var firebasePlistName: String {
            switch self {
            case .debug: return "GoogleService-Info-dev"
            case .release: return "GoogleService-Info"
            }
        }
    }

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        let environment: Environment = AppDelegate.isDebug ? .debug : .release

        if let path = Bundle.main.path(forResource: environment.firebasePlistName, ofType: "plist"),
            let firbaseOptions = FirebaseOptions(contentsOfFile: path) {
            FirebaseApp.configure(options: firbaseOptions)
        }
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)

        window = UIWindow()
        window?.makeKeyAndVisible()
        window?.rootViewController = AppRootViewController()

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

extension AppDelegate {

    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    static var isDebug: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }

    var rootViewController: AppRootViewController {
        return window!.rootViewController as! AppRootViewController
    }
}
