//
//  OnboardingCoordinator.swift
//  Vessel
//
//  Created by Carson Whitsett on 3/4/22.
//  Based on Onboarding Flow: https://www.notion.so/vesselhealth/Onboarding-79efd903aaf349098bf4e972bd9292cb
//
//  All business logic for the Onboarding Flow is handled here.
//  NextViewController chooses which viewController to show next in the onboarding process based on what fields of the main Contact contain data.
//  TODO: Ensure coordinator gets deallocated once onboarding flow is complete

import UIKit

//this enum determines the order the onboarding screens will appear
enum OnboardingState: Int
{
    case welcome
    case genderSelect
    case heightWeight
    case birthdaySelect
    case dietSelect
    case allergySelect
    case viewTerms
    case goalsSelect
    case mainGoalSelect
    case finalOnboarding
    case nextFlow
    
    mutating func next()
    {
        self = OnboardingState(rawValue: rawValue + 1) ?? .nextFlow
    }
    
    mutating func back()
    {
        self = OnboardingState(rawValue: rawValue - 1) ?? .welcome
    }
}

class OnboardingCoordinator
{
    private var curState: OnboardingState = .welcome
    private var navigationController: UINavigationController?
    
    private var genderViewModel: GenderSelectViewModel?
    private var heightWeightViewModel: HeightWeightSelectViewModel?
    private var birthdayViewModel: BirthdaySelectViewModel?
    private var dietViewModel: ItemPreferencesViewModel?
    private var allergiesViewModel: ItemPreferencesViewModel?
    private var goalsViewModel: ItemPreferencesViewModel?
    private var mainGoalViewModel: ItemPreferencesViewModel?
    
    //MARK: - Navigation
    static func pushInitialViewController(to navigationController: UINavigationController?)
    {
        //MainContact is guaranteed
        let contact = Contact.main()!
        if contact.gender == nil || contact.gender?.count == 0
        {
            let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "OnboardingWelcomeViewController") as! OnboardingWelcomeViewController
            vc.coordinator = OnboardingCoordinator()
            vc.coordinator?.navigationController = navigationController
            navigationController?.fadeTo(vc)
        }
        else
        {
            //if gender was chosen then we can assume all demographics were populated so skip onboarding
            //and go directly to MainTabBarController
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "MainTabBarController")
            navigationController?.fadeTo(vc)
        }
    }
    
    func pushNextViewController()
    {
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        
        //increment to next state
        curState.next()
    
        if curState == .welcome
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "OnboardingWelcomeViewController") as! OnboardingWelcomeViewController
            vc.coordinator = self
            navigationController?.fadeTo(vc)
        }
        else if curState == .genderSelect
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "GenderSelectViewController") as! GenderSelectViewController
            if let genderViewModel = genderViewModel
            {
                vc.viewModel = genderViewModel
            }
            else
            {
                genderViewModel = vc.viewModel
            }
            vc.coordinator = self
            navigationController?.fadeTo(vc)
        }
        else if curState == .heightWeight
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "HeightWeightSelectViewController") as! HeightWeightSelectViewController
            if let heightWeightViewModel = heightWeightViewModel
            {
                vc.viewModel = heightWeightViewModel
            }
            else
            {
                heightWeightViewModel = vc.viewModel
            }
            vc.coordinator = self
            navigationController?.fadeTo(vc)
        }
        else if curState == .birthdaySelect
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "BirthdaySelectViewController") as! BirthdaySelectViewController
            if let birthdayViewModel = birthdayViewModel
            {
                vc.viewModel = birthdayViewModel
            }
            else
            {
                birthdayViewModel = vc.viewModel
            }
            vc.coordinator = self
            navigationController?.fadeTo(vc)
        }
        else if curState == .dietSelect
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "ItemPreferencesViewController") as! ItemPreferencesViewController
            if let dietViewModel = dietViewModel
            {
                vc.viewModel = dietViewModel
            }
            else
            {
                dietViewModel = vc.viewModel
            }
            vc.coordinator = self
            vc.viewModel.titleText = NSLocalizedString("Diet", comment: "Title of Diet Preferences screen")
            vc.viewModel.subtext = NSLocalizedString("Do you follow any diets right now?", comment: "Subtext of Diet Preferences screen")
            vc.viewModel.type = .diet
            navigationController?.fadeTo(vc)
        }
        else if curState == .allergySelect
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "ItemPreferencesViewController") as! ItemPreferencesViewController
            if let allergiesViewModel = allergiesViewModel
            {
                vc.viewModel = allergiesViewModel
            }
            else
            {
                allergiesViewModel = vc.viewModel
            }
            vc.coordinator = self
            vc.viewModel.titleText = NSLocalizedString("Allergies", comment: "Title of Allergy Preferences screen")
            vc.viewModel.subtext = NSLocalizedString("Do you have any food allergies?", comment: "Subtext of Allergy Preferences screen")
            vc.viewModel.type = .allergy
            navigationController?.fadeTo(vc)
        }
        else if curState == .viewTerms
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "TermsViewController") as! TermsViewController
            vc.coordinator = self
            navigationController?.fadeTo(vc)
        }
        else if curState == .goalsSelect
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "ItemPreferencesViewController") as! ItemPreferencesViewController
            vc.coordinator = self
            if let goalsViewModel = goalsViewModel
            {
                vc.viewModel = goalsViewModel
            }
            else
            {
                goalsViewModel = vc.viewModel
            }
            vc.viewModel.titleText = NSLocalizedString("Goals", comment: "Title of Goal Preferences screen")
            vc.viewModel.subtext = NSLocalizedString("What are your top 3 wellness goals?", comment: "Subtext of Goal Preferences screen")
            vc.viewModel.type = .goals
            navigationController?.fadeTo(vc)
        }
        else if curState == .mainGoalSelect
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "ItemPreferencesViewController") as! ItemPreferencesViewController
            if let mainGoalViewModel = mainGoalViewModel
            {
                vc.viewModel = mainGoalViewModel
            }
            else
            {
                mainGoalViewModel = vc.viewModel
            }
            vc.coordinator = self
            vc.viewModel.titleText = NSLocalizedString("Goals", comment: "Title of Goal Preferences screen")
            vc.viewModel.subtext = NSLocalizedString("Please select one goal to focus on first.", comment: "Subtext of Goal Preferences screen")
            vc.viewModel.type = .mainGoal
            vc.viewModel.hideBackground = true
            vc.viewModel.userGoals = goalsViewModel?.userGoals ?? []
            navigationController?.fadeTo(vc)
        }
        else if curState == .finalOnboarding
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "OnboardingFinalViewController") as! OnboardingFinalViewController
            vc.mainGoal = mainGoalViewModel?.mainGoal
            vc.coordinator = self
            navigationController?.fadeTo(vc)
        }
        else
        {
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "MainTabBarController")
            navigationController?.fadeTo(vc)
            
            //save the data collected during onboarding
            saveDemographics()
        }
    }
    
    init()
    {
        if UserDefaults.standard.bool(forKey: Constants.KEY_PRINT_INIT_DEINIT)
        {
            print("Init Onboarding Coordinator")
        }
    }
    
    deinit
    {
        if UserDefaults.standard.bool(forKey: Constants.KEY_PRINT_INIT_DEINIT)
        {
            print("Dealloc Onboarding Coordinator")
        }
    }
    
    func backup()
    {
        curState.back()
        fadeOut()
    }
    
    func fadeOut()
    {
        navigationController?.fadeOut()
    }
    
    func saveDemographics()
    {
        if let gender = genderViewModel?.userGender
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
                if let userHeight = heightWeightViewModel?.userHeight,
                   let userWeight = heightWeightViewModel?.userWeight
                {
                    contact.height = userHeight
                    contact.weight = userWeight
                }
                
                //birthday
                if let birthdayViewModel = birthdayViewModel
                {
                    if birthdayViewModel.preferNotToShareBirthdate
                    {
                        contact.flags |= Constants.DECLINED_BIRTH_DATE
                    }
                    else
                    {
                        let formatter = DateFormatter()
                        formatter.dateFormat = Constants.SERVER_DATE_FORMAT
                        let strDate = formatter.string(from: birthdayViewModel.userBirthdate)
                        contact.birth_date = strDate
                    }
                }
                    
                //diets, allergies, goals
                if let dietViewModel = dietViewModel
                {
                    contact.diet_ids = dietViewModel.userDiets
                }
                if let allergiesViewModel = allergiesViewModel
                {
                    contact.allergy_ids = allergiesViewModel.userAllergies
                }
                
                if let goalsViewModel = goalsViewModel
                {
                    contact.goal_ids = goalsViewModel.userGoals
                }
                
                if let mainGoalViewModel = mainGoalViewModel
                {
                    contact.main_goal_id = mainGoalViewModel.mainGoal
                }
                
                ObjectStore.shared.ClientSave(contact)
            }
        }
    }
}
