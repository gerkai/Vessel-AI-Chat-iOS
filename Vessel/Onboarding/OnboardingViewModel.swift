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

enum OnboardingState: Int
{
    case Initial
    case WelcomeGender
    case HeightWeight
    case BirthdaySelect
    case DietSelect
    case AllergySelect
    case ViewTerms
    case GoalsSelect
    case SingleGoalSelect
    case FinalOnboarding
    
    mutating func next()
    {
        self = OnboardingState(rawValue: rawValue + 1) ?? .Initial
    }
    
    mutating func back()
    {
        self = OnboardingState(rawValue: rawValue - 1) ?? .Initial
    }
}

class OnboardingViewModel
{
    var curState: OnboardingState = .Initial
    var userDiets: [Int] = []
    var userGender: Int?
    var userHeight: Double?
    var userWeight: Double?
    var userBirthdate: Date?
    var userWithheldBirthdate: Bool = false
    
    static func NextViewController() -> UIViewController
    {
        //MainContact is guaranteed
        let contact = Contact.main()!
        
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        if onboardingViewModel == nil
        {
            onboardingViewModel = OnboardingViewModel()
        }
        
        //increment to next state
        onboardingViewModel!.curState.next()
        
        if onboardingViewModel!.curState == .WelcomeGender
        {
            //show gender selector flow
            let vc = storyboard.instantiateViewController(withIdentifier: "OnboardingWelcomeViewController") as! OnboardingWelcomeViewController
            //let vc = storyboard.instantiateViewController(withIdentifier: "DietPreferencesViewController") as! DietPreferencesViewController
            vc.viewModel = onboardingViewModel
            return vc
        }
        else if onboardingViewModel!.curState == .HeightWeight
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "HeightWeightSelectViewController") as! HeightWeightSelectViewController
            vc.viewModel = onboardingViewModel
            return vc
        }
        else if onboardingViewModel!.curState == .BirthdaySelect
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "BirthdaySelectViewController") as! BirthdaySelectViewController
            vc.viewModel = onboardingViewModel
            return vc
        }
        else if onboardingViewModel!.curState == .DietSelect
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
    
    func setGender(gender: Int)
    {
        userGender = gender
        if let contact = Contact.main()
        {
            var genderString = Constants.GENDER_OTHER
            switch gender
            {
                case 0:
                    genderString = Constants.GENDER_MALE
                case 1:
                    genderString = Constants.GENDER_FEMALE
                default:
                    break
            }
            contact.gender = genderString
            ObjectStore.shared.ClientSave(contact)
        }
    }
    
    func setHeightWeight(height: Double, weight: Double)
    {
        userHeight = height
        userWeight = weight
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
        userBirthdate = birthdate
        if let contact = Contact.main()
        {
            if birthdate == nil
            {
                contact.birth_date = nil
                contact.flags |= Constants.DECLINED_BIRTH_DATE
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
    
    func defaultBirthDate() -> Date
    {
        let calendar = Calendar.current
        let averageAge = Constants.AVERAGE_AGE
        // set the initial year to current year - averageAge
        var dateComponents = calendar.dateComponents([.day, .month, .year], from: Date())
        
        if let year = dateComponents.year
        {
            dateComponents.year  = year - averageAge
        }
        if let date = calendar.date(from: dateComponents)
        {
            return date
        }
        //should always return a date above but just in case...
        return Date("2000-07-09") //arbitrary
    }
    
    func dietIsChecked(dietID: Int) -> Bool
    {
        var result = false
        for id in userDiets
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
                userDiets = []
            }
            else
            {
                //remove ID_NO_DIET from chosenDiets
                userDiets = userDiets.filter(){$0 != Constants.ID_NO_DIET}
            }
            userDiets.append(dietID)
        }
        else
        {
            //remove dietID from chosenDiets
            userDiets = userDiets.filter(){$0 != dietID}
        }
        
        //TODO: Update contact
        if let contact = Contact.main()
        {
            contact.diet_ids = userDiets
            ObjectStore.shared.ClientSave(contact)
        }
    }
    
    func backup()
    {
        onboardingViewModel!.curState.back()
    }
}


