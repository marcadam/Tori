//
//  AccountViewController.swift
//  Twitter
//
//  Created by Marc Anderson on 2/25/16.
//  Copyright © 2016 Marc Anderson. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLogout(sender: UIButton) {
        User.currentUser?.logout()
    }
}
