//
//  CropFailureSlideupViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 9/6/22.
//

import UIKit

protocol CropFailureSlideupViewControllerDelegate
{
    func invalidQRTryAgain()
}

class CropFailureSlideupViewController: SlideupViewController
{
    var delegate: CropFailureSlideupViewControllerDelegate?
    
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
