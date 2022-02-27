//
//  GiftedCardRegisterViewController.swift
//  vessel-ios
//
//  Created by Mohamed El-Taweel on 05/26/2021.
//  Copyright © 2021 Vessel Health Inc. All rights reserved.
//

import UIKit
//import FirebaseAnalytics
//import Bugsee
import IQKeyboardManagerSwift

struct GiftedCardRegisterForm {
    var email: String?
    var firstName: String?
    var lastName: String?
    var password: String?
}

struct GiftedCardSocialRegisterForm {
    var firstName: String?
    var lastName: String?
}


struct GiftedCardRegisterFormValidator
{
    func validateForm(form: GiftedCardRegisterForm)->(isValid: Bool,error: String?)
    {
        guard let email = form.email?.trimmingCharacters(in: .whitespacesAndNewlines), email.count > 0, email.isValidEmail() else
        {
            return  (isValid: false,error: "Wrong Email")
        }
        guard let firstName = form.firstName,firstName.count > 0,firstName.isLettersOnly else
        {
            return  (isValid: false,error: "Wrong First Name")
        }
        guard let lastName = form.lastName,lastName.count > 0,lastName.isLettersOnly else
        {
            return  (isValid: false,error: "Wrong Last Name")
        }
        guard let password = form.password, password.count >= Constants.MinimumPasswordLength else
        {
            return  (isValid: false,error: "Wrong Password")
        }
        return (isValid: true,error: nil)
    }
    
    func validateSocialForm(form: GiftedCardSocialRegisterForm)->(isValid: Bool,error: String?)
    {
        guard let firstName = form.firstName,firstName.count > 0,firstName.isLettersOnly else
        {
            return  (isValid: false,error: "Wrong First Name")
        }
        guard let lastName = form.lastName,lastName.count > 0,lastName.isLettersOnly else
        {
            return  (isValid: false,error: "Wrong Last Name")
        }
        return (isValid: true,error: nil)
    }
}


class GiftedCardRegisterViewController: UIViewController
{
    @IBOutlet var formFields: [VesselTextField]!
    
    @IBOutlet weak var passwordFieldContraint: NSLayoutConstraint!
    private let validator = GiftedCardRegisterFormValidator()
    //private lazy var analyticManager = AnalyticManager()
    //private let contactRepository: ContactRepositoryProtocol = ContactRepository()
    //private lazy var pushwooshManager = PushwooshHelper()

    var email = ""
    var firstName: String = ""
    var lastName: String = ""
    var socialAuth: Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if socialAuth
        {
            passwordFieldContraint.constant = 0
            formFields[0].text = firstName
            formFields[1].text = lastName
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
        register()
    }
    
    @IBAction func onBackButtonTapped(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func register()
    {
        var isFormValid = false
        if socialAuth
        {
            isFormValid = validateSocialForm()
        }
        else
        {
            isFormValid = validateForm()
        }
        
        if isFormValid
        {
            createContact()
        }
    }
    
    private func createContact()
    {
        #warning("CW FIX - CREATE CONTACT")
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
    }
}
