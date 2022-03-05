//
//  OnboardingManager.swift
//  Vessel
//
//  Created by Carson Whitsett on 3/4/22.
//

import UIKit

func OnboardingNextViewController() -> UIViewController
{
    //MainContact is guaranteed
    if let contact = ObjectStore.shared.getContact(id: Contact.MainID)
    {
        var mutableContact = contact
        mutableContact.gender = nil //cw temp
        
        if contact.gender == nil
        {
            //show gender selector
            let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "GenderSelectViewController") as! GenderSelectViewController
            return vc
        }
    }
    return UIViewController()
}
