//
//  LoginViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 2/25/22.
//  Based on Login Flow: https://www.notion.so/vesselhealth/Login-2dbc7f76cf4c4953abd8b4aa7bc34bc5

import UIKit

class LoginViewController: KeyboardFriendlyViewController, UITextFieldDelegate, SocialAuthViewDelegate
{
    // to store the current active textfield
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var nextButton: LoadingButton!
    
    //caller can plug a string in here
    var prepopulatedEmail: String?
    @Resolved private var analytics: Analytics
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if prepopulatedEmail != nil
        {
            emailTextField.text = prepopulatedEmail
        }
        else if let email = UserDefaults.standard.string(forKey: Constants.KEY_DEFAULT_LOGIN_EMAIL)
        {
            emailTextField.text = email
        }
        
        if let pw = UserDefaults.standard.string(forKey: Constants.KEY_DEFAULT_LOGIN_PASSWORD)
        {
            passwordTextField.text = pw
        }
        
        //Hide some unnecessary fields on small screens to ease crowding
        if view.frame.height < Constants.SMALL_SCREEN_HEIGHT_THRESHOLD
        {
            instructionsLabel.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        analytics.log(event: .viewedPage(screenName: .welcomeBack))
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
    
    @IBAction func onBackButtonPressed(_ sender: Any)
    {
        self.navigationController?.fadeOut()
    }
    
    @IBAction func onNextButtonPressed()
    {
        self.view.endEditing(true)
        if let email = emailTextField.text, let password = passwordTextField.text
        {
            if email.isValidEmail()
            {
                if password.isValidPassword()
                {
                    if Reachability.isConnectedToNetwork()
                    {
                        nextButton.showLoading()
                        Server.shared.login(email: email, password: password)
                        {
                            Server.shared.getContact
                            { [weak self] contact in
                                guard let self = self else { return }
                                self.nextButton.hideLoading()
                                self.analytics.log(event: .logIn(loginType: .email))
                                Contact.MainID = contact.id
                                ObjectStore.shared.serverSave(contact)
                                let vc = OnboardingViewModel.NextViewController()
                                self.navigationController?.fadeTo(vc)
                            }
                            onFailure:
                            { [weak self] error in
                                guard let self = self else { return }
                                self.nextButton.hideLoading()
                                let errorString = error?.localizedDescription ?? NSLocalizedString("Couldn't get contact", comment: "")
                                UIView.showError(text: NSLocalizedString("Oops, Something went wrong", comment: "Server Error Message"), detailText: errorString, image: nil)
                            }
                        }
                        onFailure:
                        { [weak self] string in
                            guard let self = self else { return }
                            self.nextButton.hideLoading()
                            UIView.showError(text: "", detailText: string, image: nil)
                        }
                    }
                    else
                    {
                        UIView.showError(text: "", detailText: Constants.INTERNET_CONNECTION_STRING, image: nil)
                    }
                }
                else
                {
                    UIView.showError(text: "", detailText: Constants.ENTER_PASSWORD_STRING, image: nil)
                }
            }
            else
            {
                UIView.showError(text: "", detailText: Constants.ENTER_VALID_EMAIL_STRING, image: nil)
            }
        }
    }
    
    @IBAction func onForgotPassword()
    {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ForgotPasswordViewController")
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true)
    }
    
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
            //navigate to start of Onboarding
            if let analyticsLoginType = AnalyticsLoginType(rawValue: loginType.rawValue)
            {
                analytics.log(event: .logIn(loginType: analyticsLoginType))
            }
            let vc = OnboardingViewModel.NextViewController()
            self.navigationController?.fadeTo(vc)
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if textField == emailTextField
        {
            passwordTextField.becomeFirstResponder()
        }
        else
        {
            onNextButtonPressed()
        }
        return true
    }
}
