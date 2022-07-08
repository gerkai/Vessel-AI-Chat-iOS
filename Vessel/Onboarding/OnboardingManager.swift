//
//  OnboardingManager.swift
//  Vessel
//
//  Created by Carson Whitsett on 3/4/22.
//  Based on Onboarding Flow: https://www.notion.so/vesselhealth/Onboarding-79efd903aaf349098bf4e972bd9292cb
//
//  Chooses which viewController to show next in the onboarding process based on what fields of the main Contact
//  contain data.

import UIKit

func OnboardingNextViewController() -> UIViewController
{
    //MainContact is guaranteed
    let contact = Contact.main()!
    
   //var contact = contact //cw temp
   //contact.birth_date = nil //cw temp
    let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
    
    if contact.gender == nil || contact.gender == ""
    {
        //show gender selector flow
        let vc = storyboard.instantiateViewController(withIdentifier: "OnboardingWelcomeViewController") as! OnboardingWelcomeViewController
        return vc
    }
    else if contact.height == nil
    {
        let vc = storyboard.instantiateViewController(withIdentifier: "HeightWeightSelectViewController") as! HeightWeightSelectViewController
        return vc
    }
    else if contact.birth_date == nil
    {
        let vc = storyboard.instantiateViewController(withIdentifier: "BirthdaySelectViewController") as! BirthdaySelectViewController
        return vc
    }
    /*else if contact.diets.count == 0
    {
        let vc = storyboard.instantiateViewController(withIdentifier: "DietPreferencesViewController") as! DietPreferencesViewController
        return vc
    }*/
    else
    {
        let vc = storyboard.instantiateViewController(withIdentifier: "LastViewController") as! LastViewController
        return vc
    }
}
