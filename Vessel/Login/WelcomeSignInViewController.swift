//
//  WelcomeSignInViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 2/25/22.
//

import UIKit

class WelcomeSignInViewController: UIViewController
{
    @IBOutlet private weak var mindLabel: UILabel!
    let goals = [NSLocalizedString("focus", comment:""),
                 NSLocalizedString("energy", comment:""),
                 NSLocalizedString("immunity", comment:""),
                 NSLocalizedString("sleep", comment:""),
                 NSLocalizedString("body", comment:""),
                 NSLocalizedString("mood", comment:""),
                 NSLocalizedString("digestion", comment:""),
                 NSLocalizedString("beauty", comment:""),
                 NSLocalizedString("living", comment:"")]
    var goalIndex = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(updateGoals), userInfo: nil, repeats: true)
        mindLabel.text = goals[0]
        updateGoals()
    }
    
    @objc func updateGoals()
    {
        mindLabel.text = goals[goalIndex]
        mindLabel.pushTransition(1)
        mindLabel.fadeIn(duration: 1)
        mindLabel.fadeOut(duration: 2.0)
        goalIndex += 1
        if(goalIndex == goals.count)
        {
            goalIndex = 0
        }
    }
    
    @IBAction func onSignIn()
    {
        
    }
    
    @IBAction func onCreateAccount()
    {
        
    }
}
