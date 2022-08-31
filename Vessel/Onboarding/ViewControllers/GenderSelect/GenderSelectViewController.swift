//
//  GenderSelectViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 3/4/22.
//  Based on Onboarding Flow: https://www.notion.so/vesselhealth/Onboarding-79efd903aaf349098bf4e972bd9292cb

import UIKit

class GenderSelectViewController: UIViewController
{
    // MARK: - Views
    @IBOutlet private weak var segmentedControl: VesselSegmentedControl!
    
    // MARK: - Logic
    var viewModel = GenderSelectViewModel()
    var coordinator: OnboardingCoordinator?
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        print("📗 did load \(self)")
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        // TODO: Add analytics for viewed page
    }
    
    // MARK: - UI
    func setupUI()
    {
        if let gender = viewModel.userGender
        {
            segmentedControl.selectedSegmentIndex = gender
        }
    }
    
    // MARK: - Actions
    @IBAction func onGenderTapped()
    {
        viewModel.setGender(gender: segmentedControl.selectedSegmentIndex)
    }
    
    @IBAction func onBackTapped()
    {
        coordinator?.backup()
    }
    
    @IBAction func onNextTapped()
    {
        if viewModel.getGender() == nil
        {
            viewModel.setGender(gender: segmentedControl.selectedSegmentIndex)
        }
        coordinator?.pushNextViewController()
    }
    
    @IBAction func onPrivacyPolicyTapped()
    {
        openInSafari(url: Constants.privacyPolicyURL)
    }
}
