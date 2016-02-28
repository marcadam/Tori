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

    enum TableDisplayMode {
        case Tweets, Following, Followers
    }

    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var headerScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var pageControlBackingView: UIView!
    @IBOutlet weak var tweetsCountLabel: UILabel!
    @IBOutlet weak var tweetsLabel: UILabel!
    @IBOutlet weak var tweetsContainerView: UIView!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followingContainerView: UIView!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followersContainerView: UIView!

    @IBOutlet weak var tableView: UITableView!

    var user: User?
    var tweets: [Tweet]?
    var users: [User]?
    var hidesMenuButton = false
    let tweetCellID = "com.marcadam.TweetCell"
    let userCellID = "com.marcadam.UserCell"
    var tableDisplayMode: TableDisplayMode = .Tweets {
        didSet {
            switch tableDisplayMode {
            case .Tweets:
                tweetsLabel.textColor = UIColor.whiteColor()
                tweetsContainerView.backgroundColor = Color.twitterBlue
                followingLabel.textColor = UIColor.lightGrayColor()
                followingContainerView.backgroundColor = UIColor.whiteColor()
                followersLabel.textColor = UIColor.lightGrayColor()
                followersContainerView.backgroundColor = UIColor.whiteColor()
            case .Following:
                tweetsLabel.textColor = UIColor.lightGrayColor()
                tweetsContainerView.backgroundColor = UIColor.whiteColor()
                followingLabel.textColor = UIColor.whiteColor()
                followingContainerView.backgroundColor = Color.twitterBlue
                followersLabel.textColor = UIColor.lightGrayColor()
                followersContainerView.backgroundColor = UIColor.whiteColor()
            case .Followers:
                tweetsLabel.textColor = UIColor.lightGrayColor()
                tweetsContainerView.backgroundColor = UIColor.whiteColor()
                followingLabel.textColor = UIColor.lightGrayColor()
                followingContainerView.backgroundColor = UIColor.whiteColor()
                followersLabel.textColor = UIColor.whiteColor()
                followersContainerView.backgroundColor = Color.twitterBlue
            }
        }
    }

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
            tweetsCountLabel.text = "\(tweetCount)"
        }
        if let followingCount = user?.followingCount {
            followingCountLabel.text = "\(followingCount)"
        }
        if let followersCount = user?.followersCount {
            followersCountLabel.text = "\(followersCount)"
        }

        headerScrollView.addSubview(profileHeaderView)
        headerScrollView.addSubview(profileDescriptionView)

        let tweetCellNib = UINib(nibName: "TweetCell", bundle: NSBundle.mainBundle())
        tableView.registerNib(tweetCellNib, forCellReuseIdentifier: tweetCellID)
        let userCellNIB = UINib(nibName: "UserCell", bundle: NSBundle.mainBundle())
        tableView.registerNib(userCellNIB, forCellReuseIdentifier: userCellID)

        tableView.estimatedRowHeight = 80.0
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
            self.tableDisplayMode = .Tweets
            self.tweets = tweets
            self.tableView.reloadData()
        }
    }

    func refreshTweets(refreshControll: UIRefreshControl) {
        let params: NSDictionary = ["user_id": (user?.userID)!]
        TwitterClient.sharedInstance.userTimelineWithParams(params) { (tweets, error) -> Void in
            self.tableDisplayMode = .Tweets
            self.tweets = tweets
            self.tableView.reloadData()
            refreshControll.endRefreshing()
        }
    }

    func updateTableDisplayModeIndicator() {

    }

    @IBAction func pageControlDidPage(sender: UIPageControl) {
        let xOffset = headerScrollView.bounds.width * CGFloat(pageControl.currentPage)
        headerScrollView.setContentOffset(CGPointMake(xOffset,0) , animated: true)
    }

    @IBAction func onMenuTap(sender: UIBarButtonItem) {
        delegate?.profileView(self, didTapMenuButton: sender)
    }

    @IBAction func onTweetsTap(sender: UITapGestureRecognizer) {
        fetchTweets()
    }

    @IBAction func onFollowingTap(sender: UITapGestureRecognizer) {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        let params: NSDictionary = ["user_id": (user?.userID)!]
        TwitterClient.sharedInstance.followingWithParams(params) { (users, error) -> Void in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            self.tableDisplayMode = .Following
            self.users = users
            self.tableView.reloadData()
        }
    }

    @IBAction func onFollowersTap(sender: UITapGestureRecognizer) {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        let params: NSDictionary = ["user_id": (user?.userID)!]
        TwitterClient.sharedInstance.followersWithParams(params) { (users, error) -> Void in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            self.tableDisplayMode = .Followers
            self.users = users
            self.tableView.reloadData()
        }
    }

}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch tableDisplayMode {
        case .Tweets:
            if let tweets = tweets where tweets.count > 0 {
                return tweets.count
            } else {
                return 0
            }
        case .Following, .Followers:
            if let users = users where users.count > 0 {
                return users.count
            } else {
                return 0
            }
        }

    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch tableDisplayMode {
        case .Tweets:
            let cell = tableView.dequeueReusableCellWithIdentifier(tweetCellID, forIndexPath: indexPath) as! TweetCell
            cell.tweet = tweets![indexPath.row]
            return cell
        case .Following, .Followers:
            let cell = tableView.dequeueReusableCellWithIdentifier(userCellID, forIndexPath: indexPath) as! UserCell
            cell.user = users![indexPath.row]
            return cell
        }
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
