//
//  AccountViewController.swift
//  Twitter
//
//  Created by Marc Anderson on 2/25/16.
//  Copyright © 2016 Marc Anderson. All rights reserved.
//

import UIKit

protocol AccountViewControllerDelegate: class {
    func accountView(_ accountView: AccountViewController, didTapMenuButton: UIBarButtonItem)
}

class AccountViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    let userCellID = "com.marcadam.UserCell"

    var containerViewController: ContainerViewController!

    weak var delegate: AccountViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let userCellNIB = UINib(nibName: "UserCell", bundle: Bundle.main)
        tableView.register(userCellNIB, forCellReuseIdentifier: userCellID)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onMenuTap(_ sender: UIBarButtonItem) {
        delegate?.accountView(self, didTapMenuButton: sender)
    }

    @IBAction func onLogout(_ sender: UIButton) {
        User.currentUser?.logout()
    }
}

extension AccountViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: userCellID, for: indexPath) as! UserCell
            cell.user = User.currentUser
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddAccountCell")!
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            // let storyboard = UIStoryboard(name: "Account", bundle: nil)
            // let accountVC = storyboard.instantiateViewControllerWithIdentifier("AddAccountViewController")
            // containerViewController.presentViewController(accountVC, animated: true, completion: nil)
            User.currentUser?.logout()
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
}
