//
//  SignupEmailCheckingViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 2/25/22.
//

import UIKit

class SignupEmailCheckingViewController: UIViewController, UITextFieldDelegate, SocialAuthViewDelegate
{
    @IBOutlet weak var googleAuthButton: UIButton!
    @IBOutlet weak var appleAuthButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    
    // to store the current active textfield
    var activeTextField : UITextField? = nil
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundTap))
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @IBAction func onBackButtonPressed(_ sender: Any)
    {
        //self.navigationController?.popViewController(animated: true)
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
        if let email = emailTextField.text
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
                    SavedEmail = email
                    
                    //navigate to TestCardExistCheckingViewController
                    let vc = storyboard.instantiateViewController(withIdentifier: "TestCardExistCheckingViewController") as! TestCardExistCheckingViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            onFailure:
            { string in
                
            }
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
    
    //MARK: - Handle sliding view up/down so textfield isn't blocked by keyboard
    @objc func keyboardWillShow(notification: NSNotification)
    {
        
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else
        {
            
            // if keyboard size is not available for some reason, dont do anything
           return
        }
        
        var shouldMoveViewUp = false
        
        // if active text field is not nil
        if let activeTextField = activeTextField
        {
            
            let bottomOfTextField = activeTextField.convert(activeTextField.bounds, to: self.view).maxY;
            let topOfKeyboard = self.view.frame.height - keyboardSize.height
            
            if bottomOfTextField > topOfKeyboard
            {
                shouldMoveViewUp = true
            }
        }
        
        if(shouldMoveViewUp)
        {
            self.view.frame.origin.y = 0 - keyboardSize.height
        }
    }

    @objc func keyboardWillHide(notification: NSNotification)
    {
        self.view.frame.origin.y = 0
    }
    
    @objc func backgroundTap(_ sender: UITapGestureRecognizer)
    {
        // go through all of the textfield inside the view, and end editing thus resigning first responder
        // ie. it will trigger a keyboardWillHide notification
        self.view.endEditing(true)
    }
    
    //MARK: - SocialAuth delegates
    func gotSocialAuthToken()
    {
        #warning("CW FIX - Login social")
        print("LOGGED IN")
        let alertController = UIAlertController(title: NSLocalizedString("Logged In", comment: ""), message: NSLocalizedString("You've successfully logged in. The end.", comment:""), preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default)
        { (action) in
            //print("You've pressed cancel");
            self.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(okAction)
        self.present(alertController, animated:true)
    }
}
