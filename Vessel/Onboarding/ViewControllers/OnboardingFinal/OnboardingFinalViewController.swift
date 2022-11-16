//
//  OnboardingFinalViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 7/10/22.
//

import UIKit

class OnboardingFinalViewController: UIViewController, VesselScreenIdentifiable
{
    // MARK: - Views
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Logic
    var mainGoal: Int?
    var coordinator: OnboardingCoordinator?
    
    @Resolved internal var analytics: Analytics
    let flowName: AnalyticsFlowName = .onboardingFlow
        
    // MARK: - ViewController Lifecycle
    override func viewDidLoad()
    {
        titleLabel.text = finalScreenText()
        
        if UserDefaults.standard.bool(forKey: Constants.KEY_PRINT_INIT_DEINIT)
        {
            print("📗 did load \(self)")
        }
    }
    
    deinit
    {
        if UserDefaults.standard.bool(forKey: Constants.KEY_PRINT_INIT_DEINIT)
        {
            print("📘 deinit \(self)")
        }
    }
    
    // MARK: - Actions
    @IBAction func onBackTapped()
    {
        coordinator?.backup()
    }
    
    @IBAction func onNextTapped()
    {
        coordinator?.pushNextViewController()
    }
    
    // MARK: - Logic
    private func finalScreenText() -> String
    {
        let text = NSLocalizedString("We've designed a wellness plan personalized to your lifestyle.", comment: "")
        return text
    }
}
