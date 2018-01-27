//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by Marc Anderson on 2/19/16.
//  Copyright © 2016 Marc Anderson. All rights reserved.
//

import UIKit

protocol TweetDetailViewControllerDelegate: class {
    func tweetDetailViewControllerDidUpdateTweet()
}

class TweetDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var tweet: Tweet?
    var containerViewController: ContainerViewController!

    weak var delegate: TweetDetailViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onReplyTap(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Compose", bundle: nil)
        let tweetComposeVC = storyboard.instantiateViewController(withIdentifier: "TweetComposeViewController") as! TweetComposeViewController
        tweetComposeVC.tweet = tweet
        containerViewController.present(tweetComposeVC, animated: true, completion: nil)
    }
}

extension TweetDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TweetDetailCell") as! TweetDetailCell
            cell.delegate = self
            cell.tweet = tweet
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TweetStatsCell") as! TweetStatsCell
            cell.tweet = tweet
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TweetControlsCell") as! TweetControlsCell
            cell.delegate = self
            cell.tweet = tweet
            return cell
        }
    }
}

extension TweetDetailViewController: TweetDetailCellDelegate {
    func tweetCell(_ cell: TweetDetailCell, didTapProfileButton button: UIButton) {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let profileVC = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        profileVC.user = tweet!.user
        profileVC.hidesMenuButton = true
        navigationController?.pushViewController(profileVC, animated: true)
    }
}

extension TweetDetailViewController: TweetControlsCellDelegate {
    func didUpdateTweet(_ tweet: Tweet) {
        self.tweet = tweet
        tableView.reloadData()
        delegate?.tweetDetailViewControllerDidUpdateTweet()
    }
}
