//
//  LoginViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 2/25/22.
//  Based on Login Flow: https://www.notion.so/vesselhealth/Login-2dbc7f76cf4c4953abd8b4aa7bc34bc5

import UIKit

class LoginViewController: KeyboardFriendlyViewController, UITextFieldDelegate, SocialAuthViewDelegate, VesselScreenIdentifiable
{
    // to store the current active textfield
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var nextButton: LoadingButton!
    
    //caller can plug a string in here
    var prepopulatedEmail: String?
    
    @Resolved internal var analytics: Analytics
    let flowName: AnalyticsFlowName = .loginFlow
    
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
                            ObjectStore.shared.loadMainContact
                            {
                                self.nextButton.hideLoading()
                                Contact.main()?.identifyAnalytics()
                                self.analytics.log(event: .logIn(loginType: .email))
                                LoginCoordinator.shared.pushLastViewController(to: self.navigationController)
                            }
                            onFailure:
                            {
                                self.nextButton.hideLoading()
                                let errorString = NSLocalizedString("Couldn't get contact", comment: "")
                                UIView.showError(text: NSLocalizedString("Oops, Something went wrong", comment: "Server Error Message"), detailText: errorString, image: nil)
                            }
                        }
                        onFailure:
                        { string in
                            self.nextButton.hideLoading()
                            UIView.showError(text: "", detailText: Constants.INCORRECT_PASSWORD_STRING, image: nil)
                        }
                    }
                    else
                    {
                        UIView.showError(text: "", detailText: Constants.INTERNET_CONNECTION_STRING, image: nil)
                    }
                }
                else if password.isEmpty
                {
                    UIView.showError(text: "", detailText: Constants.ENTER_PASSWORD_STRING, image: nil)
                }
                else
                {
                    UIView.showError(text: "", detailText: Constants.INCORRECT_PASSWORD_STRING, image: nil)
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
            if let analyticsLoginType = AnalyticsLoginType(rawValue: loginType.rawValue)
            {
                analytics.log(event: .logIn(loginType: analyticsLoginType))
            }
            LoginCoordinator.shared.pushLastViewController(to: navigationController)
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
