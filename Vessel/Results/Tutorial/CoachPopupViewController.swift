//
//  CoachPopupViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 9/6/22.
//

import UIKit

class CoachPopupViewController: PopupViewController
{
    @IBOutlet weak var coachView: UIView!
    @IBOutlet weak var pointerFinger: UIImageView!
    
    static func create() -> CoachPopupViewController
    {
        let storyboard = UIStoryboard(name: "Results", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CoachPopupViewController") as! CoachPopupViewController
        
        return vc
    }
    
    override func viewDidLoad()
    {
        coachView.alpha = 0.0
    }
    override func appearAnimations()
    {
        self.coachView.alpha = 1.0
        self.pointerFinger.alpha = 1.0
    }
    
    override func dismissAnimations()
    {
        self.coachView.alpha = 0.0
        self.pointerFinger.alpha = 0.0
    }
    
    @IBAction func gotIt()
    {
        dismissAnimation
        {
        }
    }
}
