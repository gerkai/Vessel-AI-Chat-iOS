//
//  CongratsPopupViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 9/6/22.
//

import UIKit

protocol CongratsPopupViewControllerDelegate
{

}

class CongratsPopupViewController: PopupViewController
{
    var delegate: CongratsPopupViewControllerDelegate?
    
    @IBAction func scanNewCard()
    {
        dismissAnimation
        {
            
        }
    }
}
