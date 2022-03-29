//
//  GenderSelectViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 3/4/22.
//

import UIKit

class GenderSelectViewController: UIViewController
{
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var segmentedControl: VesselSegmentedControl!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if let contact = Contact.main()
        {
            let localizedGreeting = String(format: NSLocalizedString("Hi %@", comment: "Greeting by first name"), contact.first_name)
            nameLabel.text = localizedGreeting
        }
    }
    
    @IBAction func backButton()
    {
        self.navigationController?.popViewController(animated: true)
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
        if var contact = Contact.main()
        {
            contact.gender = genderString
            ObjectStore.shared.ClientSave(contact)
        }
        let vc = OnboardingNextViewController()
        //navigationController?.pushViewController(vc, animated: true)
        navigationController?.fadeTo(vc)
    }
    
    @IBAction func privacyPolicyButton()
    {
        openInSafari(url: Constants.privacyPolicyURL)
    }
}
