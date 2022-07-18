//
//  GenderSelectViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 3/4/22.
//  Based on Onboarding Flow: https://www.notion.so/vesselhealth/Onboarding-79efd903aaf349098bf4e972bd9292cb

import UIKit

class GenderSelectViewController: OnboardingMVVMViewController
{
    @IBOutlet weak var segmentedControl: VesselSegmentedControl!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if let gender = viewModel?.userGender
        {
            segmentedControl.selectedSegmentIndex = gender
        }
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        logPageViewed()
    }
    
    @IBAction func backButton()
    {
        navigationController?.fadeOut()
    }
    
    @IBAction func continueButton()
    {
        viewModel?.setGender(gender: segmentedControl.selectedSegmentIndex)
        
        let vc = OnboardingViewModel.NextViewController()
        navigationController?.fadeTo(vc)
    }
    
    @IBAction func privacyPolicyButton()
    {
        openInSafari(url: Constants.privacyPolicyURL)
    }
}
