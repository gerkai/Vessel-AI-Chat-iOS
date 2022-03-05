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
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let contactID = Contact.MainID
        if let contact = ObjectStore.shared.getContact(id: contactID)
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
        var genderString = "o"
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            genderString = "m"
        case 1:
            genderString = "f"
        default:
            break
        }
        if var contact = ObjectStore.shared.getContact(id: Contact.MainID)
        {
            contact.gender = genderString
            ObjectStore.shared.ClientSave(contact)
        }
    }
    
    @IBAction func privacyPolicyButton()
    {
        openInSafari(url: Constants.privacyPolicyURL)
    }
}
