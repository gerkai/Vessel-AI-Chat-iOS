//
//  GiftedCardOnboardViewController.swift
//  vessel-ios
//
//  Created by Mohamed El-Taweel on 05/25/2021.
//  Copyright © 2021 Vessel Health Inc. All rights reserved.
//

import UIKit

class GiftedCardOnboardViewController: UIViewController
{

    var socialAuth: Bool = false
    var email: String = ""
    var firstName: String = ""
    var lastName: String = ""
    //private lazy var analyticManager = AnalyticManager()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    @IBAction func openVesselLink(_ sender: Any)
    {
        //analyticManager.trackEvent(event: .SIGN_GIFT_BECOME_A_MEMBER_LINK(email: email))
        openInSafari(url: Server.shared.OrderCardsURL())
    }
    
    @IBAction func onBackButtonTapped(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onContinueButtonTapped(_ sender: Any)
    {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "GiftedCardRegisterViewController") as! GiftedCardRegisterViewController
        vc.socialAuth = socialAuth
        vc.email = email
        vc.firstName = firstName
        vc.lastName = lastName
        //analyticManager.trackEvent(event: .SIGN_UP_GIFTED_CONTINUE(email: email))
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
