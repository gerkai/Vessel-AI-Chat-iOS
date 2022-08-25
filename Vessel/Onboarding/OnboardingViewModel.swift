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

//this enum determines the order the onboarding screens will appear
enum OnboardingState: Int
{
    case WelcomeGender
    case HeightWeight
    case BirthdaySelect
    case DietSelect
    case AllergySelect
    case ViewTerms
    case GoalsSelect
    case SingleGoalSelect
    case FinalOnboarding
    case NextFlow
    
    mutating func next()
    {
        self = OnboardingState(rawValue: rawValue + 1) ?? .NextFlow
    }
    
    mutating func back()
    {
        self = OnboardingState(rawValue: rawValue - 1) ?? .WelcomeGender
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
    var curState: OnboardingState = .WelcomeGender
    var userDiets: [Int] = []
    var userAllergies: [Int] = []
    var userGoals: [Int] = []
    var mainGoal: Goal.ID?
    var userGender: Int?
    var userHeight: Double = Double(Constants.DEFAULT_HEIGHT)
    var userWeight: Double?
    var userBirthdate: Date = Date.defaultBirthDate()
    var preferNotToShareBirthdate: Bool = false
    
    //MARK: - navigation
    static func InitialViewController() -> UIViewController
    {
        //MainContact is guaranteed
        let contact = Contact.main()!
        if contact.gender == nil || contact.gender?.count == 0
        {
            let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "OnboardingWelcomeViewController") as! OnboardingWelcomeViewController
            vc.viewModel = OnboardingViewModel()
            return vc
        }
        else
        {
            //if gender was chosen then we can assume all demographics were populated so skip onboarding
            //and go directly to MainTabBarController
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "MainTabBarController")
            return vc
        }
    }
    
    func nextViewController() -> UIViewController
    {
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        
        //increment to next state
        curState.next()
    
        if curState == .WelcomeGender
        {
            //show gender selector flow
            let vc = storyboard.instantiateViewController(withIdentifier: "OnboardingWelcomeViewController") as! OnboardingWelcomeViewController
            vc.viewModel = self
            return vc
        }
        else if curState == .HeightWeight
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "HeightWeightSelectViewController") as! HeightWeightSelectViewController
            vc.viewModel = self
            return vc
        }
        else if curState == .BirthdaySelect
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "BirthdaySelectViewController") as! BirthdaySelectViewController
            vc.viewModel = self
            return vc
        }
        else if curState == .DietSelect
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "ItemPreferencesViewController") as! ItemPreferencesViewController
            vc.viewModel = self
            vc.titleText = NSLocalizedString("Diet", comment: "Title of Diet Preferences screen")
            vc.subtext = NSLocalizedString("Do you follow any diets right now?", comment: "Subtext of Diet Preferences screen")
            vc.itemType = .Diet
            return vc
        }
        else if curState == .AllergySelect
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "ItemPreferencesViewController") as! ItemPreferencesViewController
            vc.viewModel = self
            vc.titleText = NSLocalizedString("Allergies", comment: "Title of Allergy Preferences screen")
            vc.subtext = NSLocalizedString("Do you have any food allergies?", comment: "Subtext of Allergy Preferences screen")
            vc.itemType = .Allergy
            return vc
        }
        else if curState == .ViewTerms
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "TermsViewController") as! TermsViewController
            vc.viewModel = self
            return vc
        }
        else if curState == .GoalsSelect
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "ItemPreferencesViewController") as! ItemPreferencesViewController
            vc.viewModel = self
            vc.titleText = NSLocalizedString("Goals", comment: "Title of Goal Preferences screen")
            vc.subtext = NSLocalizedString("What are your top 3 wellness goals?", comment: "Subtext of Goal Preferences screen")
            vc.itemType = .Goal
            return vc
        }
        else if curState == .SingleGoalSelect
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "ItemPreferencesViewController") as! ItemPreferencesViewController
            vc.viewModel = self
            vc.titleText = NSLocalizedString("Goals", comment: "Title of Goal Preferences screen")
            vc.subtext = NSLocalizedString("Please select one goal to focus on first.", comment: "Subtext of Goal Preferences screen")
            vc.itemType = .SingleGoal
            vc.hideBackground = true
            return vc
        }
        else if curState == .FinalOnboarding
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "OnboardingFinalViewController") as! OnboardingFinalViewController
            vc.viewModel = self
            return vc
        }

        //save the data collected during onboarding
        saveDemographics()
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "MainTabBarController")
        return vc
    }
    
    init()
    {
        print("Init Onboarding View Model")
    }
    
    deinit
    {
        print("Dealloc Onboarding View Model")
    }
    
    func backup()
    {
        curState.back()
    }
    
    //MARK: - gender
    func getGender() -> Int?
    {
        return userGender
    }
    
    func setGender(gender: Int)
    {
        userGender = gender
    }
    
    //MARK: - height/weight
    func getHeightWeight() -> (height: Double, weight: Double?)
    {
        return (userHeight, userWeight)
    }
    
    func setHeightWeight(height: Double, weight: Double)
    {
        userHeight = height
        userWeight = weight
    }
    
    //MARK: - birthdate
    func getBirthDate() -> (date: Date, preferNotToSay: Bool)
    {
        return (userBirthdate, preferNotToShareBirthdate)
    }
    
    func setBirthDate(birthDate: Date, preferNotToSay: Bool)
    {
        userBirthdate = birthDate
        preferNotToShareBirthdate = preferNotToSay
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
    func infoForItemAt(indexPath: IndexPath, type: ItemPreferencesType) -> (name: String, id: Int, image: UIImage?)
    {
        let row = indexPath.row
        switch type
        {
            case .Diet:
                let dietID = Diet.ID.allCases[row]
                return (Diets[dietID]!.name.capitalized, dietID.rawValue, image: nil)
            case .Allergy:
                let allergyID = Allergy.ID.allCases[row]
                return (Allergies[allergyID]!.name.capitalized, allergyID.rawValue, image: nil)
            case .Goal:
                let goalID = Goal.ID.allCases[row]
                return (Goals[goalID]!.name.capitalized, goalID.rawValue, image: nil)
            case .SingleGoal:
                //search the 3 goals the user selected
                let goalID = Goal.ID.allCases[userGoals[row]]
                return (Goals[goalID]!.name.capitalized, goalID.rawValue, UIImage.init(named: Goals[goalID]!.imageName))
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
                    if mainGoal!.rawValue == id
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

        case .SingleGoal:
            if selected
            {
                let goalID = Goal.ID.allCases[id]
                mainGoal = goalID
            }
            else
            {
                mainGoal = nil
            }
        }
    }
    
    func tooFewItemsSelectedText(type: ItemPreferencesType) -> String
    {
        let defaultText = NSLocalizedString("Please select an answer", comment: "Error message when user hasn't yet made a selection")
        switch type
        {
            case .Diet:
                return defaultText
            case .Allergy:
                return defaultText
            case .Goal:
                return NSLocalizedString("Please choose 3 goals", comment: "Error message when user hasn't chosen 3 goals")
            case .SingleGoal:
                return defaultText
        }
    }
    
    //MARK: - Final
    
    func finalScreenText() -> String
    {
        if mainGoal != nil
        {
            let text = String(format: NSLocalizedString("We've designed %@ program personalized to your lifestyle.", comment: ""), Goals[mainGoal!]!.nameWithArticle)
            return text
        }
        //should never get here
        return ""
    }
    
    func saveDemographics()
    {
        if let gender = userGender
        {
            if let contact = Contact.main()
            {
                //gender
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
                
                //height / weight
                contact.height = userHeight
                contact.weight = userWeight
                
                //birthday
                let formatter = DateFormatter()
                formatter.dateFormat = Constants.SERVER_DATE_FORMAT
                let strDate = formatter.string(from: userBirthdate)
                contact.birth_date = strDate
                
                if preferNotToShareBirthdate
                {
                    contact.flags |= Constants.DECLINED_BIRTH_DATE
                }
                
                //diets, allergies, goals
                contact.diet_ids = userDiets
                contact.allergy_ids = userAllergies
                contact.goal_ids = userGoals
                contact.main_goal_id = mainGoal?.rawValue
                
                ObjectStore.shared.ClientSave(contact)
            }
        }
    }
}
