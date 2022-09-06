//
//  AlreadyScannedSlideupViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 9/6/22.
//

import UIKit

protocol AlreadyScannedSlideupViewControllerDelegate
{
    func alreadyScannedViewResults()
    func alreadyScannedScanNewCard()
}

class AlreadyScannedSlideupViewController: SlideupViewController
{
    var delegate: AlreadyScannedSlideupViewControllerDelegate?
    
    @IBAction func viewResults()
    {
        //TODO: RE-enable once viewResults functionality implemented
        /*
        dismissAnimation
        {
            self.delegate?.alreadyScannedViewResults()
        }*/
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
