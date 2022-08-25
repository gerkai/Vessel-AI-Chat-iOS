//
//  OnboardingWelcomeViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 4/1/22.
//  Based on Onboarding Flow: https://www.notion.so/vesselhealth/Onboarding-79efd903aaf349098bf4e972bd9292cb

import UIKit

class OnboardingWelcomeViewController: OnboardingMVVMViewController
{
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if let contact = Contact.main()
        {
            let localizedGreeting = String(format: NSLocalizedString("Hi %@", comment: "Greeting by first name"), contact.first_name)
            nameLabel.text = localizedGreeting
        }
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        // TODO: Add analytics for viewed page
    }
    
    @IBAction func back()
    {
        navigationController?.fadeOut()
    }
    
    @IBAction func onContinue()
    {
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "GenderSelectViewController") as! GenderSelectViewController
        
        vc.viewModel = viewModel
        navigationController?.fadeTo(vc)
    }
}
