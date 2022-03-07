//
//  NoTestCardOnboardViewController.swift
//  vessel-ios
//
//  Created by Mohamed El-Taweel on 26/05/2021.
//  Copyright © 2021 Vessel Health Inc. All rights reserved.
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
        self.navigationController?.popViewController(animated: true)
    }
}
