//
//  GenderSelectViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 3/4/22.
//  Based on Onboarding Flow: https://www.notion.so/vesselhealth/Onboarding-79efd903aaf349098bf4e972bd9292cb

import UIKit

class GenderSelectViewController: UIViewController
{
    @IBOutlet weak var segmentedControl: VesselSegmentedControl!
    var viewModel: OnboardingViewModel?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    @IBAction func backButton()
    {
        navigationController?.fadeOut()
    }
    
    @IBAction func continueButton()
    {
        var genderString = Constants.GENDER_OTHER
        switch segmentedControl.selectedSegmentIndex
        {
            case 0:
                genderString = Constants.GENDER_MALE
            case 1:
                genderString = Constants.GENDER_FEMALE
            default:
                break
        }
        
        viewModel?.setGender(gender: genderString)
        
        let vc = OnboardingViewModel.NextViewController()
        navigationController?.fadeTo(vc)
    }
    
    @IBAction func privacyPolicyButton()
    {
        openInSafari(url: Constants.privacyPolicyURL)
    }
}
