//
//  LastViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 3/5/22.
//  Temporary viewController at end of onboarding flow. Simply provides a logout button.

import UIKit

class LastViewController: UIViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logOut()
    {
        self.navigationController?.popToRootViewController(animated: true)
        Server.shared.logOut()
    }
}
