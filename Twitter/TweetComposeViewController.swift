//
//  TweetComposeViewController.swift
//  Twitter
//
//  Created by Marc Anderson on 2/19/16.
//  Copyright © 2016 Marc Anderson. All rights reserved.
//

import UIKit

let userDidPostTweetNotification = "userDidPostTweetNotification"

class TweetComposeViewController: UIViewController {

    @IBOutlet weak var charactersRemainingLabel: UILabel!
    @IBOutlet weak var tweetButton: UIButton!
    @IBOutlet weak var inReplyToLabel: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!

    var tweet: Tweet?
    let tweetMaximumCharacterCount = 140

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "tweetTextDidChange", name: UITextViewTextDidChangeNotification, object: nil)

        tweetButton.enabled = false
        inReplyToLabel.text = nil

        if let tweet = tweet {
            if let name = tweet.user?.name, let screenName = tweet.user?.screenName {
                inReplyToLabel.text = "In reply to @\(name)"
                tweetTextView.text = "@\(screenName) "
                tweetTextDidChange()
            }
        }

        tweetTextView.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tweetTextDidChange() {
        let tweetCurrentCharacterCount = tweetTextView.text.characters.count
        let tweetRemainingCharacterCount = tweetMaximumCharacterCount - tweetCurrentCharacterCount
        charactersRemainingLabel.text = "\(tweetRemainingCharacterCount)"
        if tweetCurrentCharacterCount > 0 {
            tweetButton.enabled = true
            if tweetRemainingCharacterCount >= 0 {
                charactersRemainingLabel.textColor = UIColor.lightGrayColor()
                tweetButton.enabled = true
            } else {
                charactersRemainingLabel.textColor = UIColor.redColor()
                tweetButton.enabled = false
            }
        } else {
            tweetButton.enabled = false
        }
    }

    @IBAction func onTweet(sender: UIButton) {
        let params: NSMutableDictionary = ["status": tweetTextView.text]
        if let tweet = tweet {
            if let tweetID = tweet.tweetID {
                params["in_reply_to_status_id"] = tweetID
            }
        }
        TwitterClient.sharedInstance.updateStatusWithParams(params) { (tweet, error) -> Void in
            if tweet != nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    NSNotificationCenter.defaultCenter().postNotificationName(userDidPostTweetNotification, object: nil, userInfo: ["tweet": tweet!])
                    self.tweetTextView.resignFirstResponder()
                    self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
                })
            } else {
                print("Error tweeting.")
            }
        }
    }

    @IBAction func onCancel(sender: UIButton) {
        tweetTextView.resignFirstResponder()
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
