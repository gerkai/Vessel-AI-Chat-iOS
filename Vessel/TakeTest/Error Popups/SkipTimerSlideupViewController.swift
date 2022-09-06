//
//  SkipTimerSlideupViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 7/18/22.
//

import UIKit

protocol SkipTimerSlideupViewControllerDelegate
{
    func skipTimerSlideupDone(proceedToSkip: Bool)
}

class SkipTimerSlideupViewController: SlideupViewController
{
    var canceling = false
    
    var delegate: SkipTimerSlideupViewControllerDelegate?
    
    @IBAction func onContinue()
    {
        canceling = true
        dismissAnimation
        {
            self.delegate?.skipTimerSlideupDone(proceedToSkip: self.canceling)
        }
    }
    
    @IBAction func onCancel()
    {
        dismissAnimation
        {
            self.delegate?.skipTimerSlideupDone(proceedToSkip: self.canceling)
        }
    }
}
