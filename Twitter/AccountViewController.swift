//
//  AccountViewController.swift
//  Twitter
//
//  Created by Marc Anderson on 2/25/16.
//  Copyright © 2016 Marc Anderson. All rights reserved.
//

import UIKit

protocol AccountViewControllerDelegate: class {
    func accountView(accountView: AccountViewController, didTapMenuButton: UIBarButtonItem)
}

class AccountViewController: UIViewController {

    weak var delegate: AccountViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onMenuTap(sender: UIBarButtonItem) {
        delegate?.accountView(self, didTapMenuButton: sender)
    }

    @IBAction func onLogout(sender: UIButton) {
        User.currentUser?.logout()
    }
}
