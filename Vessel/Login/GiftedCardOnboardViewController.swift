//
//  GiftedCardOnboardViewController.swift
//  vessel-ios
//
//  Created by Carson Whitsett on 5/3/2022.
//  Copyright © 2022 Vessel Health Inc. All rights reserved.
//

import UIKit

class GiftedCardOnboardViewController: UIViewController
{
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
        if let contact = ObjectStore.shared.getContact(id: Contact.MainID)
        {
            vc.initialFirstName = contact.first_name
            vc.initialLastName = contact.last_name
            vc.socialAuth = true
        }
        //analyticManager.trackEvent(event: .SIGN_UP_GIFTED_CONTINUE(email: email))
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
