//
//  CalibrationErrorSlideupViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 9/6/22.
//

import UIKit

protocol CalibrationErrorSlideupViewControllerDelegate
{
    func calibrationErrorCustomerSupport()
}

class CalibrationErrorSlideupViewController: SlideupViewController
{
    var delegate: CalibrationErrorSlideupViewControllerDelegate?
    var flowName: AnalyticsFlowName = .takeTestFlow
    @Resolved internal var analytics: Analytics
    
    @IBAction func customerSupport()
    {
        dismissAnimation
        {
            self.delegate?.calibrationErrorCustomerSupport()
        }
    }
    
    @IBAction func onCancel()
    {
        customerSupport()
    }
}
