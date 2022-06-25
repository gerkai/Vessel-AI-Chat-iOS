//
//  OnboardingWelcomeViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 4/1/22.
//

import UIKit

class OnboardingWelcomeViewController: UIViewController
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
    
    @IBAction func back()
    {
        navigationController?.fadeOut()
    }
    
    @IBAction func onContinue()
    {
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "GenderSelectViewController") as? GenderSelectViewController
        //if let vc = OnboardingNextViewController()
        {
            //navigationController?.pushViewController(vc, animated: true)
            navigationController?.fadeTo(vc)
        }
        else
        {
            self.navigationController?.popToRootViewController(animated: true)
            Server.shared.logOut()
        }
    }
}
