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
    @IBOutlet weak var peeView: UIView!
    @IBOutlet weak var cupView: UIView!
    
    override func viewDidLoad()
    {
        peeView.alpha = 0.0
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        // TODO: Add analytics for viewed page
    }
    
    @IBAction func onBackButton()
    {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl)
    {
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
