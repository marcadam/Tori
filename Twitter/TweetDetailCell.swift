//
//  TweetDetailCell.swift
//  Twitter
//
//  Created by Marc Anderson on 2/19/16.
//  Copyright © 2016 Marc Anderson. All rights reserved.
//

import UIKit

protocol TweetDetailCellDelegate: class {
    func tweetCell(_ cell: TweetDetailCell, didTapProfileButton button: UIButton)
}

class TweetDetailCell: UITableViewCell {

    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!

    var tweet: Tweet! {
        didSet {
            nameLabel.text = tweet.user?.name
            nameLabel.sizeToFit()
            if let screenName = tweet.user?.screenName {
                screenNameLabel.text = "@\(screenName)"
            }
            tweetTextLabel.text = tweet.text
            if let profileImageURL = tweet.user?.profileImageURL {
                profileImageButton.setBackgroundImageFor(.normal, with: URL(string: profileImageURL)!)
            }
            createdAtLabel.text = tweet.createdAtStringMedium
        }
    }

    weak var delegate: TweetDetailCellDelegate?

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

    @IBAction func onProfileImageTap(_ sender: UIButton) {
        delegate?.tweetCell(self, didTapProfileButton: sender)
    }

}
