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
    func tweetView(_ tweetView: TweetsViewController, didTapMenuButton: UIBarButtonItem)
}

class TweetsViewController: UIViewController {

    let tweetCellID = "com.marcadam.TweetCell"

    @IBOutlet weak var tableView: UITableView!

    var tweets: [Tweet]?
    var showMentions = false

    var containerViewController: ContainerViewController!

    weak var delegate: TweetsViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        let cellNib = UINib(nibName: "TweetCell", bundle: Bundle.main)
        tableView.register(cellNib, forCellReuseIdentifier: tweetCellID)
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableViewAutomaticDimension

        let refreshControll = UIRefreshControl()

        if showMentions {
            title = "Mentions"
            refreshControll.addTarget(self, action: #selector(refreshMentions(_:)), for: .valueChanged)
            tableView.insertSubview(refreshControll, at: 0)
            fetchMentions()
        } else {
            title = "Timeline"
            NotificationCenter.default.addObserver(self, selector: #selector(insertNewTweet(_:)), name: userDidPostTweetNotification, object: nil)
            refreshControll.addTarget(self, action: #selector(refreshTweets(_:)), for: .valueChanged)
            tableView.insertSubview(refreshControll, at: 0)
            fetchTweets()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func fetchTweets() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        TwitterClient.sharedInstance.homeTimelineWithParams(nil) { (tweets, error) -> Void in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.tweets = tweets
            self.tableView.reloadData()
        }
    }

    func refreshTweets(_ refreshControll: UIRefreshControl) {
        TwitterClient.sharedInstance.homeTimelineWithParams(nil) { (tweets, error) -> Void in
            self.tweets = tweets
            self.tableView.reloadData()
            refreshControll.endRefreshing()
        }
    }

    func fetchMentions() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        TwitterClient.sharedInstance.mentionsWithParams(nil) { (tweets, error) -> Void in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.tweets = tweets
            self.tableView.reloadData()
        }
    }

    func refreshMentions(_ refreshControll: UIRefreshControl) {
        TwitterClient.sharedInstance.mentionsWithParams(nil) { (tweets, error) -> Void in
            self.tweets = tweets
            self.tableView.reloadData()
            refreshControll.endRefreshing()
        }
    }

    func insertNewTweet(_ notification: Notification) {
        if let newTweet = notification.userInfo!["tweet"] as? Tweet {
            tweets?.insert(newTweet, at: 0)
            tableView.reloadData()
        }
    }

    @IBAction func onMenuTap(_ sender: UIBarButtonItem) {
        delegate?.tweetView(self, didTapMenuButton: sender)
    }

    @IBAction func onComposeTap(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Compose", bundle: nil)
        let tweetComposeVC = storyboard.instantiateViewController(withIdentifier: "TweetComposeViewController")
        containerViewController.present(tweetComposeVC, animated: true, completion: nil)
    }
}

extension TweetsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets, tweets.count > 0 {
            return tweets.count
        } else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tweetCellID, for: indexPath) as! TweetCell
        cell.delegate = self
        cell.tweet = tweets![indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tweetDetailVC = storyboard.instantiateViewController(withIdentifier: "TweetDetailViewController") as! TweetDetailViewController
        tweetDetailVC.delegate = self
        tweetDetailVC.containerViewController = containerViewController
        tweetDetailVC.tweet = tweets![indexPath.row]
        navigationController?.pushViewController(tweetDetailVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension TweetsViewController: TweetCellDelegate {
    func didReplyToTweet(_ tweet: Tweet) {
        let storyboard = UIStoryboard(name: "Compose", bundle: nil)
        let tcvc = storyboard.instantiateViewController(withIdentifier: "TweetComposeViewController") as! TweetComposeViewController
        tcvc.tweet = tweet
        containerViewController.present(tcvc, animated: true, completion: nil)
    }

    func didUpdateTweet() {
        tableView.reloadData()
    }

    func tweetCell(_ cell: TweetCell, didTapProfileButton button: UIButton) {
        let indexPath = tableView.indexPath(for: cell)!
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let profileVC = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
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
