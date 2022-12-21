//
//  WellnessPopupViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 9/6/22.
//

import UIKit

class WellnessPopupViewController: PopupViewController
{
    @IBOutlet weak var wellnessView: UIView!
    @IBOutlet weak var wellnessTextLabel: UILabel!
    
    weak var viewModel: ResultsTabViewModel!
    
    static func createWith(viewModel: ResultsTabViewModel) -> WellnessPopupViewController
    {
        let storyboard = UIStoryboard(name: "Results", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "WellnessPopupViewController") as! WellnessPopupViewController
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad()
    {
        wellnessTextLabel.attributedText = viewModel.wellnessText(activeLink: false)
        wellnessView.alpha = 0.0
    }
    
    override func appearAnimations()
    {
        self.wellnessView.alpha = 1.0
    }
    
    override func dismissAnimations()
    {
       self.wellnessView.alpha = 0.0
    }
    
    @IBAction func gotIt()
    {
        dismissAnimation
        {
        }
    }
}
