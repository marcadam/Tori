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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let tweetsNC = storyboard.instantiateViewControllerWithIdentifier("TweetsNavigationController") as! UINavigationController
                Utils.configureDefaultNavigationBar(tweetsNC.navigationBar)
                containerViewController.contentViewController = tweetsNC
            } else if indexPath.row == 1 {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let tweetsNC = storyboard.instantiateViewControllerWithIdentifier("TweetsNavigationController") as! UINavigationController
                Utils.configureDefaultNavigationBar(tweetsNC.navigationBar)
                let tweetVC = tweetsNC.topViewController as! TweetsViewController
                tweetVC.showMentions = true
                containerViewController.contentViewController = tweetsNC
            }
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let storyboard = UIStoryboard(name: "Profile", bundle: nil)
                let profileNC = storyboard.instantiateViewControllerWithIdentifier("ProfileNavigationController") as! UINavigationController
                let profileVC = profileNC.topViewController as! ProfileViewController
                profileVC.user = User.currentUser
                Utils.configureDefaultNavigationBar(profileNC.navigationBar)
                containerViewController.contentViewController = profileNC
            } else if indexPath.row == 1 {

            }
        }
        // self.containerViewController.contentViewLeadingConstraint.constant = 0
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}
