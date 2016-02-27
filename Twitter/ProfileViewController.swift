//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Marc Anderson on 2/23/16.
//  Copyright © 2016 Marc Anderson. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol ProfileViewControllerDelegate: class {
    func profileView(profileView: ProfileViewController, didTapMenuButton: UIBarButtonItem)
}

class ProfileViewController: UIViewController {

    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var headerScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var pageControlBackingView: UIView!
    @IBOutlet weak var tweetCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!

    @IBOutlet weak var tableView: UITableView!

    var user: User?
    var tweets: [Tweet]?
    var hidesMenuButton = false
    let tweetCellID = "com.marcadam.TweetCell"

    weak var delegate: ProfileViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        if hidesMenuButton {
            navigationItem.leftBarButtonItem = nil
            navigationItem.hidesBackButton = false
        }

        // Should maybe use profile_background_color instead
        // And may want to use profile_text_color for font color
        headerImage.backgroundColor = Color.twitterBlue
        if let profileBannerURL = user?.profileBannerURL {
            headerImage.setImageWithURL(NSURL(string: profileBannerURL)!)
        }

        pageControlBackingView.layer.cornerRadius = pageControlBackingView.frame.size.height / 2

        let contentWidth = view.bounds.width * 2
        let contentHeight = headerScrollView.bounds.height
        let pageWidth = view.bounds.width
        headerScrollView.contentSize = CGSizeMake(contentWidth, contentHeight)

        let profileHeaderView = ProfileHeaderView(frame: CGRectMake(0, 0, pageWidth, 160))
        profileHeaderView.user = user
        let profileDescriptionView = ProfileDescriptionView(frame: CGRectMake(pageWidth, 0, pageWidth, 160))
        profileDescriptionView.user = user

        if let tweetCount = user?.statusesCount {
            tweetCountLabel.text = "\(tweetCount)"
        }
        if let followingCount = user?.followingCount {
            followingCountLabel.text = "\(followingCount)"
        }
        if let followersCount = user?.followersCount {
            followersCountLabel.text = "\(followersCount)"
        }

        headerScrollView.addSubview(profileHeaderView)
        headerScrollView.addSubview(profileDescriptionView)

        let cellNib = UINib(nibName: "TweetCell", bundle: NSBundle.mainBundle())
        tableView.registerNib(cellNib, forCellReuseIdentifier: tweetCellID)
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

    func fetchTweets() {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        let params: NSDictionary = ["user_id": (user?.userID)!]
        TwitterClient.sharedInstance.userTimelineWithParams(params) { (tweets, error) -> Void in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            self.tweets = tweets
            self.tableView.reloadData()
        }
    }

    func refreshTweets(refreshControll: UIRefreshControl) {
        let params: NSDictionary = ["user_id": (user?.userID)!]
        TwitterClient.sharedInstance.userTimelineWithParams(params) { (tweets, error) -> Void in
            self.tweets = tweets
            self.tableView.reloadData()
            refreshControll.endRefreshing()
        }
    }

    @IBAction func pageControlDidPage(sender: UIPageControl) {
        let xOffset = headerScrollView.bounds.width * CGFloat(pageControl.currentPage)
        headerScrollView.setContentOffset(CGPointMake(xOffset,0) , animated: true)
    }

    @IBAction func onMenuTap(sender: UIBarButtonItem) {
        delegate?.profileView(self, didTapMenuButton: sender)
    }

    @IBAction func onTweetsTap(sender: UITapGestureRecognizer) {
        print("Tweets tapped")
    }

    @IBAction func onFollowingTap(sender: UITapGestureRecognizer) {
        print("Following tapped")
    }

    @IBAction func onFollowersTap(sender: UITapGestureRecognizer) {
        print("Followers tapped")
    }

}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets where tweets.count > 0 {
            return tweets.count
        } else {
            return 0
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(tweetCellID, forIndexPath: indexPath) as! TweetCell
        cell.tweet = tweets![indexPath.row]
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

extension ProfileViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.bounds.width)
    }
}
