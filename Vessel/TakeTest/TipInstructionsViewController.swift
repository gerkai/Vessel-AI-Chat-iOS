//
//  TipInstructionsViewController.swift
//  vessel-ios
//
//  Created by Mohamed El-Taweel on 13/04/2021.
//  Copyright © 2021 Vessel Health Inc. All rights reserved.
//

import UIKit

class TipInstructionsViewController: TakeTestMVVMViewController
{
    @IBOutlet private weak var peeView: UIView!
    @IBOutlet private weak var cupView: UIView!
    @IBOutlet private weak var segmentedControl: VesselSegmentedControl!
    
    var associatedValue: String?
    {
        if segmentedControl.selectedSegmentIndex == 0
        {
            return "Use A Cup"
        }
        else
        {
            return "Pee On The Card"
        }
    }
    
    override func viewDidLoad()
    {
        peeView.alpha = 0.0
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
    }
    
    @IBAction func onBackButton()
    {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl)
    {
        analytics.log(event: .viewedPage(screenName: String(describing: type(of: self)), flowName: flowName, associatedValue: associatedValue))
        if sender.selectedSegmentIndex == 0
        {
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .beginFromCurrentState)
            {
                self.cupView.alpha = 1.0
                self.peeView.alpha = 0.0
            } completion:
            { _ in
            }
        }
        else
        {
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .beginFromCurrentState)
            {
                self.cupView.alpha = 0.0
                self.peeView.alpha = 1.0
            } completion:
            { _ in
            }
        }
    }
}
