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
        Log_Add("pushLastViewController")
        updateCobranding()
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
    
    //restores expert imageURL in event user deleted app then re-installed
    func updateCobranding()
    {
        Log_Add("updateCobranding")
        if let contact = Contact.main()
        {
            if contact.pa_id != nil
            {
                if UserDefaults.standard.string(forKey: Constants.KEY_PRACTITIONER_IMAGE_URL) == nil
                {
                    Log_Add("logo not in UserDefaults")
                    ObjectStore.shared.get(type: Expert.self, id: contact.pa_id!)
                    { expert in
                        Log_Add("re-saving URL: \(String(describing: expert.logo_image_url))")
                        UserDefaults.standard.set(expert.logo_image_url, forKey: Constants.KEY_PRACTITIONER_IMAGE_URL)
                    }
                    onFailure:
                    {
                        Log_Add("LC: Failed to get expert")
                    }
                }
            }
        }
    }
}
