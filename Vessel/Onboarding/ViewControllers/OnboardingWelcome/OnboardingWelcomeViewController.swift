//
//  OnboardingWelcomeViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 4/1/22.
//  Based on Onboarding Flow: https://www.notion.so/vesselhealth/Onboarding-79efd903aaf349098bf4e972bd9292cb

import UIKit

class OnboardingWelcomeViewController: UIViewController
{
    // MARK: - Views
    @IBOutlet private weak var nameLabel: UILabel!
    
    // MARK: - Logic
    var coordinator: OnboardingCoordinator?
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if UserDefaults.standard.bool(forKey: Constants.KEY_PRINT_INIT_DEINIT)
        {
            print("📗 did load \(self)")
        }
        
        if let contact = Contact.main()
        {
            let localizedGreeting = String(format: NSLocalizedString("Hi %@", comment: "Greeting by first name"), contact.first_name)
            nameLabel.text = localizedGreeting
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
        coordinator?.fadeOut()
    }
    
    @IBAction func onNextTapped()
    {
        coordinator?.pushNextViewController()
    }
}
