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
    let containerStoryboard = UIStoryboard(name: "Container", bundle: nil)
    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let menuStoryboard = UIStoryboard(name: "Menu", bundle: nil)

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userDidLogout", name: userDidLogoutNotification, object: nil)

        if User.currentUser != nil {
            let containerVC = containerStoryboard.instantiateViewControllerWithIdentifier("ContainerViewController") as! ContainerViewController
            let menuNC = menuStoryboard.instantiateViewControllerWithIdentifier("MenuNavigationController") as? UINavigationController
            let menuTVC = menuNC?.topViewController as! MenuTableViewController

            let tweetsNC = mainStoryboard.instantiateViewControllerWithIdentifier("TweetsNavigationController") as! UINavigationController
            Utils.configureDefaultNavigationBar(tweetsNC.navigationBar)

            menuTVC.containerViewController = containerVC
            containerVC.menuViewController = menuNC
            containerVC.contentViewController = tweetsNC

            // Just for building the profile view
            let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)
            let profileNC = profileStoryboard.instantiateViewControllerWithIdentifier("ProfileNavigationController") as! UINavigationController
            Utils.configureDefaultNavigationBar(profileNC.navigationBar)
            containerVC.contentViewController = profileNC

            window?.rootViewController = containerVC
        }

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        TwitterClient.sharedInstance.openURL(url)
        return true
    }

    func userDidLogout() {
        let vc = mainStoryboard.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        window?.rootViewController = vc
    }
}

