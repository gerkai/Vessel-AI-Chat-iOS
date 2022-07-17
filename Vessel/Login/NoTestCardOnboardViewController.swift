//
//  NoTestCardOnboardViewController.swift
//  vessel-ios
//
//  Created by Carson Whitsett on 3/26/2022
//  Copyright © 2022 Vessel Health Inc. All rights reserved.
//  Based on Login Flow: https://www.notion.so/vesselhealth/Login-2dbc7f76cf4c4953abd8b4aa7bc34bc5

import UIKit

class NoTestCardOnboardViewController: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        logPageViewed()
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
