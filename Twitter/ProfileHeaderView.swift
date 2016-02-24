//
//  ProfileHeaderView.swift
//  Twitter
//
//  Created by Marc Anderson on 2/23/16.
//  Copyright © 2016 Marc Anderson. All rights reserved.
//

import UIKit

class ProfileHeaderView: UIView {

    @IBOutlet var contentView: UIView!

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!

    var user: User? {
        didSet {
            if let user = user {
                nameLabel.text = user.name
                screenNameLabel.text = user.screenName
                if let profileImageURL = user.profileImageURL {
                    profileImageView.setImageWithURL(NSURL(string: profileImageURL)!)
                }
            }
        }
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initSubviews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }

    func initSubviews() {
        // standard initialization logic
        let nib = UINib(nibName: "ProfileHeaderView", bundle: nil)
        nib.instantiateWithOwner(self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)

        // custom initialization logic
        profileImageView.layer.cornerRadius = 6.0
        profileImageView.clipsToBounds = true
    }

}
