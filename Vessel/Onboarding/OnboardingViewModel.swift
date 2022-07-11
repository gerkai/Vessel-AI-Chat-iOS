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
    case SingleGoal
}

class OnboardingViewModel
{
    //var curState: OnboardingState = .FinalOnboarding //uncomment to skip onboarding flow
    var curState: OnboardingState = .Initial
    var userDiets: [Int] = []
    var userAllergies: [Int] = []
    var userGoals: [Int] = []
    var mainGoal: Int?
    var userGender: Int?
    var userHeight: Double?
    var userWeight: Double?
    var userBirthdate: Date?
    var userWithheldBirthdate: Bool = false
    
    //MARK: - navigation
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
            if contact.gender == nil
            {
                //show gender selector flow
                let vc = storyboard.instantiateViewController(withIdentifier: "OnboardingWelcomeViewController") as! OnboardingWelcomeViewController
                vc.viewModel = onboardingViewModel
                return vc
            }
            else
            {
                //skip and go to next state
                onboardingViewModel!.curState.next()
            }
        }
        if onboardingViewModel!.curState == .HeightWeight
        {
            if contact.height == nil || contact.weight == nil
            {
                let vc = storyboard.instantiateViewController(withIdentifier: "HeightWeightSelectViewController") as! HeightWeightSelectViewController
                vc.viewModel = onboardingViewModel
                return vc
            }
            else
            {
                //skip and go to next state
                onboardingViewModel!.curState.next()
            }
        }
        if onboardingViewModel!.curState == .BirthdaySelect
        {
            if contact.birth_date == nil && (contact.flags & Constants.DECLINED_BIRTH_DATE) == 0
            {
                let vc = storyboard.instantiateViewController(withIdentifier: "BirthdaySelectViewController") as! BirthdaySelectViewController
                vc.viewModel = onboardingViewModel
                return vc
            }
            else
            {
                //skip and go to next state
                onboardingViewModel!.curState.next()
            }
        }
        if onboardingViewModel!.curState == .DietSelect
        {
            if contact.diet_ids.count == 0
            {
                let vc = storyboard.instantiateViewController(withIdentifier: "ItemPreferencesViewController") as! ItemPreferencesViewController
                vc.viewModel = onboardingViewModel
                vc.titleText = NSLocalizedString("Diet", comment:"Title of Diet Preferences screen")
                vc.subtext = NSLocalizedString("Do you follow any diets right now?", comment:"Subtext of Diet Preferences screen")
                vc.itemType = .Diet
                return vc
            }
            else
            {
                //skip and go to next state
                onboardingViewModel!.curState.next()
            }
        }
        if onboardingViewModel!.curState == .AllergySelect
        {
            if contact.allergy_ids.count == 0
            {
                let vc = storyboard.instantiateViewController(withIdentifier: "ItemPreferencesViewController") as! ItemPreferencesViewController
                vc.viewModel = onboardingViewModel
                vc.titleText = NSLocalizedString("Allergies", comment:"Title of Allergy Preferences screen")
                vc.subtext = NSLocalizedString("Do you have any food allergies?", comment:"Subtext of Allergy Preferences screen")
                vc.itemType = .Allergy
                return vc
            }
            else
            {
                //skip and go to next state
                onboardingViewModel!.curState.next()
            }
        }
        if onboardingViewModel!.curState == .ViewTerms
        {
            if contact.flags & Constants.VIEWED_TERMS == 0
            {
                let vc = storyboard.instantiateViewController(withIdentifier: "TermsViewController") as! TermsViewController
                vc.viewModel = onboardingViewModel
                return vc
            }
            else
            {
                //skip and go to next state
                onboardingViewModel!.curState.next()
            }
        }
        if onboardingViewModel!.curState == .GoalsSelect
        {
            if contact.goal_ids.count == 0
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
                //skip and go to next state
                onboardingViewModel!.curState.next()
            }
        }
        if onboardingViewModel!.curState == .SingleGoalSelect
        {
            if contact.mainGoal == nil
            {
                let vc = storyboard.instantiateViewController(withIdentifier: "ItemPreferencesViewController") as! ItemPreferencesViewController
                vc.viewModel = onboardingViewModel
                vc.titleText = NSLocalizedString("Goals", comment:"Title of Goal Preferences screen")
                vc.subtext = NSLocalizedString("Please select one goal to focus on first.", comment:"Subtext of Goal Preferences screen")
                vc.itemType = .SingleGoal
                return vc
            }
            else
            {
                //skip and go to next state
                onboardingViewModel!.curState.next()
            }
        }
        if onboardingViewModel!.curState == .FinalOnboarding
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "OnboardingFinalViewController") as! OnboardingFinalViewController
            vc.viewModel = onboardingViewModel
            return vc
        }
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        return vc
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
                return true
            case .Allergy:
                if userAllergies.count == 0
                {
                    return false
                }
                return true
            case .Goal:
                if userGoals.count < Constants.MAX_GOALS_AT_A_TIME
                {
                    return false
                }
                return true
            case .SingleGoal:
                if mainGoal == nil
                {
                    return false
                }
                return true
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
            case .SingleGoal:
                //search the 3 goals the user selected
                for goal in Goals
                {
                    if goal.id == userGoals[row]
                    {
                        return (goal.name.capitalized, userGoals[row])
                    }
                }
                //this will never get called
                return (Goals[0].name.capitalized, Goals[0].id)
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
            case .SingleGoal:
                return userGoals.count
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
            case .SingleGoal:
                if mainGoal != nil
                {
                    if mainGoal! == id
                    {
                        return true
                    }
                }
                return false
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
        case .SingleGoal:
            if selected
            {
                mainGoal = id
            }
            else
            {
                mainGoal = nil
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
            case .SingleGoal:
                return defaultText
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
    
    //MARK: - Final
    
    func finalScreenText() -> String
    {
        for goal in Goals
        {
            if goal.id == mainGoal
            {
                let text = String(format:NSLocalizedString("We've designed %@ program personalized to your lifestyle.", comment: ""), goal.nameWithArticle)
                return text
            }
        }
        //should never get here
        return ""
    }
}


