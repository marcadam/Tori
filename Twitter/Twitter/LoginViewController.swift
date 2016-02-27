//
//  LoginViewController.swift
//  Twitter
//
//  Created by Marc Anderson on 2/17/16.
//  Copyright © 2016 Marc Anderson. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let containerVC = segue.destinationViewController as! ContainerViewController

        let menuStoryboard = UIStoryboard(name: "Menu", bundle: nil)
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)

        let menuNC = menuStoryboard.instantiateViewControllerWithIdentifier("MenuNavigationController") as? UINavigationController
        let menuTVC = menuNC?.topViewController as! MenuTableViewController

        let tweetsNC = mainStoryboard.instantiateViewControllerWithIdentifier("TweetsNavigationController") as! UINavigationController
        Utils.configureDefaultNavigationBar(tweetsNC.navigationBar)
        let tweetsVC = tweetsNC.topViewController as! TweetsViewController
        tweetsVC.delegate = containerVC

        menuTVC.containerViewController = containerVC
        tweetsVC.containerViewController = containerVC
        containerVC.menuViewController = menuNC
        containerVC.contentViewController = tweetsNC
    }

    @IBAction func onLogin(sender: UIButton) {
        TwitterClient.sharedInstance.loginWithCompletion() {
            (user: User?, error: NSError?) in
            if user != nil {
                // perform segue
                self.performSegueWithIdentifier("loginSegue", sender: self)
            } else {
                // handle login error
            }
        }
    }
}
