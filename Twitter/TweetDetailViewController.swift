//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by Marc Anderson on 2/19/16.
//  Copyright © 2016 Marc Anderson. All rights reserved.
//

import UIKit

protocol TweetDetailViewControllerDelegate: class {
    func tweetDetailViewControllerDidUpdateTweet()
}

class TweetDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var tweet: Tweet?
    var containerViewController: ContainerViewController!

    weak var delegate: TweetDetailViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onReplyTap(sender: UIButton) {
        let storyboard = UIStoryboard(name: "Compose", bundle: nil)
        let tweetComposeVC = storyboard.instantiateViewControllerWithIdentifier("TweetComposeViewController") as! TweetComposeViewController
        tweetComposeVC.tweet = tweet
        containerViewController.presentViewController(tweetComposeVC, animated: true, completion: nil)
    }
}

extension TweetDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("TweetDetailCell") as! TweetDetailCell
            cell.delegate = self
            cell.tweet = tweet
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("TweetStatsCell") as! TweetStatsCell
            cell.tweet = tweet
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("TweetControlsCell") as! TweetControlsCell
            cell.delegate = self
            cell.tweet = tweet
            return cell
        }
    }
}

extension TweetDetailViewController: TweetDetailCellDelegate {
    func tweetCell(cell: TweetDetailCell, didTapProfileButton button: UIButton) {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let profileVC = storyboard.instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
        profileVC.user = tweet!.user
        profileVC.hidesMenuButton = true
        navigationController?.pushViewController(profileVC, animated: true)
    }
}

extension TweetDetailViewController: TweetControlsCellDelegate {
    func didUpdateTweet(tweet: Tweet) {
        self.tweet = tweet
        tableView.reloadData()
        delegate?.tweetDetailViewControllerDidUpdateTweet()
    }
}
