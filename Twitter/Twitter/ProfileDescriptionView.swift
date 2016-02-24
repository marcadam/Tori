//
//  ProfileDescriptionView.swift
//  Twitter
//
//  Created by Marc Anderson on 2/23/16.
//  Copyright © 2016 Marc Anderson. All rights reserved.
//

import UIKit

class ProfileDescriptionView: UIView {

    @IBOutlet var contentView: UIView!

    @IBOutlet weak var descriptionLabel: UILabel!

    var user: User? {
        didSet {
            if let user = user {
                if let tagline = user.tagline {
                    descriptionLabel.text = tagline
                } else {
                    descriptionLabel.text = nil
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
        let nib = UINib(nibName: "ProfileDescriptionView", bundle: nil)
        nib.instantiateWithOwner(self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)

        // custom initialization logic
    }

}
