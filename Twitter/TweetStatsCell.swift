//
//  TweetStatsCell.swift
//  Twitter
//
//  Created by Marc Anderson on 2/19/16.
//  Copyright © 2016 Marc Anderson. All rights reserved.
//

import UIKit

class TweetStatsCell: UITableViewCell {

    @IBOutlet weak var tweetStatsLabel: UILabel!

    var tweet: Tweet! {
        didSet {
            let tweetStatsText = NSMutableAttributedString()
            let regularAttributes = [
                NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12.0),
                NSAttributedStringKey.foregroundColor: UIColor.lightGray
            ]
            let boldAttributes = [
                NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 12.0),
                NSAttributedStringKey.foregroundColor: UIColor.black
            ]

            if let retweetCount = tweet.retweetCount{
                tweetStatsText.append(NSAttributedString(string: "\(retweetCount)", attributes: boldAttributes))
                let retweetText = retweetCount == 1 ? "RETWEET" : "RETWEETS"
                tweetStatsText.append(NSAttributedString(string: " \(retweetText)    ", attributes: regularAttributes))
            }
            if let favoriteCount = tweet.favoriteCount {
                let favoriteText = favoriteCount == 1 ? "LIKE" : "LIKES"
                tweetStatsText.append(NSAttributedString(string: "\(favoriteCount)", attributes: boldAttributes))
                tweetStatsText.append(NSAttributedString(string: " \(favoriteText)    ", attributes: regularAttributes))
            }

            tweetStatsLabel.attributedText = tweetStatsText
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
