//
//  UploadErrorSlideupViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 9/6/22.
//

import UIKit

protocol UploadErrorSlideupViewControllerDelegate
{
    func invalidQRTryAgain()
}

class UploadErrorSlideupViewController: SlideupViewController
{
    var delegate: UploadErrorSlideupViewControllerDelegate?
    
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
