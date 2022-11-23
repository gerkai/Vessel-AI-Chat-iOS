//
//  LoginCoordinator.swift
//  Vessel
//
//  Created by Carson Whitsett on 11/22/22.
//

import UIKit

class LoginCoordinator
{
    static let shared = LoginCoordinator()
    
    func pushLastViewController(to navigationController: UINavigationController?)
    {
        if contactFieldsValid()
        {
            //go straight to onboarding
            OnboardingCoordinator.pushInitialViewController(to: navigationController)
        }
        else
        {
            //ask user to fill out additional information
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "GiftedCardRegisterViewController") as! GiftedCardRegisterViewController
            navigationController?.fadeTo(vc)
        }
    }
    
    func contactFieldsValid() -> Bool
    {
        var valid = true
        let contact = Contact.main()!
        let firstName: String = contact.first_name ?? ""
        let lastName: String = contact.last_name ?? ""
        if !firstName.isValidName() || !lastName.isValidName()
        {
            valid = false
        }
        return valid
    }
}
