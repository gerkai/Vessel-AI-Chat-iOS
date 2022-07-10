//
//  OnboardingViewModel.swift
//  Vessel
//
//  Created by Carson Whitsett on 3/4/22.
//  Based on Onboarding Flow: https://www.notion.so/vesselhealth/Onboarding-79efd903aaf349098bf4e972bd9292cb
//
//  All business logic for the Onboarding Flow is handled here.
//  NextViewController chooses which viewController to show next in the onboarding process based on what fields of the main Contact contain data.

import UIKit

var onboardingViewModel: OnboardingViewModel?

class OnboardingViewModel
{
    var chosenDiets: [Int] = []
    
    static func NextViewController() -> UIViewController
    {
        //MainContact is guaranteed
        let contact = Contact.main()!
        
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        if onboardingViewModel == nil
        {
            onboardingViewModel = OnboardingViewModel()
        }
        
        if contact.gender == nil || contact.gender == ""
        {
            //show gender selector flow
            let vc = storyboard.instantiateViewController(withIdentifier: "OnboardingWelcomeViewController") as! OnboardingWelcomeViewController
            //let vc = storyboard.instantiateViewController(withIdentifier: "DietPreferencesViewController") as! DietPreferencesViewController
            vc.viewModel = onboardingViewModel
            return vc
        }
        else if contact.height == nil
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "HeightWeightSelectViewController") as! HeightWeightSelectViewController
            vc.viewModel = onboardingViewModel
            return vc
        }
        else if contact.birth_date == nil
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "BirthdaySelectViewController") as! BirthdaySelectViewController
            vc.viewModel = onboardingViewModel
            return vc
        }
        else if contact.diet_ids.count == 0
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "DietPreferencesViewController") as! DietPreferencesViewController
            vc.viewModel = onboardingViewModel
            return vc
        }
        else
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "LastViewController") as! LastViewController
            return vc
        }
    }
    
    func setGender(gender: String)
    {
        if let contact = Contact.main()
        {
            contact.gender = gender
            ObjectStore.shared.ClientSave(contact)
        }
    }
    
    func setHeightWeight(height: Double, weight: Double)
    {
        if let contact = Contact.main()
        {
            contact.height = height
            contact.weight = weight
            ObjectStore.shared.ClientSave(contact)
        }
    }
    
    func setBirthDate(birthdate: Date?)
    {
        //can be set to nil if user prefers not to share their birthdate
        if let contact = Contact.main()
        {
            if birthdate == nil
            {
                contact.birth_date = nil
            }
            else
            {
                let formatter = DateFormatter()
                formatter.dateFormat = Constants.SERVER_DATE_FORMAT
                let strDate = formatter.string(from: birthdate!)
                contact.birth_date = strDate
            }
            ObjectStore.shared.ClientSave(contact)
        }
    }
    
    func dietIsChecked(dietID: Int) -> Bool
    {
        var result = false
        for id in chosenDiets
        {
            if id == dietID
            {
                result = true
            }
        }
        return result
    }
    
    func selectDiet(dietID: Int, selected: Bool)
    {
        //this will add/remove selected diets from the chosenDiets array based on selected parameter.
        //If user selects NO DIET then any previously selected diets are erased.
        //If user selects any diet while NO DIET is selected, then NO DIET will be cleared.
        if selected
        {
            //add dietID to chosenDiets
            if dietID == Constants.ID_NO_DIET
            {
                //clear any previously chosen diets
                chosenDiets = []
            }
            else
            {
                //remove ID_NO_DIET from chosenDiets
                chosenDiets = chosenDiets.filter(){$0 != Constants.ID_NO_DIET}
            }
            chosenDiets.append(dietID)
        }
        else
        {
            //remove dietID from chosenDiets
            chosenDiets = chosenDiets.filter(){$0 != dietID}
        }
        //TODO: Update contact
    }
}


