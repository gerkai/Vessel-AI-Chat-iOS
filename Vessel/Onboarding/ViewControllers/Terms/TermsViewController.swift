//
//  TermsViewController.swift
//  vessel-ios
//
//  Created by Carson Whitsett on 2022-07-10.
//  Copyright © 2021 Vessel Health Inc. All rights reserved.
//

import UIKit

class TermsViewController: UIViewController, VesselScreenIdentifiable
{
    // MARK: - Views
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    // MARK: - Logic
    var allowNextButton = false
    var coordinator: OnboardingCoordinator?
    
    @Resolved internal var analytics: Analytics
    let flowName: AnalyticsFlowName = .onboardingFlow
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if UserDefaults.standard.bool(forKey: Constants.KEY_PRINT_INIT_DEINIT)
        {
            print("❇️ \(self)")
        }
    }
    
    deinit
    {
        if UserDefaults.standard.bool(forKey: Constants.KEY_PRINT_INIT_DEINIT)
        {
            print("❌ \(self)")
        }
    }
    
    override func viewDidLayoutSubviews()
    {
        if scrollView.isAtBottom
        {
            allowNextButton = true
        }
        else
        {
            allowNextButton = false
        }
        updateNextButton()
    }
    
    // MARK: - Actions
    @IBAction func onBackTapped(_ sender: Any)
    {
        coordinator?.backup()
    }
    
    @IBAction func onNextTapped()
    {
        if allowNextButton
        {
            coordinator?.pushNextViewController()
        }
        else
        {
            UIView.showError(text: "", detailText: NSLocalizedString("Please read the entire disclaimer", comment: "Error message when user hasn't yet made a selection"), image: nil)
        }
    }
    
    // MARK: - UI
    func updateNextButton()
    {
        if allowNextButton == true
        {
            nextButton.backgroundColor = Constants.vesselBlack
        }
        else
        {
            nextButton.backgroundColor = Constants.vesselGray
        }
    }
}

// MARK: - ScrollViewDelegate
extension TermsViewController: UIScrollViewDelegate
{
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        if scrollView.isAtBottom
        {
            if allowNextButton == false
            {
                allowNextButton = true
                updateNextButton()
            }
        }
    }
}
