//
//  DebugViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 2/25/22.
//

import UIKit
protocol DebugViewControllerDelegate: AnyObject
{
    func didChangeEnvironment(env: Int)
}

class DebugViewController: UIViewController
{
    @IBOutlet weak var environmentControl: UISegmentedControl!
    var savedEnvironment: Int!
    var delegate: DebugViewControllerDelegate?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        savedEnvironment = UserDefaults.standard.integer(forKey: Constants.environmentKey)
        environmentControl.selectedSegmentIndex = savedEnvironment
    }
    
    deinit
    {
        if environmentControl.selectedSegmentIndex != savedEnvironment
        {
            UserDefaults.standard.set(environmentControl.selectedSegmentIndex, forKey: Constants.environmentKey)
        }
    }
    
    @IBAction func onEnvironment(_ sender: UISegmentedControl)
    {
        delegate?.didChangeEnvironment(env: environmentControl.selectedSegmentIndex)
        switch sender.selectedSegmentIndex
        {
            case Constants.PROD_INDEX:
                print("PROD")
            case Constants.STAGING_INDEX:
                print("STAGING")
            default:
                print("DEV")
        }
    }
}
