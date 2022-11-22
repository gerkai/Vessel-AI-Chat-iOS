//
//  GiftedCardRegisterViewController.swift
//  vessel-ios
//
//  Created by Carson Whitsett on 3/3/2022.
//  Copyright © 2022 Vessel Health Inc. All rights reserved.
//  Based on Login Flow: https://www.notion.so/vesselhealth/Login-2dbc7f76cf4c4953abd8b4aa7bc34bc5

import UIKit
import IQKeyboardManagerSwift

class GiftedCardRegisterViewController: KeyboardFriendlyViewController, UITextFieldDelegate, VesselScreenIdentifiable
{
    @IBOutlet weak var passwordFieldContraint: NSLayoutConstraint!
    @IBOutlet weak var firstNameTextField: VesselTextField!
    @IBOutlet weak var lastNameTextField: VesselTextField!
    @IBOutlet weak var passwordTextField: VesselTextField!
    @IBOutlet weak var confirmPasswordTextField: VesselTextField!
    @IBOutlet weak var nextButton: LoadingButton!
    
    @Resolved internal var analytics: Analytics
    let flowName: AnalyticsFlowName = .loginFlow
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 70.0
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 10.0
        self.view.endEditing(true)
    }
    
    @IBAction func onNextButtonTapped(_ sender: Any)
    {
        if let firstName = firstNameTextField.text, firstName.isValidName()
        {
            if let lastName = lastNameTextField.text, lastName.isValidName()
            {
                if let password = passwordTextField.text, password.isValidPassword()
                {
                    //all fields valid!
                    if let confirmPassword = confirmPasswordTextField.text, confirmPassword == password
                    {
                        createContact(firstName: firstName, lastName: lastName, password: password)
                    }
                    else
                    {
                        UIView.showError(text: NSLocalizedString("Passwords do not match", comment: "Error message"), detailText: "", image: nil)
                    }
                }
                else
                {
                    UIView.showError(text: "", detailText: NSLocalizedString("Password must be at least 6 characters", comment: ""), image: nil)
                }
            }
            else
            {
                UIView.showError(text: "", detailText: NSLocalizedString("Please enter a valid last name", comment: ""), image: nil)
            }
        }
        else
        {
            UIView.showError(text: "", detailText: NSLocalizedString("Please enter a valid first name", comment: ""), image: nil)
        }
    }
    
    @IBAction func onBackButtonTapped(_ sender: Any)
    {
        self.navigationController?.fadeOut()
    }

    private func createContact(firstName: String, lastName: String, password: String)
    {
        let contact = Contact(firstName: firstName, lastName: lastName, email: Contact.SavedEmail ?? "")
        nextButton.showLoading()
        Server.shared.createContact(contact: contact, password: password)
        {
            ObjectStore.shared.loadMainContact
            {
                Contact.main()?.identifyAnalytics()                
                OnboardingCoordinator.pushInitialViewController(to: self.navigationController)
                self.nextButton.hideLoading()
            }
            onFailure:
            {
                self.nextButton.hideLoading()
                let errorString = NSLocalizedString("Couldn't get contact", comment: "")
                UIView.showError(text: NSLocalizedString("Oops, Something went wrong", comment: "Server Error Message"), detailText: errorString, image: nil)
            }
        }
        onFailure:
        { error in
            self.nextButton.hideLoading()
            UIView.showError(text: NSLocalizedString("Sign Up", comment: ""), detailText: error, image: nil)
        }
    }
    
    //MARK: - textfield delegates
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField.tag >= 1
        {
            self.activeTextField = textField
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        self.activeTextField = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField
        {
            nextField.becomeFirstResponder()
        }
        else
        {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        // Do not add a line break
        return false
    }
}
