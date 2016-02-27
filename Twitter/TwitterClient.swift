//
//  TwitterClient.swift
//  Twitter
//
//  Created by Marc Anderson on 2/17/16.
//  Copyright © 2016 Marc Anderson. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let twitterBaseURL = NSURL(string: "https://api.twitter.com")
let twitterConsumerKey = "Yim4xHpLx8LZmjGSv15YjcIdz"
let twitterConsumerSecret = "JDkcg1q7k8rLS4sMyAtFaIZeDYqax2dWNlWWO36wdqFP1vTfZi"

class TwitterClient: BDBOAuth1SessionManager {

    var loginCompletion: ((user: User?, error: NSError?) -> Void)?

    static let sharedInstance = TwitterClient(
        baseURL: twitterBaseURL,
        consumerKey: twitterConsumerKey,
        consumerSecret: twitterConsumerSecret
    )

    func loginWithCompletion(completion: (user: User?, error: NSError?) -> Void) {
        loginCompletion = completion

        // Fetch request token & redirect to autorization page
        requestSerializer.removeAccessToken()
        fetchRequestTokenWithPath("oauth/request_token",
            method: "GET",
            callbackURL: NSURL(string: "codepathtwitter://oauth"),
            scope: nil,
            success: { (requestToken: BDBOAuth1Credential!) -> Void in
                // print("Got the request token!")
                let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
                UIApplication.sharedApplication().openURL(authURL)
            },
            failure: { (error: NSError!) -> Void in
                print("Failed to get request token!")
                self.loginCompletion?(user: nil, error: error)
            }
        )
    }

    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> Void) {
        GET("1.1/statuses/home_timeline.json",
            parameters: params,
            progress: nil,
            success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                // print("\(response)")
                let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                completion(tweets: tweets, error: nil)
            },
            failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Error getting home timeline.")
                completion(tweets: nil, error: error)
            }
        )
    }

    func userTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> Void) {
        GET("1.1/statuses/user_timeline.json",
            parameters: params,
            progress: nil,
            success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                // print("\(response)")
                let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                completion(tweets: tweets, error: nil)
            },
            failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Error getting user timeline.")
                completion(tweets: nil, error: error)
            }
        )
    }

    func mentionsWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> Void) {
        GET("1.1/statuses/mentions_timeline.json",
            parameters: params,
            progress: nil,
            success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                // print("\(response)")
                let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                completion(tweets: tweets, error: nil)
            },
            failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Error getting mentions timeline.")
                completion(tweets: nil, error: error)
            }
        )
    }

    func updateStatusWithParams(params: NSDictionary, completion: (tweet: Tweet?, error: NSError?) -> Void) {
        POST("1.1/statuses/update.json",
            parameters: params,
            progress: nil,
            success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                completion(tweet: Tweet.init(dictionary: response as! NSDictionary), error: nil)
            },
            failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Error updating status.")
            }
        )
    }

    func retweetStatusWithParams(params: NSDictionary, completion: (tweet: Tweet?, error: NSError?) -> Void) {
        POST("1.1/statuses/retweet/\(params["id"]!).json",
            parameters: params,
            progress: nil,
            success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                completion(tweet: Tweet.init(dictionary: response as! NSDictionary), error: nil)
            },
            failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Error retweeting status.")
            }
        )
    }

    func favoritesCreateWithParams(params: NSDictionary, completion: (tweet: Tweet?, error: NSError?) -> Void) {
        POST("1.1/favorites/create.json",
            parameters: params,
            progress: nil,
            success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                // print("\(response)")
                completion(tweet: Tweet.init(dictionary: response as! NSDictionary), error: nil)
            },
            failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Error favoriting tweet.")
            }
        )
    }

    func favoritesDestroyWithParams(params: NSDictionary, completion: (tweet: Tweet?, error: NSError?) -> Void) {
        POST("1.1/favorites/destroy.json",
            parameters: params,
            progress: nil,
            success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                // print("\(response)")
            },
            failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Error unfavoriting tweet.")
            }
        )
    }

    func openURL(url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token",
            method: "POST",
            requestToken: BDBOAuth1Credential(queryString: url.query),
            success: { (accessToken: BDBOAuth1Credential!) -> Void in
                TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)

                // Get current user info
                TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json",
                    parameters: nil,
                    progress: nil,
                    success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                        // print("\(response)")
                        let user = User(dictionary: response as! NSDictionary)
                        User.currentUser = user
                        self.loginCompletion?(user: user, error: nil)
                    },
                    failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                        print("Error getting current user.")
                        self.loginCompletion?(user: nil, error: error)
                    }
                )
            },
            failure: { (error: NSError!) -> Void in
                print("Failed to receive access token!")
                self.loginCompletion?(user: nil, error: error)
            }
        )
    }

}
