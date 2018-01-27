//
//  Tweet.swift
//  Twitter
//
//  Created by Marc Anderson on 2/18/16.
//  Copyright © 2016 Marc Anderson. All rights reserved.
//

import Foundation

class Tweet {
    var tweetID: Int?
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAtStringShort: String?
    var createdAtStringMedium: String?
    var createdAt: Date?
    var retweetCount: Int?
    var retweetedStatus: NSDictionary?
    var retweetedTweet: Tweet?
    var favoriteCount: Int?
    var retweeted: Bool?
    var favorited: Bool?

    init(dictionary: NSDictionary) {
        tweetID = dictionary["id"] as? Int
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = dateFormatter.date(from: createdAtString!)
        createdAtStringShort = createdAtStringShortFromDate(createdAt!)
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        createdAtStringMedium = dateFormatter.string(from: createdAt!)
        retweetCount = dictionary["retweet_count"] as? Int

        if let retweetedStatus = dictionary["retweeted_status"] as? NSDictionary {
            retweetedTweet = Tweet(dictionary: retweetedStatus)
            favoriteCount = retweetedStatus["favorite_count"] as? Int
        } else {
            favoriteCount = dictionary["favorite_count"] as? Int
        }
        retweeted = dictionary["retweeted"] as? Bool
        favorited = dictionary["favorited"] as? Bool
    }

    class func tweetsWithArray(_ array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()

        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }

        return tweets
    }

    fileprivate func createdAtStringShortFromDate(_ date: Date) -> String? {
        var createdAtStringShort: String?
        let secondsPerMinute = 60.0
        let secondsPerHour = secondsPerMinute * secondsPerMinute
        let secondsPerDay = secondsPerHour * 24.0
        if var dateDelta = createdAt?.timeIntervalSinceNow {
            dateDelta = abs(dateDelta)
            if dateDelta < secondsPerHour {
                createdAtStringShort = String(format: "%.0fm", arguments: [dateDelta / secondsPerMinute])
            } else if dateDelta < secondsPerDay {
                createdAtStringShort = String(format: "%.0fh", arguments: [dateDelta / secondsPerHour])
            } else {
                createdAtStringShort = String(format: "%.0fd", arguments: [dateDelta / secondsPerDay])
            }
        }
        return createdAtStringShort
    }
}
