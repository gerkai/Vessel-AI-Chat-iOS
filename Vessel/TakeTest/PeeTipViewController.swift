//
//  PeeTipViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 7/12/22.
//

import UIKit

class PeeTipViewController: UIViewController
{
    @IBOutlet weak var hideTipSelectorView: SelectionCheckmarkView!
    @IBOutlet weak var mainStackView: UIStackView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if view.frame.height >= Constants.SMALL_SCREEN_HEIGHT_THRESHOLD
        {
            mainStackView.spacing = 32.0
        }
        hideTipSelectorView.textLabel.text = Constants.DONT_SHOW_AGAIN_STRING
    }
    
    @IBAction func back()
    {
        self.navigationController?.fadeOut()
    }
    
    @IBAction func next()
    {
        if hideTipSelectorView.isChecked
        {
            //MainContact is guaranteed
            let contact = Contact.main()!
            contact.flags |= Constants.HIDE_PEE_TIPS
        }
    }
}
