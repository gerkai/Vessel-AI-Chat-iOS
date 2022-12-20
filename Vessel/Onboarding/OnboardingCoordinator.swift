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
import Bugsee

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
    
    @Resolved private var analytics: Analytics
    
    //MARK: - Navigation
    static func pushInitialViewController(to navigationController: UINavigationController?)
    {
        //MainContact is guaranteed
        let contact = Contact.main()!
        
        //set Bugsee contact information
        if let email = contact.email
        {
            Bugsee.setEmail(email)
        }
        Bugsee.setAttribute("contact_id", value: contact.id)
        
        //if gender is nil, have user go through whole onboarding process
        if contact.gender == nil || contact.gender?.count == 0
        {
            let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "OnboardingWelcomeViewController") as! OnboardingWelcomeViewController
            vc.coordinator = OnboardingCoordinator()
            vc.coordinator?.navigationController = navigationController
            navigationController?.fadeTo(vc)
            //print("Onboarding Coordinator 1: Sending hide splash screen notification")
            NotificationCenter.default.post(name: .showSplashScreen, object: nil, userInfo: ["show": false])
        }
        else
        {
            //if gender was chosen then we can assume all demographics were populated so skip onboarding
            //and go directly to MainTabBarController
            
            //make sure our core objects are all up to date
            ObjectLoader.shared.loadCoreObjects(onDone:
            {
                //send splash fade notification
                WaterManager.shared.createWaterPlanIfNeeded()
                
                // TODO: Remove later, just for testing purposes
                //Print current progress for last week
                print("LAST WEEK PROGRESS WAS:")
                let progress = PlansManager.shared.getLastWeekPlansProgress()
                let dates = progress.keys.sorted(by: { $0 < $1 })
                for date in dates
                {
                    print("\(date): \(progress[date] ?? 0.0)")
                }
                
                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = mainStoryboard.instantiateViewController(withIdentifier: "MainTabBarController")
                navigationController?.fadeTo(vc)
                //print("Onboarding Coordinator 2: Sending hide splash screen notification")
                NotificationCenter.default.post(name: .showSplashScreen, object: nil, userInfo: ["show": false])
            })
        }
    }
    
    func pushNextViewController()
    {
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        
        //increment to next state
        curState.next()
    
        if curState == .welcome
        {
            //Separated load plans call because an issue with stored plans not having weekdays
            PlansManager.shared.loadPlans()
            
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
            vc.viewModel.subtext = NSLocalizedString("Select up to 3 wellness goals to work on.", comment: "Subtext of Goal Preferences screen")
            vc.viewModel.type = .goals
            navigationController?.fadeTo(vc)
        }
        else if curState == .finalOnboarding
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "OnboardingFinalViewController") as! OnboardingFinalViewController
            vc.coordinator = self
            navigationController?.fadeTo(vc)
        }
        else
        {
            // Implemented here because in AppDelegate's didFinishLaunchingWithOptions the access token is not set up yet so we wouldn't know what objects to load.
            ObjectLoader.shared.loadCoreObjects(onDone:
            {
                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = mainStoryboard.instantiateViewController(withIdentifier: "MainTabBarController")
                self.navigationController?.fadeTo(vc)
            })
            
            //save the data collected during onboarding
            saveDemographics()
        }
    }
    
    static func loadCoreObjects(onDone done: @escaping () -> Void)
    {
        ObjectStore.shared.getMostRecent(objectTypes: [Result.self, Food.self, Curriculum.self, Plan.self], onSuccess: {done()}, onFailure: {done()})
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
                
                analytics.setUserProperty(property: "Gender", value: genderString)
                
                //height / weight
                if let userHeight = heightWeightViewModel?.userHeight,
                   let userWeight = heightWeightViewModel?.userWeight
                {
                    contact.height = userHeight
                    contact.weight = userWeight
                    
                    analytics.setUserProperty(property: "Height", value: userHeight)
                    analytics.setUserProperty(property: "Weight", value: userWeight)
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
                        let formatter = Date.serverDateFormatter
                        let strDate = formatter.string(from: birthdayViewModel.userBirthdate)
                        contact.birth_date = strDate
                        
                        analytics.setUserProperty(property: "DOB", value: strDate)
                    }
                }
                    
                //diets, allergies, goals
                if let dietViewModel = dietViewModel
                {
                    contact.diet_ids = dietViewModel.userDiets
                    contact.setDietsAnalytics()
                }
                if let allergiesViewModel = allergiesViewModel
                {
                    contact.allergy_ids = allergiesViewModel.userAllergies
                    contact.setAllergiesAnalytics()
                }
                
                if let goalsViewModel = goalsViewModel
                {
                    contact.goal_ids = goalsViewModel.userGoals
                    contact.setGoalsAnalytics()
                }
                
                ObjectStore.shared.ClientSave(contact)
            }
        }
    }
}
