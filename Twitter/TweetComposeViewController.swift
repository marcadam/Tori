//
//  TweetComposeViewController.swift
//  Twitter
//
//  Created by Marc Anderson on 2/19/16.
//  Copyright © 2016 Marc Anderson. All rights reserved.
//

import UIKit

let userDidPostTweetNotification = Notification.Name("userDidPostTweetNotification")

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
        NotificationCenter.default.addObserver(self, selector: #selector(tweetTextDidChange), name: NSNotification.Name.UITextViewTextDidChange, object: nil)

        tweetButton.isEnabled = false
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

    @objc func tweetTextDidChange() {
        let tweetCurrentCharacterCount = tweetTextView.text.count
        let tweetRemainingCharacterCount = tweetMaximumCharacterCount - tweetCurrentCharacterCount
        charactersRemainingLabel.text = "\(tweetRemainingCharacterCount)"
        if tweetCurrentCharacterCount > 0 {
            tweetButton.isEnabled = true
            if tweetRemainingCharacterCount >= 0 {
                charactersRemainingLabel.textColor = UIColor.lightGray
                tweetButton.isEnabled = true
            } else {
                charactersRemainingLabel.textColor = UIColor.red
                tweetButton.isEnabled = false
            }
        } else {
            tweetButton.isEnabled = false
        }
    }

    @IBAction func onTweet(_ sender: UIButton) {
        let params: NSMutableDictionary = ["status": tweetTextView.text]
        if let tweet = tweet {
            if let tweetID = tweet.tweetID {
                params["in_reply_to_status_id"] = tweetID
            }
        }
        TwitterClient.sharedInstance?.updateStatusWithParams(params: params) { (tweet, error) -> Void in
            if tweet != nil {
                DispatchQueue.main.async(execute: { () -> Void in
                    NotificationCenter.default.post(name: userDidPostTweetNotification, object: nil, userInfo: ["tweet": tweet!])
                    self.tweetTextView.resignFirstResponder()
                    self.presentingViewController?.dismiss(animated: true, completion: nil)
                })
            } else {
                print("Error tweeting.")
            }
        }
    }

    @IBAction func onCancel(_ sender: UIButton) {
        tweetTextView.resignFirstResponder()
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
