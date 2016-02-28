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

    @IBOutlet weak var tableView: UITableView!

    let userCellID = "com.marcadam.UserCell"

    var containerViewController: ContainerViewController!

    weak var delegate: AccountViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let userCellNIB = UINib(nibName: "UserCell", bundle: NSBundle.mainBundle())
        tableView.registerNib(userCellNIB, forCellReuseIdentifier: userCellID)
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

extension AccountViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(userCellID, forIndexPath: indexPath) as! UserCell
            cell.user = User.currentUser
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("AddAccountCell")!
            return cell
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            let storyboard = UIStoryboard(name: "Account", bundle: nil)
            let accountVC = storyboard.instantiateViewControllerWithIdentifier("AddAccountViewController")
            containerViewController.presentViewController(accountVC, animated: true, completion: nil)
        }

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}