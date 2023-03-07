//
//  SignupEmailCheckingViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 2/25/22.
//  Based on Login Flow: https://www.notion.so/vesselhealth/Login-2dbc7f76cf4c4953abd8b4aa7bc34bc5

import UIKit

class SignupEmailCheckingViewController: KeyboardFriendlyViewController, UITextFieldDelegate, SocialAuthViewDelegate, VesselScreenIdentifiable
{
    @IBOutlet weak var googleAuthButton: UIButton!
    @IBOutlet weak var appleAuthButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nextButton: LoadingButton!
    
    @Resolved internal var analytics: Analytics
    let flowName: AnalyticsFlowName = .loginFlow
    
    @IBAction func onBackButtonPressed(_ sender: Any)
    {
        self.navigationController?.fadeOut()
    }
    
    @IBAction func googleAuthAction(_ sender: Any)
    {
        if Reachability.isConnectedToNetwork()
        {
            launchSocialAuth(loginType: .google)
        }
        else
        {
            UIView.showError(text: "", detailText: Constants.INTERNET_CONNECTION_STRING, image: nil)
        }
    }
    
    @IBAction func appleAuthAction(_ sender: Any)
    {
        if Reachability.isConnectedToNetwork()
        {
            launchSocialAuth(loginType: .apple)
        }
        else
        {
            UIView.showError(text: "", detailText: Constants.INTERNET_CONNECTION_STRING, image: nil)
        }
    }
    
    func launchSocialAuth(loginType: LoginType)
    {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SocialAuthViewController") as! SocialAuthViewController
        if loginType == .google
        {
            vc.strURL = Server.shared.googleLoginURL()
        }
        else
        {
            vc.strURL = Server.shared.appleLoginURL()
        }
        vc.modalPresentationStyle = .fullScreen
        vc.delegate = self
        vc.loginType = loginType
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
        //openInSafari(url: Constants.termsOfServiceURL)
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TermsOfServiceViewController") as! TermsOfServiceViewController
        self.present(vc, animated: true)
    }
    
    @IBAction func onNextButtonTapped(_ sender: Any)
    {
        if let email = emailTextField.text, email.isValidEmail() == true
        {
            if Reachability.isConnectedToNetwork()
            {
                nextButton.showLoading()
                Server.shared.contactExists(email: email)
                { exists in
                    let storyboard = UIStoryboard(name: "Login", bundle: nil)
                    if exists == true
                    {
                        //navigate to LoginViewController and pre-populate e-mail field
                        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                        vc.prepopulatedEmail = email
                        self.navigationController?.pushViewController(vc, animated: true)
                        self.nextButton.hideLoading()
                    }
                    else
                    {
                        //save e-mail for use later during sign-up process
                        Contact.SavedEmail = email
                        
                        self.showPractScreens()
                    }
                }
                onFailure:
                { string in
                    //TODO: log this error into the debug log
                }
            }
            else
            {
                UIView.showError(text: "", detailText: Constants.INTERNET_CONNECTION_STRING, image: nil)
            }
        }
        else
        {
            UIView.showError(text: "", detailText: Constants.ENTER_VALID_EMAIL_STRING, image: nil)
        }
    }
    
    func showPractScreens()
    {
        var showPract = false
        if let contact = Contact.main()
        {
            Log_Add("There is a contact")
            if contact.pa_id == nil
            {
                Log_Add("There is no pa_id. Showing pract")
                showPract = true
            }
        }
        else
        {
            Log_Add("There is not a contact")
            if Contact.PractitionerID == nil
            {
                Log_Add("PractitionerID == nil. Showing Pract.")
                showPract = true
            }
        }
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        if showPract
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "PractitionerQueryViewController") as! PractitionerQueryViewController
            self.navigationController?.fadeTo(vc)
        }
        else
        {
            //navigate to TestCardExistCheckingViewController
            let vc = storyboard.instantiateViewController(withIdentifier: "TestCardExistCheckingViewController") as! TestCardExistCheckingViewController
            self.navigationController?.fadeTo(vc)
        }
        self.nextButton.hideLoading()
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
    func gotSocialAuthToken(isBrandNewAccount: Bool, loginType: LoginType)
    {
        if isBrandNewAccount
        {
            //navigate to TestCardExistCheckingViewController
            if let analyticsLoginType = AnalyticsLoginType(rawValue: loginType.rawValue)
            {
                analytics.log(event: .signUp(loginType: analyticsLoginType))
            }
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "TestCardExistCheckingViewController") as! TestCardExistCheckingViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            if let analyticsLoginType = AnalyticsLoginType(rawValue: loginType.rawValue)
            {
                analytics.log(event: .logIn(loginType: analyticsLoginType))
            }
            LoginCoordinator.shared.pushLastViewController(to: navigationController)
        }
    }
}
