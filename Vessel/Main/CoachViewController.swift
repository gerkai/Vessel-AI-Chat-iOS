//
//  CoachViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 8/3/22.
//

import UIKit

class CoachViewController: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    @IBAction func invalidateToken()
    {
        Server.shared.invalidateAccessToken()
    }
}
