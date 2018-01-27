//
//  User.swift
//  Twitter
//
//  Created by Marc Anderson on 2/18/16.
//  Copyright © 2016 Marc Anderson. All rights reserved.
//

import Foundation

var _currentUser: User?
let currentUserKey = "CurrentUserKey"
let userDidLoginNotification = Notification.Name("userDidLoginNotification")
let userDidLogoutNotification = Notification.Name("userDidLogoutNotification")

class User {
    var userID: Int?
    var name: String?
    var screenName: String?
    var profileImageURL: String?
    var profileBannerURL: String?
    var tagline: String?
    var followersCount: Int?
    var followingCount: Int?
    var statusesCount: Int?
    var dictionary: NSDictionary

    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        userID = dictionary["id"] as? Int
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        profileImageURL = dictionary["profile_image_url"] as? String
        profileBannerURL = dictionary["profile_banner_url"] as? String
        tagline = dictionary["description"] as? String
        followersCount = dictionary["followers_count"] as? Int
        followingCount = dictionary["friends_count"] as? Int
        statusesCount = dictionary["statuses_count"] as? Int
    }

    class func usersWithArray(_ array: [NSDictionary]) -> [User] {
        var users = [User]()

        for dictionary in array {
            users.append(User(dictionary: dictionary))
        }

        return users
    }

    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()

        NotificationCenter.default.post(name: userDidLogoutNotification, object: nil)
    }

    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let data = UserDefaults.standard.object(forKey: currentUserKey) as? Data
                if data != nil {
                    var dictionary: NSDictionary?
                    do {
                        dictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as? NSDictionary
                    } catch {
                        print("Error deserializing user data.")
                    }
                    _currentUser = User(dictionary: dictionary!)
                }
            }
            return _currentUser
        }

        set(user) {
            _currentUser = user

            if _currentUser != nil {
                var data: Data?
                do {
                    data = try JSONSerialization.data(withJSONObject: user!.dictionary, options: JSONSerialization.WritingOptions())
                } catch {
                    print("Error serializing user JSON.")
                }

                UserDefaults.standard.set(data, forKey: currentUserKey)
            } else {
                UserDefaults.standard.set(nil, forKey: currentUserKey)
            }
            UserDefaults.standard.synchronize()
        }
    }
}
