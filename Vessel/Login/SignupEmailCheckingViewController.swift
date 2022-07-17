//
//  SignupEmailCheckingViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 2/25/22.
//  Based on Login Flow: https://www.notion.so/vesselhealth/Login-2dbc7f76cf4c4953abd8b4aa7bc34bc5

import UIKit

class SignupEmailCheckingViewController: KeyboardFriendlyViewController, UITextFieldDelegate, SocialAuthViewDelegate
{
    @IBOutlet weak var googleAuthButton: UIButton!
    @IBOutlet weak var appleAuthButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        logPageViewed()
    }
    
    @IBAction func onBackButtonPressed(_ sender: Any)
    {
        self.navigationController?.fadeOut()
    }
    
    @IBAction func googleAuthAction(_ sender: Any)
    {
        launchSocialAuth(isGoogle: true)
    }
    
    @IBAction func appleAuthAction(_ sender: Any)
    {
        launchSocialAuth(isGoogle: false)
    }
    
    func launchSocialAuth(isGoogle: Bool)
    {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SocialAuthViewController") as! SocialAuthViewController
        if isGoogle
        {
            vc.strURL = Server.shared.googleLoginURL()
        }
        else
        {
            vc.strURL = Server.shared.appleLoginURL()
        }
        vc.modalPresentationStyle = .fullScreen
        vc.delegate = self
        vc.bIsGoogle = isGoogle
        self.present(vc, animated: true)
    }
    
    @IBAction func onPrivacyButtonTapped(_ sender: Any)
    {
        self.view.endEditing(true)
        openInSafari(url: Constants.privacyPolicyURL)
    }
    
    @IBAction func onTermsButtonTapped(_ sender: Any)
    {
        self.view.endEditing(true)
        openInSafari(url: Constants.termsOfServiceURL)
    }
    
    @IBAction func onContinueButtonTapped(_ sender: Any)
    {
        if let email = emailTextField.text, email.isValidEmail() == true
        {
            Server.shared.contactExists(email: email)
            { exists in
                let storyboard = UIStoryboard(name: "Login", bundle: nil)
                if exists == true
                {
                    //navigate to LoginViewController and pre-populate e-mail field
                    let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                    vc.prepopulatedEmail = email
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else
                {
                    //save e-mail for use later during sign-up process
                    Contact.SavedEmail = email
                    
                    //navigate to TestCardExistCheckingViewController
                    let vc = storyboard.instantiateViewController(withIdentifier: "TestCardExistCheckingViewController") as! TestCardExistCheckingViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            onFailure:
            { string in
            }
        }
        else
        {
            UIView.showError(text: "", detailText: NSLocalizedString("Please enter a valid email", comment: ""), image: nil)
        }
    }
    
    //MARK: - textfield delegates
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        self.activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        self.activeTextField = nil
    }
    
    //MARK: - SocialAuth delegates
    func gotSocialAuthToken(isBrandNewAccount: Bool)
    {
        if isBrandNewAccount
        {
            //navigate to TestCardExistCheckingViewController
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "TestCardExistCheckingViewController") as! TestCardExistCheckingViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            let vc = OnboardingViewModel.NextViewController()
            
            self.navigationController?.fadeTo(vc)
        }
    }
}
