//
//  Utils.swift
//  Twitter
//
//  Created by Marc Anderson on 2/19/16.
//  Copyright © 2016 Marc Anderson. All rights reserved.
//

import Foundation
import UIKit

class Utils {
    class func configureDefaultNavigationBar(_ navBar: UINavigationBar) {
        navBar.isTranslucent = false
        navBar.barTintColor = Color.twitterBlue
        navBar.tintColor = UIColor.white
        navBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
}
