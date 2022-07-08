//
//  GenderSelectViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 3/4/22.
//  Based on Onboarding Flow: https://www.notion.so/vesselhealth/Onboarding-79efd903aaf349098bf4e972bd9292cb

import UIKit

class GenderSelectViewController: UIViewController
{
    @IBOutlet weak var segmentedControl: VesselSegmentedControl!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    @IBAction func backButton()
    {
        //self.navigationController?.popViewController(animated: true)
        navigationController?.fadeOut()
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
        if let contact = Contact.main()
        {
            contact.gender = genderString
            ObjectStore.shared.ClientSave(contact)
        }
        let vc = OnboardingNextViewController()
        //{
            //navigationController?.pushViewController(vc, animated: true)
            navigationController?.fadeTo(vc)
        /*}
        else
        {
            self.navigationController?.popToRootViewController(animated: true)
            Server.shared.logOut()
        }*/
    }
    
    @IBAction func privacyPolicyButton()
    {
        openInSafari(url: Constants.privacyPolicyURL)
    }
}
