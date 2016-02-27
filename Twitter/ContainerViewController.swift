//
//  ContainerViewController.swift
//  Twitter
//
//  Created by Marc Anderson on 2/23/16.
//  Copyright © 2016 Marc Anderson. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {

    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewLeadingConstraint: NSLayoutConstraint!

    var originalContentViewLeadingConstraint: CGFloat!
    var menuOpen = false

    var menuViewController: UIViewController! {
        didSet {
            view.layoutIfNeeded()
            menuView.addSubview(menuViewController.view)
        }
    }
    var contentViewController: UIViewController! {
        didSet(oldContentViewController) {
            view.layoutIfNeeded()

            if oldContentViewController != nil {
                oldContentViewController.willMoveToParentViewController(nil)
                oldContentViewController.view.removeFromSuperview()
                oldContentViewController.didMoveToParentViewController(nil)
            }

            contentViewController.willMoveToParentViewController(self)
            contentView.addSubview(contentViewController.view)
            contentViewController.didMoveToParentViewController(self)

            UIView.animateWithDuration(0.3) { () -> Void in
                self.contentViewLeadingConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
            menuOpen = false
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let menuStoryboard = UIStoryboard(name: "Menu", bundle: nil)

        let menuNC = menuStoryboard.instantiateViewControllerWithIdentifier("MenuNavigationController") as! UINavigationController
        Utils.configureDefaultNavigationBar(menuNC.navigationBar)
        let menuTVC = menuNC.topViewController as! MenuTableViewController
        menuTVC.containerViewController = self

        let tweetsNC = mainStoryboard.instantiateViewControllerWithIdentifier("TweetsNavigationController") as! UINavigationController
        Utils.configureDefaultNavigationBar(tweetsNC.navigationBar)
        let tweetsVC = tweetsNC.topViewController as! TweetsViewController
        tweetsVC.delegate = self
        tweetsVC.containerViewController = self

        menuViewController = menuNC
        menuTVC.containerViewController = self
        contentViewController = tweetsNC
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPanGesture(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(view)
        let velocity = sender.velocityInView(view)

        if sender.state == .Began {
            originalContentViewLeadingConstraint = contentViewLeadingConstraint.constant
        } else if sender.state == .Changed {
            contentViewLeadingConstraint.constant = originalContentViewLeadingConstraint + translation.x
        } else if sender.state == .Ended {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                if velocity.x > 0 {
                    self.contentViewLeadingConstraint.constant = self.view.frame.size.width - 50
                    self.menuOpen = true
                } else {
                    self.contentViewLeadingConstraint.constant = 0
                    self.menuOpen = false
                }
                self.view.layoutIfNeeded()
            })
        }
    }
}

extension ContainerViewController: TweetsViewControllerDelegate, ProfileViewControllerDelegate {
    private func toggleMenu() {
        originalContentViewLeadingConstraint = contentViewLeadingConstraint.constant
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            if self.menuOpen {
                self.contentViewLeadingConstraint.constant = 0
                self.menuOpen = false
            } else {
                self.contentViewLeadingConstraint.constant = self.view.frame.size.width - 50
                self.menuOpen = true
            }
            self.view.layoutIfNeeded()
        })
    }

    func tweetView(tweetView: TweetsViewController, didTapMenuButton: UIBarButtonItem) {
        toggleMenu()
    }

    func profileView(profileView: ProfileViewController, didTapMenuButton: UIBarButtonItem) {
        toggleMenu()
    }
}
