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

    var menuViewController: UIViewController! {
        didSet {
            view.layoutIfNeeded()
            menuView.addSubview(menuViewController.view)
        }
    }
    var contentViewController: UIViewController! {
        didSet {
            view.layoutIfNeeded()
            contentView.addSubview(contentViewController.view)
            UIView.animateWithDuration(0.3) { () -> Void in
                self.contentViewLeadingConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let menuStoryboard = UIStoryboard(name: "Menu", bundle: nil)

        let menuNC = menuStoryboard.instantiateViewControllerWithIdentifier("MenuNavigationController") as? UINavigationController
        let menuTVC = menuNC?.topViewController as! MenuTableViewController

        let tweetsNC = mainStoryboard.instantiateViewControllerWithIdentifier("TweetsNavigationController") as! UINavigationController
        Utils.configureDefaultNavigationBar(tweetsNC.navigationBar)

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
                    self.contentViewLeadingConstraint.constant = self.view.frame.size.width - 44
                } else {
                    self.contentViewLeadingConstraint.constant = 0
                }
                self.view.layoutIfNeeded()
            })
        }
    }
}
