//
//  GiftedCardRegisterViewController.swift
//  vessel-ios
//
//  Created by Carson Whitsett on 3/3/2022.
//  Copyright © 2022 Vessel Health Inc. All rights reserved.
//

import UIKit
//import FirebaseAnalytics
//import Bugsee
import IQKeyboardManagerSwift


class GiftedCardRegisterViewController: UIViewController
{
    @IBOutlet var formFields: [VesselTextField]!
    
    @IBOutlet weak var passwordFieldContraint: NSLayoutConstraint!
    //private lazy var analyticManager = AnalyticManager()
    //private lazy var pushwooshManager = PushwooshHelper()
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var initialFirstName: String = ""
    var initialLastName: String = ""
    var socialAuth: Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if socialAuth
        {
            firstNameTextField.text = initialFirstName
            lastNameTextField.text = initialLastName
            passwordTextField.isHidden = true
        }
    }
    
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
    
    @IBAction func onContinueButtonTapped(_ sender: Any)
    {
        if let firstName = firstNameTextField.text, firstName.isValidName()
        {
            if let lastName = lastNameTextField.text, lastName.isValidName()
            {
                if socialAuth
                {
                    //all fields valid!
                    //createContact()
                }
                else
                {
                    if let password = passwordTextField.text, password.isValidPassword()
                    {
                        //all fields valid!
                        //createContact()
                    }
                    else
                    {
                        UIView.showError(text: "Error", detailText: NSLocalizedString("Password too short", comment: ""), image: nil)
                    }
                }
            }
            else
            {
                UIView.showError(text: "Error", detailText: NSLocalizedString("Please enter a valid last name", comment: ""), image: nil)
            }
        }
        else
        {
            UIView.showError(text: "Error", detailText: NSLocalizedString("Please enter a valid first name", comment: ""), image: nil)
        }
    }
    
    @IBAction func onBackButtonTapped(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }

    
    private func createContact(firstName: String, lastName: String, password: String)
    {
        //cwlet contact =  Contact(email: SavedEmail ?? "", password: passwordTextField.text ?? "", firstName: firstName, lastName: lastName)
        
        /*
        if socialAuth
        {
            //let event = AnalyticEvent.CREATE_ACCOUNT_SUCCESS(email: email)
            //self.analyticManager.trackEvent(event: event)
            if let isFirstReminder = UserDefaults.standard.value(forKey: UserDefaultsKeys.isFirstReminder.rawValue) as? Bool,
               isFirstReminder
            {
                self.pushwooshManager.register()
            }
            NotificationCenter.default.post(name: Notification.Name.didSignup, object: nil)
            return
        }
        
        let contact =  Contact(email: email, password: formFields[2].text ?? "", firstName: formFields[0].text ?? "", lastName: formFields[1].text ?? "")
        contactRepository.create(parameters: contact)
        { [weak self] result in
            guard let self = self else { return }
            switch result
            {
            case .success(let tokens):
                Analytics.logEvent("create_account_2", parameters: nil)
                if let accessToken = tokens.access_token,
                   let refreshToken = tokens.refresh_token,
                    let email = contact.email,
                    let password = contact.password
                {
                    SessionManager.shared.storeAuthenticationInfo(email: email, password: password, token: accessToken, refreshToken: refreshToken)
                    let event = AnalyticEvent.CREATE_ACCOUNT_SUCCESS(email: contact.email ?? "")
                    self.analyticManager.trackEvent(event: event)
                    if let isFirstReminder = UserDefaults.standard.value(forKey: UserDefaultsKeys.isFirstReminder.rawValue) as? Bool,
                       isFirstReminder
                    {
                        self.pushwooshManager.register()
                    }
                    self.getContactDetails(from: contact)
                }
                else
                {
                    UIView.showError(text: "Sign Up", detailText: "Something went wrong", image: nil)
                    let event = AnalyticEvent.CREATE_ACCOUNT_FAIL(email: contact.email ?? "", error: "Something went wrong")
                    self.analyticManager.trackEvent(event: event)
                }
            case .failure(let error):
                UIView.showError(text: "Sign Up", detailText: error.localizedDescription, image: nil)
                let event = AnalyticEvent.CREATE_ACCOUNT_FAIL(email: contact.email ?? "", error: error.localizedDescription)
                self.analyticManager.trackEvent(event: event)
            }
        }*/
    }
    
    private func getContactDetails(from contact: Contact)
    {
#warning("CW FIX")
        /*
        contactRepository.get
        {[weak self] result in
            switch result
            {
                case .success(let contact):
                    UserManager.shared.contact = contact
                    self?.analyticManager.setupUserIdentity()
                    if let userEmail = UserManager.shared.contact?.email, let contactId = UserManager.shared.contact?.id
                    {
                        Bugsee.setEmail(userEmail)
                        Bugsee.setAttribute("contact_id", value: contactId)
                    }
                    
                case .failure:
                    UserManager.shared.contact = contact
                    if let userEmail = UserManager.shared.contact?.email, let contactId = UserManager.shared.contact?.id
                    {
                        Bugsee.setEmail(userEmail)
                        Bugsee.setAttribute("contact_id", value: contactId)
                    }
            }
        
            NotificationCenter.default.post(name: Notification.Name.didSignup, object: nil)
        }*/
    }
    /*
    private func validateForm()->Bool
    {
        let form = GiftedCardRegisterForm(email: email, firstName: formFields[0].text, lastName: formFields[1].text, password: formFields[2].text)
        let validationResult = validator.validateForm(form: form)
        if !validationResult.isValid
        {
            UIView.showError(text: "Error", detailText: validationResult.error ?? "", image: nil)
        }
        return validationResult.isValid
    }
    
    private func validateSocialForm()->Bool
    {
        let form = GiftedCardSocialRegisterForm(firstName: formFields[0].text, lastName: formFields[1].text)
        let validationResult = validator.validateSocialForm(form: form)
        if !validationResult.isValid
        {
            UIView.showError(text: "Error", detailText: validationResult.error ?? "", image: nil)
        }
        return validationResult.isValid
    }*/
}
