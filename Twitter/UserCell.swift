//
//  UserCell.swift
//  Twitter
//
//  Created by Marc Anderson on 2/27/16.
//  Copyright © 2016 Marc Anderson. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!

    var user: User! {
        didSet {
            if let profileImageURL = user.profileImageURL {
                profileImageView.setImageWith(URL(string: profileImageURL)!)
            }
            nameLabel.text = user.name
            screenNameLabel.text = "@\(user.screenName!)"
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImageView.layer.cornerRadius = 3.0
        profileImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
