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
    
    //private lazy var analyticManager = AnalyticManager()
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    @IBAction func onContinueButtonTapped(_ sender: Any)
    {
        //analyticManager.trackEvent(event: .SIGN_UP_BUY_ON_WEB(email: email))
        openInSafari(url: Server.shared.OrderCardsURL())
    }
    
    @IBAction func onCallCustomerSupport(_ sender: Any)
    {
        openInSafari(url: Server.shared.SupportURL())
    }
    
    @IBAction func onBackButtonPressed(_ sender: Any)
    {
        self.navigationController?.fadeOut()
    }
}
