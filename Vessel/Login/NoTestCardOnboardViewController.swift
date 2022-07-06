//
//  NoTestCardOnboardViewController.swift
//  vessel-ios
//
//  Created by Carson Whitsett on 3/26/2022
//  Copyright © 2022 Vessel Health Inc. All rights reserved.
//

import UIKit

class NoTestCardOnboardViewController: UIViewController
{
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    @IBAction func onContinueButtonTapped(_ sender: Any)
    {
        openInSafari(url: Server.shared.QuizURL())
    }
    
    @IBAction func onBackButtonPressed(_ sender: Any)
    {
        self.navigationController?.fadeOut()
    }
}
