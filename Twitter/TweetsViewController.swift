//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Marc Anderson on 2/18/16.
//  Copyright © 2016 Marc Anderson. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol TweetsViewControllerDelegate: class {
    func tweetView(tweetView: TweetsViewController, didTapMenuButton: UIBarButtonItem)
}

class TweetsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var tweets: [Tweet]?
    var showMentions = false

    var containerViewController: ContainerViewController!

    weak var delegate: TweetsViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableViewAutomaticDimension

        let refreshControll = UIRefreshControl()

        if showMentions {
            title = "Mentions"
            refreshControll.addTarget(self, action: "refreshMentions:", forControlEvents: .ValueChanged)
            tableView.insertSubview(refreshControll, atIndex: 0)
            fetchMentions()
        } else {
            title = "Timeline"
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "insertNewTweet:", name: userDidPostTweetNotification, object: nil)
            refreshControll.addTarget(self, action: "refreshTweets:", forControlEvents: .ValueChanged)
            tableView.insertSubview(refreshControll, atIndex: 0)
            fetchTweets()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "tweetDetailSegue" {
            let tdvc = segue.destinationViewController as! TweetDetailViewController
            tdvc.delegate = self
            tdvc.containerViewController = containerViewController
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

    func fetchMentions() {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        TwitterClient.sharedInstance.mentionsWithParams(nil) { (tweets, error) -> Void in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            self.tweets = tweets
            self.tableView.reloadData()
        }
    }

    func refreshMentions(refreshControll: UIRefreshControl) {
        TwitterClient.sharedInstance.mentionsWithParams(nil) { (tweets, error) -> Void in
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

    @IBAction func onMenuTap(sender: UIBarButtonItem) {
        delegate?.tweetView(self, didTapMenuButton: sender)
    }

    @IBAction func onComposeTap(sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Compose", bundle: nil)
        let tweetComposeVC = storyboard.instantiateViewControllerWithIdentifier("TweetComposeViewController")
        containerViewController.presentViewController(tweetComposeVC, animated: true, completion: nil)
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
        let storyboard = UIStoryboard(name: "Compose", bundle: nil)
        let tcvc = storyboard.instantiateViewControllerWithIdentifier("TweetComposeViewController") as! TweetComposeViewController
        tcvc.tweet = tweet
        containerViewController.presentViewController(tcvc, animated: true, completion: nil)
    }

    func didUpdateTweet() {
        tableView.reloadData()
    }

    func tweetCell(cell: TweetCell, didTapProfileButton button: UIButton) {
        let indexPath = tableView.indexPathForCell(cell)!
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let profileVC = storyboard.instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
        profileVC.user = tweets![indexPath.row].user
        profileVC.hidesMenuButton = true
        navigationController?.pushViewController(profileVC, animated: true)
    }
}

extension TweetsViewController: TweetDetailViewControllerDelegate {
    func tweetDetailViewControllerDidUpdateTweet() {
        tableView.reloadData()
    }
}
