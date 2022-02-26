//
//  SignupEmailCheckingViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 2/25/22.
//

import UIKit

class SignupEmailCheckingViewController: UIViewController
{
    @IBOutlet weak var googleAuthButton: UIButton!
    @IBOutlet weak var appleAuthButton: UIButton!
    @IBOutlet var formFields: [UITextField]!
    
    static let websiteURL = "https://vesselhealth.com/pages"
    static let privacyPolicyURL = "\(websiteURL)/privacy-policy.html"
    static let termsOfServiceURL = "\(websiteURL)/terms-of-service.html"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    
    @IBAction func onBackButtonPressed(_ sender: Any)
    {
        //self.navigationController?.popViewController(animated: true)
        self.navigationController?.fadeOut()
    }
    
    @IBAction func googleAuthAction(_ sender: Any)
    {
       // googleLogin()
    }
    
    @IBAction func appleAuthAction(_ sender: Any)
    {
       // appleLogin()
    }
    
    @IBAction func onPrivacyButtonTapped(_ sender: Any)
    {
        openInSafari(url: Constants.privacyPolicyURL)
    }
    
    @IBAction func onTermsButtonTapped(_ sender: Any)
    {
        openInSafari(url: Constants.termsOfServiceURL)
    }
    
    @IBAction func onContinueButtonTapped(_ sender: Any)
    {
        //checkEmail()
    }
}
