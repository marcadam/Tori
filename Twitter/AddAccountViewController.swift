//
//  AddAccountViewController.swift
//  Twitter
//
//  Created by Marc Anderson on 2/28/16.
//  Copyright © 2016 Marc Anderson. All rights reserved.
//

import UIKit

class AddAccountViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onCancel(sender: UIButton) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
