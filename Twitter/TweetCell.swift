//
//  TweetCell.swift
//  Twitter
//
//  Created by Marc Anderson on 2/18/16.
//  Copyright © 2016 Marc Anderson. All rights reserved.
//

import UIKit

protocol TweetCellDelegate: class {
    func didReplyToTweet(_ tweet: Tweet)
    func didUpdateTweet()
    func tweetCell(_ cell: TweetCell, didTapProfileButton button: UIButton)
}

class TweetCell: UITableViewCell {

    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var favoriteCountLabel: UILabel!

    var tweet: Tweet! {
        didSet {
            // Reset state
            profileImageButton.setImage(nil, for: .normal)
            nameLabel.text = nil
            screenNameLabel.text = nil
            tweetTextLabel.text = nil
            createdAtLabel.text = nil
            retweetButton.setImage(UIImage(named: "Retweet"), for: .normal)
            retweetCountLabel.text = nil
            favoriteButton.setImage(UIImage(named: "Favorite"), for: .normal)
            favoriteCountLabel.text = nil

            // Set up current state
            nameLabel.text = tweet.user?.name
            nameLabel.sizeToFit()
            if let screenName = tweet.user?.screenName {
                screenNameLabel.text = "@\(screenName)"
            }
            tweetTextLabel.text = tweet.text
            if let profileImageURL = tweet.user?.profileImageURL {
                profileImageButton.setBackgroundImageFor(.normal, with: URL(string: profileImageURL)!)
            }
            createdAtLabel.text = tweet.createdAtStringShort

            if User.currentUser?.userID == tweet.user?.userID {
                retweetButton.setImage(UIImage(named: "RetweetInactive"), for: .normal)
                retweetButton.isEnabled = false
            } else if tweet.retweeted! {
                retweetButton.setImage(UIImage(named: "RetweetOn"), for: .normal)
            }

            if tweet.favorited! {
                favoriteButton.setImage(UIImage(named: "FavoriteOn"), for: .normal)
            }

            if let retweetCount = tweet.retweetCount {
                retweetCountLabel.text = retweetCount > 0 ? "\(retweetCount)" : nil
            }

            if let favoriteCount = tweet.favoriteCount {
                favoriteCountLabel.text = favoriteCount > 0 ? "\(favoriteCount)" : nil
            }
        }
    }

    weak var delegate: TweetCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImageButton.layer.cornerRadius = 5
        profileImageButton.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onReply(_ sender: UIButton) {
        delegate?.didReplyToTweet(tweet)
    }

    @IBAction func onProfileImageTap(_ sender: UIButton) {
        delegate?.tweetCell(self, didTapProfileButton: sender)
    }

    @IBAction func onRetweet(_ sender: UIButton) {
        let params: NSDictionary = ["id": tweet.tweetID!]
        TwitterClient.sharedInstance.retweetStatusWithParams(params) { (tweet, error) -> Void in
            if tweet != nil {
                print("Retweet successful.")
                self.tweet.retweeted = true
                self.tweet.retweetCount = self.tweet.retweetCount! + 1
                DispatchQueue.main.async(execute: { () -> Void in
                    self.delegate?.didUpdateTweet()
                })
            } else {
                print("Retweet failed.")
            }
        }
    }

    @IBAction func onFavorite(_ sender: UIButton) {
        let params: NSDictionary = ["id": tweet.tweetID!]
        TwitterClient.sharedInstance.favoritesCreateWithParams(params) { (tweet, error) -> Void in
            if tweet != nil {
                print("Favorite successful.")
                self.tweet.favorited = true
                self.tweet.favoriteCount = self.tweet.favoriteCount! + 1
                DispatchQueue.main.async(execute: { () -> Void in
                    self.delegate?.didUpdateTweet()
                })
            } else {
                print("Favorit failed.")
            }
        }
    }
}
