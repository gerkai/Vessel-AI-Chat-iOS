//
//  AlreadyScannedSlideupViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 9/6/22.
//

import UIKit

protocol AlreadyScannedSlideupViewControllerDelegate
{
    func alreadyScannedCustomerSupport()
    func alreadyScannedScanNewCard()
}

class AlreadyScannedSlideupViewController: SlideupViewController
{
    var delegate: AlreadyScannedSlideupViewControllerDelegate?
    var flowName: AnalyticsFlowName = .takeTestFlow
    @Resolved internal var analytics: Analytics
    
    @IBAction func chatWithSupport()
    {
        dismissAnimation
        {
            self.delegate?.alreadyScannedCustomerSupport()
        }
    }
    
    @IBAction func scanNewCard()
    {
        dismissAnimation
        {
            self.delegate?.alreadyScannedScanNewCard()
        }
    }
    
    @IBAction func onCancel()
    {
        scanNewCard()
    }
}
