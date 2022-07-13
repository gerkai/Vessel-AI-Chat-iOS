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
    
    @IBAction func onBackButtonPressed(_ sender: Any)
    {
        self.navigationController?.fadeOut()
    }
    
    @IBAction func onContinueButtonPressed()
    {
        self.view.endEditing(true)
        if let email = emailTextField.text, let password = passwordTextField.text
        {
            if email.isValidEmail()
            {
                if password.isValidPassword()
                {
                    nextButton.showLoading()
                    Server.shared.login(email: email, password: password)
                    {
                        Server.shared.getContact
                        {contact in
                            self.nextButton.hideLoading()
                            Contact.MainID = contact.id
                            ObjectStore.shared.serverSave(contact)
                            let vc = OnboardingViewModel.NextViewController()
                            self.navigationController?.fadeTo(vc)
                        }
                        onFailure:
                        {error in
                            self.nextButton.hideLoading()
                            UIView.showError(text: NSLocalizedString("Oops, Something went wrong", comment:"Server Error Message"), detailText: "\(error.localizedCapitalized)", image: nil)
                        }
                    }
                    onFailure:
                    { string in
                        self.nextButton.hideLoading()
                        UIView.showError(text: "", detailText: string, image: nil)
                    }
                }
                else
                {
                    UIView.showError(text: "", detailText: NSLocalizedString("Please enter your password", comment:""), image: nil)
                }
            }
            else
            {
                UIView.showError(text: "", detailText: NSLocalizedString("Please enter a valid email", comment:""), image: nil)
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
            //navigate to start of Onboarding
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
            onContinueButtonPressed()
        }
        return true
    }
}
