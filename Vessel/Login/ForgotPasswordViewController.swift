//
//  ForgotPasswordViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 2/26/22.
//  Based on Login Flow: https://www.notion.so/vesselhealth/Login-2dbc7f76cf4c4953abd8b4aa7bc34bc5

import UIKit

class ForgotPasswordViewController: KeyboardFriendlyViewController, UITextFieldDelegate
{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var submitButton: LoadingButton!
    @IBOutlet weak var emailTextField: VesselTextField!
    
    enum mode
    {
        case firstScreen
        case secondScreen
    }
    
    var screenMode = mode.firstScreen
    var initialTitle: String?
    var initialDescription: String?
    var initialSubmitTitle: String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        initialTitle = titleLabel.text
        initialDescription = descriptionLabel.text
        //disable wonky orphaned word prevention (started with iOS 11)
        //titleLabel.lineBreakStrategy = []
        
        initialSubmitTitle = submitButton.title(for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        logPageViewed()
    }
    
    @IBAction func onBackButton()
    {
        if screenMode == .firstScreen
        {
            dismiss(animated: true, completion: nil)
        }
        else
        {
            //transition to first screen
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveLinear, animations:
            {
                self.titleLabel.alpha = 0
                self.descriptionLabel.alpha = 0
            },
            completion:
            {_ in
                self.titleLabel.text = self.initialTitle
                self.descriptionLabel.text = self.initialDescription
                UIView.animate(withDuration: 0.25, delay: 0, options: .curveLinear, animations:
                {
                    self.titleLabel.alpha = 1
                    self.descriptionLabel.alpha = 1
                    self.emailTextField.alpha = 1
                    self.submitButton.setTitle(self.initialSubmitTitle, for: .normal)
                },
                completion:
                {_ in
                    self.screenMode = .firstScreen
                })
            })
        }
    }
    
    @IBAction func onSubmitButton()
    {
        if screenMode == .firstScreen
        {
            //Send request for password reset
            requestPasswordReset()
        }
        else
        {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func requestPasswordReset()
    {
        if let email = emailTextField.text
        {
            Server.shared.forgotPassword(email: email)
            { message in
                print("\(message)")
                self.transitionToSecondScreen()
            }
            onFailure:
            { object in
                print("\(object)")
                let alertController = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("We're having trouble communicating with the server. Please try again later.", comment: ""), preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default)
                { (action) in
                    //print("You've pressed cancel");
                    self.dismiss(animated: true, completion: nil)
                }
                
                alertController.addAction(okAction)
                self.present(alertController, animated: true)
            }
        }
    }
    
    func transitionToSecondScreen()
    {
        //transition to second screen
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveLinear, animations:
        {
            self.titleLabel.alpha = 0
            self.descriptionLabel.alpha = 0
            self.emailTextField.alpha = 0
        },
        completion:
        {_ in
            self.titleLabel.text = NSLocalizedString("Request sent successfully", comment: "")
            self.descriptionLabel.text = NSLocalizedString("Please check your inbox for a link to reset your password.", comment: "")
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveLinear, animations:
            {
                self.titleLabel.alpha = 1
                self.descriptionLabel.alpha = 1
                self.submitButton.setTitle(NSLocalizedString("Login", comment: ""), for: .normal)
            },
            completion:
            {_ in
                self.screenMode = .secondScreen
            })
        })
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
    
    @IBAction func textFieldDidChange(_ textField: UITextField)
    {
        if textField.text?.isValidEmail() == true
        {
            submitButton.isEnabled = true
        }
        else
        {
            submitButton.isEnabled = false
        }
    }
}
