//
//  OnboardingViewModel.swift
//  Vessel
//
//  Created by Carson Whitsett on 3/4/22.
//  Based on Onboarding Flow: https://www.notion.so/vesselhealth/Onboarding-79efd903aaf349098bf4e972bd9292cb
//
//  All business logic for the Onboarding Flow is handled here.
//  NextViewController chooses which viewController to show next in the onboarding process based on what fields of the main Contact contain data.
//  TODO: Ensure viewModel gets deallocated once onboarding flow is complete

import UIKit

var onboardingViewModel: OnboardingViewModel?

//this enum determines the order the onboarding screens will appear
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

enum ItemPreferencesType
{
    case Diet
    case Allergy
    case Goal
}

class OnboardingViewModel
{
    var curState: OnboardingState = .Initial
    var userDiets: [Int] = []
    var userAllergies: [Int] = []
    var userGoals: [Int] = []
    var userGender: Int?
    var userHeight: Double?
    var userWeight: Double?
    var userBirthdate: Date?
    var userWithheldBirthdate: Bool = false
    
    //MARK: - navigation
    static func NextViewController() -> UIViewController
    {
        //MainContact is guaranteed
        
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
            //uncomment for testing to jump directly to desired VC
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
            let vc = storyboard.instantiateViewController(withIdentifier: "ItemPreferencesViewController") as! ItemPreferencesViewController
            vc.viewModel = onboardingViewModel
            vc.titleText = NSLocalizedString("Diet", comment:"Title of Diet Preferences screen")
            vc.subtext = NSLocalizedString("Do you follow any diets right now?", comment:"Subtext of Diet Preferences screen")
            vc.itemType = .Diet
            return vc
        }
        else if onboardingViewModel!.curState == .AllergySelect
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "ItemPreferencesViewController") as! ItemPreferencesViewController
            vc.viewModel = onboardingViewModel
            vc.titleText = NSLocalizedString("Allergies", comment:"Title of Allergy Preferences screen")
            vc.subtext = NSLocalizedString("Do you have any food allergies?", comment:"Subtext of Allergy Preferences screen")
            vc.itemType = .Allergy
            return vc
        }
        else if onboardingViewModel!.curState == .ViewTerms
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "TermsViewController") as! TermsViewController
            vc.viewModel = onboardingViewModel
            return vc
        }
        else if onboardingViewModel!.curState == .GoalsSelect
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "ItemPreferencesViewController") as! ItemPreferencesViewController
            vc.viewModel = onboardingViewModel
            vc.titleText = NSLocalizedString("Goals", comment:"Title of Goal Preferences screen")
            vc.subtext = NSLocalizedString("What are your top 3 wellness goals?", comment:"Subtext of Goal Preferences screen")
            vc.itemType = .Goal
            return vc
        }
        else
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "LastViewController") as! LastViewController
            return vc
        }
    }
    
    func backup()
    {
        onboardingViewModel!.curState.back()
    }
    
    //MARK: - gender
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
    
    //MARK: - height/weight
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
    
    //MARK: - birthdate
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
        //returns a date based on the average age of a member as defined in Constants
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
    
    //MARK: - preferenceItem (Diet, Allergy, Goal)
    func anyItemChecked(_ type: ItemPreferencesType) -> Bool
    {
        switch type
        {
        case .Diet:
            if userDiets.count == 0
            {
                return false
            }
            else
            {
                return true
            }
        case .Allergy:
            if userAllergies.count == 0
            {
                return false
            }
            else
            {
                return true
            }
        case .Goal:
            if userGoals.count < Constants.MAX_GOALS_AT_A_TIME
            {
                return false
            }
            else
            {
                return true
            }
        }
    }
    func infoForItemAt(indexPath: IndexPath, type: ItemPreferencesType) -> (name: String, id: Int)
    {
        let row = indexPath.row
        switch type
        {
            case .Diet:
                return (Diets[row].name.capitalized, Diets[row].id)
            case .Allergy:
                return (Allergies[row].name.capitalized, Allergies[row].id)
            case .Goal:
                return (Goals[row].name.capitalized, Goals[row].id)
        }
    }
    
    func itemCount(_ type: ItemPreferencesType) -> Int
    {
        switch type
        {
            case .Diet:
                return Diets.count
            case .Allergy:
                return Allergies.count
            case .Goal:
                return Goals.count
        }
    }
    func itemIsChecked(type: ItemPreferencesType, id: Int) -> Bool
    {
        var result = false
        switch type
        {
            case .Diet:
                for dietID in userDiets
                {
                    if dietID == id
                    {
                        result = true
                        break
                    }
                }
            case .Allergy:
                for allergyID in userAllergies
                {
                    if allergyID == id
                    {
                        result = true
                        break
                    }
                }
                
            case .Goal:
                for goalID in userGoals
                {
                    if goalID == id
                    {
                        result = true
                        break
                    }
                }
        }
        return result
    }
    
    func selectItem(type: ItemPreferencesType, id: Int, selected: Bool)
    {
        //this will add/remove selected items from the chosen[items] array based on selected parameter.
        //If user selects NONE then any previously selected items are erased.
        //If user selects any item while NONE is selected, then NONE will be cleared.
        switch type
        {
            case .Diet:
                if selected
                {
                    //add id to userDiets
                    if id == Constants.ID_NO_DIETS
                    {
                        //clear any previously chosen diets
                        userDiets = []
                    }
                    else
                    {
                        //remove ID_NO_DIET from chosenDiets
                        userDiets = userDiets.filter(){$0 != Constants.ID_NO_DIETS}
                    }
                    userDiets.append(id)
                }
                else
                {
                    //remove dietID from chosenDiets
                    userDiets = userDiets.filter(){$0 != id}
                }
                
                //TODO: Update contact
                if let contact = Contact.main()
                {
                    contact.diet_ids = userDiets
                    ObjectStore.shared.ClientSave(contact)
                }
            case .Allergy:
                
                if selected
                {
                    //add id to chosenDiets
                    if id == Constants.ID_NO_ALLERGIES
                    {
                        //clear any previously chosen ids
                        userAllergies = []
                    }
                    else
                    {
                        //remove ID_NO_ALLERGIES from userAllergies
                        userAllergies = userAllergies.filter(){$0 != Constants.ID_NO_ALLERGIES}
                    }
                    userAllergies.append(id)
                }
                else
                {
                    //remove id from chosenDiets
                    userAllergies = userAllergies.filter(){$0 != id}
                }
                
                //TODO: Update contact
                if let contact = Contact.main()
                {
                    contact.allergy_ids = userAllergies
                    ObjectStore.shared.ClientSave(contact)
                }
        case .Goal:
            if selected
            {
                //only allow maximum selected amount. If user selects more, delete the oldest
                if userGoals.count >= Constants.MAX_GOALS_AT_A_TIME
                {
                    userGoals.removeFirst()
                }
                //add id to chosenGoals
                userGoals.append(id)
            }
            else
            {
                //remove id from chosenGoals
                userGoals = userGoals.filter(){$0 != id}
            }
            
            //TODO: Update contact
            if let contact = Contact.main()
            {
                contact.allergy_ids = userAllergies
                ObjectStore.shared.ClientSave(contact)
            }
        }
    }
    
    func tooFewItemsSelectedText(type: ItemPreferencesType) -> String
    {
        let defaultText = NSLocalizedString("Please select an answer", comment:"Error message when user hasn't yet made a selection")
        switch type
        {
            case .Diet:
                return defaultText
            case .Allergy:
                return defaultText
            case .Goal:
                return NSLocalizedString("Please choose 3 goals", comment:"Error message when user hasn't chosen 3 goals")
        }
    }
    //MARK: - Terms
    
    func userViewedTerms()
    {
        if let contact = Contact.main()
        {
            contact.flags |= Constants.VIEWED_TERMS
            ObjectStore.shared.ClientSave(contact)
        }
    }
}


