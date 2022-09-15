//
//  OnboardingFinalViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 7/10/22.
//

import UIKit

class OnboardingFinalViewController: UIViewController
{
    // MARK: - Views
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Logic
    var mainGoal: Int?
    var coordinator: OnboardingCoordinator?
        
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
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        // TODO: Add analytics for viewed page
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
