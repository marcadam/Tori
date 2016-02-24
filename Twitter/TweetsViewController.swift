//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Marc Anderson on 2/18/16.
//  Copyright © 2016 Marc Anderson. All rights reserved.
//

import UIKit
import MBProgressHUD

class TweetsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var tweets: [Tweet]?

    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "insertNewTweet:", name: userDidPostTweetNotification, object: nil)

        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableViewAutomaticDimension

        let refreshControll = UIRefreshControl()
        refreshControll.addTarget(self, action: "refreshTweets:", forControlEvents: .ValueChanged)
        tableView.insertSubview(refreshControll, atIndex: 0)

        fetchTweets()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "tweetDetailSegue" {
            let tdvc = segue.destinationViewController as! TweetDetailViewController
            tdvc.delegate = self
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)!
            tdvc.tweet = tweets![indexPath.row]
        }
    }

    func fetchTweets() {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        TwitterClient.sharedInstance.homeTimelineWithParams(nil) { (tweets, error) -> Void in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            self.tweets = tweets
            self.tableView.reloadData()
        }
    }

    func refreshTweets(refreshControll: UIRefreshControl) {
        TwitterClient.sharedInstance.homeTimelineWithParams(nil) { (tweets, error) -> Void in
            self.tweets = tweets
            self.tableView.reloadData()
            refreshControll.endRefreshing()
        }
    }

    func insertNewTweet(notification: NSNotification) {
        if let newTweet = notification.userInfo!["tweet"] as? Tweet {
            tweets?.insert(newTweet, atIndex: 0)
            tableView.reloadData()
        }
    }

    @IBAction func onLogout(sender: UIBarButtonItem) {
        User.currentUser?.logout()
    }
}

extension TweetsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets where tweets.count > 0 {
            return tweets.count
        } else {
            return 0
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell") as! TweetCell
        cell.delegate = self
        cell.tweet = tweets![indexPath.row]
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

extension TweetsViewController: TweetCellDelegate {
    func didReplyToTweet(tweet: Tweet) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tcvc = storyboard.instantiateViewControllerWithIdentifier("TweetComposeViewController") as! TweetComposeViewController
        tcvc.tweet = tweet
        presentViewController(tcvc, animated: true, completion: nil)
    }

    func didUpdateTweet() {
        tableView.reloadData()
    }

    func tweetCell(cell: TweetCell, didTapProfileButton button: UIButton) {
        let indexPath = tableView.indexPathForCell(cell)!
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let profileVC = storyboard.instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
        profileVC.user = tweets![indexPath.row].user
        navigationController?.pushViewController(profileVC, animated: true)
    }
}

extension TweetsViewController: TweetDetailViewControllerDelegate {
    func tweetDetailViewControllerDidUpdateTweet() {
        tableView.reloadData()
    }
}
