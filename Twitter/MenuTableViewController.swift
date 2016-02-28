//
//  MenuTableViewController.swift
//  Twitter
//
//  Created by Marc Anderson on 2/23/16.
//  Copyright © 2016 Marc Anderson. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {

    var containerViewController: ContainerViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let tweetsNC = storyboard.instantiateViewControllerWithIdentifier("TweetsNavigationController") as! UINavigationController
                Utils.configureDefaultNavigationBar(tweetsNC.navigationBar)
                let tweetsVC = tweetsNC.topViewController as! TweetsViewController
                tweetsVC.delegate = containerViewController
                tweetsVC.containerViewController = containerViewController
                containerViewController.contentViewController = tweetsNC
            } else if indexPath.row == 1 {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let tweetsNC = storyboard.instantiateViewControllerWithIdentifier("TweetsNavigationController") as! UINavigationController
                Utils.configureDefaultNavigationBar(tweetsNC.navigationBar)
                let tweetsVC = tweetsNC.topViewController as! TweetsViewController
                tweetsVC.delegate = containerViewController
                tweetsVC.containerViewController = containerViewController
                tweetsVC.showMentions = true
                containerViewController.contentViewController = tweetsNC
            }
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let storyboard = UIStoryboard(name: "Profile", bundle: nil)
                let profileNC = storyboard.instantiateViewControllerWithIdentifier("ProfileNavigationController") as! UINavigationController
                Utils.configureDefaultNavigationBar(profileNC.navigationBar)
                let profileVC = profileNC.topViewController as! ProfileViewController
                profileVC.delegate = containerViewController
                profileVC.user = User.currentUser
                containerViewController.contentViewController = profileNC
            } else if indexPath.row == 1 {
                let storyboard = UIStoryboard(name: "Account", bundle: nil)
                let accountNC = storyboard.instantiateViewControllerWithIdentifier("AccountNavigationController") as! UINavigationController
                Utils.configureDefaultNavigationBar(accountNC.navigationBar)
                let accountVC = accountNC.topViewController as! AccountViewController
                accountVC.delegate = containerViewController
                containerViewController.contentViewController = accountNC
            }
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}
