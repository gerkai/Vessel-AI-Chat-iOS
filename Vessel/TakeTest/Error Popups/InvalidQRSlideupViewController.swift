//
//  InvalidQRSlideupViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 9/6/22.
//

import UIKit

protocol InvalidQRSlideupViewControllerDelegate
{
    func invalidQRTryAgain()
}

class InvalidQRSlideupViewController: SlideupViewController
{
    var delegate: InvalidQRSlideupViewControllerDelegate?
    
    @IBAction func tryAgain()
    {
        dismissAnimation
        {
            self.delegate?.invalidQRTryAgain()
        }
    }
    
    @IBAction func onCancel()
    {
        tryAgain()
    }
}
