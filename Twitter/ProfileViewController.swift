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
    func profileView(_ profileView: ProfileViewController, didTapMenuButton: UIBarButtonItem)
}

class ProfileViewController: UIViewController {

    enum TableDisplayMode {
        case tweets, following, followers
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
    var tableDisplayMode: TableDisplayMode = .tweets {
        didSet {
            switch tableDisplayMode {
            case .tweets:
                tweetsLabel.textColor = UIColor.white
                tweetsContainerView.backgroundColor = Color.twitterBlue
                followingLabel.textColor = UIColor.lightGray
                followingContainerView.backgroundColor = UIColor.white
                followersLabel.textColor = UIColor.lightGray
                followersContainerView.backgroundColor = UIColor.white
            case .following:
                tweetsLabel.textColor = UIColor.lightGray
                tweetsContainerView.backgroundColor = UIColor.white
                followingLabel.textColor = UIColor.white
                followingContainerView.backgroundColor = Color.twitterBlue
                followersLabel.textColor = UIColor.lightGray
                followersContainerView.backgroundColor = UIColor.white
            case .followers:
                tweetsLabel.textColor = UIColor.lightGray
                tweetsContainerView.backgroundColor = UIColor.white
                followingLabel.textColor = UIColor.lightGray
                followingContainerView.backgroundColor = UIColor.white
                followersLabel.textColor = UIColor.white
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
            headerImage.setImageWith(URL(string: profileBannerURL)!)
        }

        pageControlBackingView.layer.cornerRadius = pageControlBackingView.frame.size.height / 2

        let contentWidth = view.bounds.width * 2
        let contentHeight = headerScrollView.bounds.height
        let pageWidth = view.bounds.width
        headerScrollView.contentSize = CGSize(width: contentWidth, height: contentHeight)

        let profileHeaderView = ProfileHeaderView(frame: CGRect(x: 0, y: 0, width: pageWidth, height: 160))
        profileHeaderView.user = user
        let profileDescriptionView = ProfileDescriptionView(frame: CGRect(x: pageWidth, y: 0, width: pageWidth, height: 160))
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

        let tweetCellNib = UINib(nibName: "TweetCell", bundle: Bundle.main)
        tableView.register(tweetCellNib, forCellReuseIdentifier: tweetCellID)
        let userCellNIB = UINib(nibName: "UserCell", bundle: Bundle.main)
        tableView.register(userCellNIB, forCellReuseIdentifier: userCellID)

        tableView.estimatedRowHeight = 80.0
        tableView.rowHeight = UITableViewAutomaticDimension

        let refreshControll = UIRefreshControl()

        refreshControll.addTarget(self, action: #selector(refreshTweets(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControll, at: 0)
        fetchTweets()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func fetchTweets() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let params: NSDictionary = ["user_id": (user?.userID)!]
        TwitterClient.sharedInstance.userTimelineWithParams(params) { (tweets, error) -> Void in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.tableDisplayMode = .tweets
            self.tweets = tweets
            self.tableView.reloadData()
        }
    }

    func refreshTweets(_ refreshControll: UIRefreshControl) {
        let params: NSDictionary = ["user_id": (user?.userID)!]
        TwitterClient.sharedInstance.userTimelineWithParams(params) { (tweets, error) -> Void in
            self.tableDisplayMode = .tweets
            self.tweets = tweets
            self.tableView.reloadData()
            refreshControll.endRefreshing()
        }
    }

    @IBAction func pageControlDidPage(_ sender: UIPageControl) {
        let xOffset = headerScrollView.bounds.width * CGFloat(pageControl.currentPage)
        headerScrollView.setContentOffset(CGPoint(x: xOffset,y: 0) , animated: true)
    }

    @IBAction func onMenuTap(_ sender: UIBarButtonItem) {
        delegate?.profileView(self, didTapMenuButton: sender)
    }

    @IBAction func onTweetsTap(_ sender: UITapGestureRecognizer) {
        fetchTweets()
    }

    @IBAction func onFollowingTap(_ sender: UITapGestureRecognizer) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let params: NSDictionary = ["user_id": (user?.userID)!]
        TwitterClient.sharedInstance.followingWithParams(params) { (users, error) -> Void in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.tableDisplayMode = .following
            self.users = users
            self.tableView.reloadData()
        }
    }

    @IBAction func onFollowersTap(_ sender: UITapGestureRecognizer) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let params: NSDictionary = ["user_id": (user?.userID)!]
        TwitterClient.sharedInstance.followersWithParams(params) { (users, error) -> Void in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.tableDisplayMode = .followers
            self.users = users
            self.tableView.reloadData()
        }
    }

}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch tableDisplayMode {
        case .tweets:
            if let tweets = tweets, tweets.count > 0 {
                return tweets.count
            } else {
                return 0
            }
        case .following, .followers:
            if let users = users, users.count > 0 {
                return users.count
            } else {
                return 0
            }
        }

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableDisplayMode {
        case .tweets:
            let cell = tableView.dequeueReusableCell(withIdentifier: tweetCellID, for: indexPath) as! TweetCell
            cell.tweet = tweets![indexPath.row]
            return cell
        case .following, .followers:
            let cell = tableView.dequeueReusableCell(withIdentifier: userCellID, for: indexPath) as! UserCell
            cell.user = users![indexPath.row]
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ProfileViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.bounds.width)
    }
}
