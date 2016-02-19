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


    @IBAction func onLogin(sender: UIButton) {
        TwitterClient.sharedInstance.loginWithCOmpletion() {
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
