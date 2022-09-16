//
//  ForgotPasswordViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 2/26/22.
//  Based on Login Flow: https://www.notion.so/vesselhealth/Login-2dbc7f76cf4c4953abd8b4aa7bc34bc5

import UIKit

final class ForgotPasswordViewController: KeyboardFriendlyViewController, UITextFieldDelegate
{
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var submitButton: LoadingButton!
    @IBOutlet private weak var emailTextField: VesselTextField!
    
    @Resolved private var analytics: Analytics
    
    private enum ScreenMode
    {
        case firstScreen
        case successScreen
    }
    
    private var screenMode = ScreenMode.firstScreen
    private var initialTitle: String?
    private var initialDescription: String?
    private var initialSubmitTitle: String?
    
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
        analytics.log(event: .viewedPage(screenName: .forgotPassword))
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
            guard let email = emailTextField.text else { return }
            Server.shared.contactExists(email: email)
            { exists in
                if exists
                {
                    //Send request for password reset
                    self.requestPasswordReset()
                }
                else
                {
                    UIView.showError(text: "", detailText: NSLocalizedString("We do not recognize this email.", comment: "Unrecognized email error"))
                }
            }
            onFailure:
            { string in
                self.showErrorMessage()
            }
        }
        else
        {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func requestPasswordReset()
    {
        guard let email = emailTextField.text else { return }
        Server.shared.forgotPassword(email: email)
        { message in
            print("\(message)")
            self.analytics.log(event: .forgotPassword)
            self.transitionToSuccessScreen()
        }
        onFailure:
        { object in
            self.showErrorMessage()
        }
    }
    
    private func transitionToSuccessScreen()
    {
        //transition to success screen
        emailTextField.resignFirstResponder() //dismiss keyboard
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveLinear, animations:
        {
            self.titleLabel.alpha = 0
            self.descriptionLabel.alpha = 0
            self.emailTextField.alpha = 0
        },
        completion:
        { [weak self] _ in
            guard let self = self else { return }
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
                self.screenMode = .successScreen
                self.analytics.log(event: .viewedPage(screenName: .forgotPasswordSuccess))
            })
        })
    }
    
    private func showErrorMessage()
    {
        let alertController = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("We're having trouble communicating with the server. Please try again later.", comment: ""), preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default)
        { (action) in
            //print("You've pressed cancel");
            self.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
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
