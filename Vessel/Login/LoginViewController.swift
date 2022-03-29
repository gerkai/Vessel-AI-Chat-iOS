//
//  LoginViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 2/25/22.
//
//  TODO: Fix layout for small screens (iPhone SE)

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate, SocialAuthViewDelegate
{
    // to store the current active textfield
    var activeTextField : UITextField? = nil
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var orSignInLabel: UILabel!
    
    //caller can plug a string in here
    var prepopulatedEmail: String? = "carson@aa.com"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundTap))
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        emailTextField.text = prepopulatedEmail
        
        //Hide some unnecessary fields on small screens to ease crowding
        if view.frame.height < Constants.SMALL_SCREEN_HEIGHT_THRESHOLD
        {
            instructionsLabel.isHidden = true
            orSignInLabel.isHidden = true
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
                Server.shared.login(email: email, password: password)
                {
                    Server.shared.getContact
                    {contact in
                        Contact.MainID = contact.id
                        ObjectStore.shared.serverSave(contact)
                        let vc = OnboardingNextViewController()
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    onFailure:
                    {error in
                        print("FAILED TO GET CONTACT: \(error)")
                    }
                }
                onFailure:
                { string in
                    UIView.showError(text: NSLocalizedString("Sign In", comment: ""), detailText: string, image: nil)
                }
            }
            else
            {
                UIView.showError(text: NSLocalizedString("Error", comment: ""), detailText: NSLocalizedString("Wrong Email", comment:""), image: nil)
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
    
    func gotSocialAuthToken()
    {
        Server.shared.getContact
        { contact in
            Contact.MainID = contact.id
            ObjectStore.shared.serverSave(contact)
            if contact.isBrandNew()
            {
                //navigate to TestCardExistCheckingViewController
                let storyboard = UIStoryboard(name: "Login", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "TestCardExistCheckingViewController") as! TestCardExistCheckingViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                let vc = OnboardingNextViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        onFailure:
        { error in
            print("FAILED TO GET CONTACT: \(error)")
        }
    }
    
    //temp until we get more screens
    /*func showLoginComplete()
    {
        let alertController = UIAlertController(title: NSLocalizedString("Logged In", comment: ""), message: NSLocalizedString("You've successfully logged in. The end.", comment:""), preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default)
        { (action) in
            //print("You've pressed cancel");
            self.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(okAction)
        self.present(alertController, animated:true)
    }*/
    
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
}
