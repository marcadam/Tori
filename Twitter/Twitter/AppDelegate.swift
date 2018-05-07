 //
//  AppDelegate.swift
//  Twitter
//
//  Created by Marc Anderson on 2/17/16.
//  Copyright © 2016 Marc Anderson. All rights reserved.
//

import UIKit
import AFNetworking
import BDBOAuth1Manager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let loginStoryboard = UIStoryboard(name: "Login", bundle: nil)
    let containerStoryboard = UIStoryboard(name: "Container", bundle: nil)
    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let menuStoryboard = UIStoryboard(name: "Menu", bundle: nil)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        NotificationCenter.default.addObserver(self, selector: #selector(userDidLogout), name: userDidLogoutNotification, object: nil)

        if User.currentUser != nil {
            let containerVC = containerStoryboard.instantiateViewController(withIdentifier: "ContainerViewController") as! ContainerViewController
            let menuNC = menuStoryboard.instantiateViewController(withIdentifier: "MenuNavigationController") as? UINavigationController
            let menuTVC = menuNC?.topViewController as! MenuTableViewController

            let tweetsNC = mainStoryboard.instantiateViewController(withIdentifier: "TweetsNavigationController") as! UINavigationController
            Utils.configureDefaultNavigationBar(tweetsNC.navigationBar)
            let tweetsVC = tweetsNC.topViewController as! TweetsViewController
            tweetsVC.delegate = containerVC

            menuTVC.containerViewController = containerVC
            tweetsVC.containerViewController = containerVC
            containerVC.menuViewController = menuNC
            containerVC.contentViewController = tweetsNC

//            // Just for building the profile view
//            let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)
//            let profileNC = profileStoryboard.instantiateViewControllerWithIdentifier("ProfileNavigationController") as! UINavigationController
//            Utils.configureDefaultNavigationBar(profileNC.navigationBar)
//            containerVC.contentViewController = profileNC

            window?.rootViewController = containerVC
        }

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        TwitterClient.sharedInstance?.openURL(url: url)
        return true
    }

    func userDidLogout() {
        let vc = loginStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        UIView.transition(with: window!,
            duration: 0.75,
            options: .transitionFlipFromLeft,
            animations: { () -> Void in
                self.window?.rootViewController = vc
            },
            completion: nil
        )
    }
}

