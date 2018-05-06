//
//  TwitterClient.swift
//  Twitter
//
//  Created by Marc Anderson on 2/17/16.
//  Copyright © 2016 Marc Anderson. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let twitterBaseURL = URL(string: "https://api.twitter.com")
let twitterConsumerKey = "Yim4xHpLx8LZmjGSv15YjcIdz"
let twitterConsumerSecret = "JDkcg1q7k8rLS4sMyAtFaIZeDYqax2dWNlWWO36wdqFP1vTfZi"

class TwitterClient: BDBOAuth1SessionManager {

    var loginCompletion: ((_ user: User?, _ error: Error?) -> Void)?

    static let sharedInstance = TwitterClient(
        baseURL: twitterBaseURL,
        consumerKey: twitterConsumerKey,
        consumerSecret: twitterConsumerSecret
    )

    func loginWithCompletion(completion: @escaping (_ user: User?, _ error: Error?) -> Void) {
        loginCompletion = completion

        // Fetch request token & redirect to autorization page
        requestSerializer.removeAccessToken()
        fetchRequestToken(withPath: "oauth/request_token",
            method: "GET",
            callbackURL: URL(string: "codepathtwitter://oauth"),
            scope: nil,
            success: { (requestToken: BDBOAuth1Credential!) -> Void in
                guard let token = requestToken.token else { fatalError( "Response token is empty!" ) }
                // print("Got the request token!")
                let authURL = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(token)")!
                UIApplication.shared.openURL(authURL)
            },
            failure: { (error: Error!) -> Void in
                print("Failed to get request token!")
                self.loginCompletion?(nil, error)
            }
        )
    }

    func homeTimelineWithParams(params: NSDictionary?, completion: @escaping (_ tweets: [Tweet]?, _ error: Error?) -> Void) {
        get("1.1/statuses/home_timeline.json",
            parameters: params,
            progress: nil,
            success: { (task: URLSessionDataTask, response: Any?) -> Void in
                // print("\(response)")
                let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                completion(tweets, nil)
            },
            failure: { (task: URLSessionDataTask?, error: Error) -> Void in
                print("Error getting home timeline.")
                completion(nil, error)
            }
        )
    }

    func userTimelineWithParams(params: NSDictionary?, completion: @escaping (_ tweets: [Tweet]?, _ error: Error?) -> Void) {
        get("1.1/statuses/user_timeline.json",
            parameters: params,
            progress: nil,
            success: { (task: URLSessionDataTask, response: Any?) -> Void in
                // print("\(response)")
                let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                completion(tweets, nil)
            },
            failure: { (task: URLSessionDataTask?, error: Error) -> Void in
                print("Error getting user timeline.")
                completion(nil, error)
            }
        )
    }

    func mentionsWithParams(params: NSDictionary?, completion: @escaping (_ tweets: [Tweet]?, _ error: Error?) -> Void) {
        get("1.1/statuses/mentions_timeline.json",
            parameters: params,
            progress: nil,
            success: { (task: URLSessionDataTask, response: Any?) -> Void in
                // print("\(response)")
                let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                completion(tweets, nil)
            },
            failure: { (task: URLSessionDataTask?, error: Error) -> Void in
                print("Error getting mentions timeline.")
                completion(nil, error)
            }
        )
    }

    func updateStatusWithParams(params: NSDictionary, completion: @escaping (_ tweet: Tweet?, _ error: Error?) -> Void) {
        post("1.1/statuses/update.json",
            parameters: params,
            progress: nil,
            success: { (task: URLSessionDataTask, response: Any?) -> Void in
                completion(Tweet.init(dictionary: response as! NSDictionary), nil)
            },
            failure: { (task: URLSessionDataTask?, error: Error) -> Void in
                print("Error updating status.")
            }
        )
    }

    func retweetStatusWithParams(params: NSDictionary, completion: @escaping (_ tweet: Tweet?, _ error: Error?) -> Void) {
        post("1.1/statuses/retweet/\(params["id"]!).json",
            parameters: params,
            progress: nil,
            success: { (task: URLSessionDataTask, response: Any?) -> Void in
                completion(Tweet.init(dictionary: response as! NSDictionary), nil)
            },
            failure: { (task: URLSessionDataTask?, error: Error) -> Void in
                print("Error retweeting status.")
            }
        )
    }

    func favoritesCreateWithParams(params: NSDictionary, completion: @escaping (_ tweet: Tweet?, _ error: Error?) -> Void) {
        post("1.1/favorites/create.json",
            parameters: params,
            progress: nil,
            success: { (task: URLSessionDataTask, response: Any?) -> Void in
                // print("\(response)")
                completion(Tweet.init(dictionary: response as! NSDictionary), nil)
            },
            failure: { (task: URLSessionDataTask?, error: Error) -> Void in
                print("Error favoriting tweet.")
            }
        )
    }

    func favoritesDestroyWithParams(params: NSDictionary, completion: (_ tweet: Tweet?, _ error: Error?) -> Void) {
        post("1.1/favorites/destroy.json",
            parameters: params,
            progress: nil,
            success: { (task: URLSessionDataTask, response: Any?) -> Void in
                // print("\(response)")
            },
            failure: { (task: URLSessionDataTask?, error: Error) -> Void in
                print("Error unfavoriting tweet.")
            }
        )
    }

    func followingWithParams(params: NSDictionary?, completion: @escaping (_ users: [User]?, _ error: Error?) -> Void) {
        getUsersWithParams(params: params, forEndpoint: "1.1/friends/ids.json", completion: completion)
    }

    func followersWithParams(params: NSDictionary?, completion: @escaping (_ users: [User]?, _ error: Error?) -> Void) {
        getUsersWithParams(params: params, forEndpoint: "1.1/followers/ids.json", completion: completion)
    }

    private func getUsersWithParams(params: NSDictionary?, forEndpoint endpoint: String, completion: @escaping (_ users: [User]?, _ error: Error?) -> Void) {
        get(endpoint,
            parameters: params,
            progress: nil,
            success: { (task: URLSessionDataTask, response: Any?) -> Void in
                var userIDs = (response as! NSDictionary)["ids"] as! [Int]
                userIDs = userIDs.count <= 20 ? userIDs : Array(userIDs[0..<19])
                let topIDsString = userIDs.map({"\($0)"}).joined(separator: ",")
                self.get("1.1/users/lookup.json",
                    parameters: ["user_id": topIDsString],
                    progress: nil,
                    success: { (task: URLSessionDataTask, response: Any?) -> Void in
                        let users = User.usersWithArray(response as! [NSDictionary])
                        completion(users, nil)
                    },
                    failure: { (task: URLSessionDataTask?, error: Error) -> Void in
                        print("Error getting users.")
                    }
                )
            },
            failure: { (task: URLSessionDataTask?, error: Error) -> Void in
                print("Error getting following IDs.")
                completion(nil, error)
            }
        )
    }

    func openURL(url: URL) {
        fetchAccessToken(withPath: "oauth/access_token",
            method: "POST",
            requestToken: BDBOAuth1Credential(queryString: url.query),
            success: { (accessToken: BDBOAuth1Credential!) -> Void in
                TwitterClient.sharedInstance?.requestSerializer.saveAccessToken(accessToken)

                // Get current user info
                TwitterClient.sharedInstance?.get("1.1/account/verify_credentials.json",
                    parameters: nil,
                    progress: nil,
                    success: { (task: URLSessionDataTask, response: Any?) -> Void in
                        // print("\(response)")
                        let user = User(dictionary: response as! NSDictionary)
                        User.currentUser = user
                        self.loginCompletion?(user, nil)
                    },
                    failure: { (task: URLSessionDataTask?, error: Error) -> Void in
                        print("Error getting current user.")
                        self.loginCompletion?(nil, error)
                    }
                )
            },
            failure: { (error: Error!) -> Void in
                print("Failed to receive access token!")
                self.loginCompletion?(nil, error)
            }
        )
    }

}
