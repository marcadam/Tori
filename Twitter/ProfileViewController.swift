//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Marc Anderson on 2/23/16.
//  Copyright © 2016 Marc Anderson. All rights reserved.
//

import UIKit

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

    var user: User?
    var hidesMenuButton = false

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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension ProfileViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.bounds.width)
    }
}
