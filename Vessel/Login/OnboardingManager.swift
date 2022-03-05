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
    var contact = MainContact!
    contact.gender = nil //cw temp
    
    if contact.gender == nil
    {
        //show gender selector
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "GenderSelectViewController") as! GenderSelectViewController
        return vc
    }
    return UIViewController()
}
