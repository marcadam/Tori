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

    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        loginButton.backgroundColor = Color.twitterBlue
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let containerVC = segue.destination as! ContainerViewController

        let menuStoryboard = UIStoryboard(name: "Menu", bundle: nil)
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)

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
    }

    @IBAction func onLogin(_ sender: UIButton) {
        TwitterClient.sharedInstance.loginWithCompletion() {
            (user: User?, error: NSError?) in
            if user != nil {
                // perform segue
                self.performSegue(withIdentifier: "loginSegue", sender: self)
            } else {
                // handle login error
            }
        }
    }
}
