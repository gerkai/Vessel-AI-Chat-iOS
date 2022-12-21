//
//  InsightsPopupViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 9/6/22.
//

import UIKit

protocol InsightsPopupViewControllerDelegate
{

}

class InsightsPopupViewController: PopupViewController
{
    var delegate: InsightsPopupViewControllerDelegate?
    
    @IBAction func scanNewCard()
    {
        dismissAnimation
        {
            
        }
    }
}
