//
//  TodayTabPopupViewController.swift
//  Vessel
//
//  Created by Nicolas Medina on 3/30/23.
//

import UIKit

class TodayTabPopupViewController: PopupViewController
{
    @IBOutlet weak var coachView: UIView!
    @IBOutlet weak var pointerFinger: UIImageView!
    
    static func create() -> TodayTabPopupViewController
    {
        let storyboard = UIStoryboard(name: "Results", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TodayTabPopupViewController") as! TodayTabPopupViewController
        
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
