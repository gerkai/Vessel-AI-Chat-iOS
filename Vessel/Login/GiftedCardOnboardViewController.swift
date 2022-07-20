//
//  GiftedCardOnboardViewController.swift
//  vessel-ios
//
//  Created by Carson Whitsett on 5/3/2022.
//  Copyright © 2022 Vessel Health Inc. All rights reserved.
//  Based on Login Flow: https://www.notion.so/vesselhealth/Login-2dbc7f76cf4c4953abd8b4aa7bc34bc5

import UIKit

class GiftedCardOnboardViewController: UIViewController
{
    @Resolved private var analytics: Analytics
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        analytics.log(event: .viewedPage(screenName: .gifted))
    }
    
    @IBAction func onBackButtonTapped(_ sender: Any)
    {
        self.navigationController?.fadeOut()
    }
    
    @IBAction func onContinueButtonTapped(_ sender: Any)
    {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "GiftedCardRegisterViewController") as! GiftedCardRegisterViewController
        /*if let contact = Contact.main()
        {
            vc.initialFirstName = contact.first_name
            vc.initialLastName = contact.last_name
            vc.socialAuth = true
        }*/
        //analyticManager.trackEvent(event: .SIGN_UP_GIFTED_CONTINUE(email: email))
        //self.navigationController?.pushViewController(vc, animated: true)
        self.navigationController?.fadeTo(vc)
    }
}
