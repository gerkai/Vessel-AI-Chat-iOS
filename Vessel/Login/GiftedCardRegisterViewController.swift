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
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    var initialFirstName: String = ""
    var initialLastName: String = ""
    var socialAuth: Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if let contact = Contact.main()
        {
            firstNameTextField.text = contact.first_name
            lastNameTextField.text = contact.last_name
            initialFirstName = contact.first_name
            initialLastName = contact.last_name
            passwordTextField.isHidden = true
            confirmPasswordTextField.isHidden = true
            socialAuth = true
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
                    //Update first and last name if user changed them
                    if (initialFirstName != firstName) || (initialLastName != lastName)
                    {
                        if var contact = Contact.main()
                        {
                            contact.first_name = firstName
                            contact.last_name = lastName
                            ObjectStore.shared.ClientSave(contact)
                        }
                    }
                    //createContact()
                }
                else
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
        self.navigationController?.fadeOut()
    }

    private func createContact(firstName: String, lastName: String, password: String)
    {
        let contact =  Contact(firstName: firstName, lastName: lastName, email: Contact.SavedEmail ?? "", password: password)
        Server.shared.createContact(contact: contact)
        {
            Server.shared.getContact
            { contact in
                Contact.MainID = contact.id
                ObjectStore.shared.serverSave(contact)
                //begin onboarding flow
                let vc = OnboardingNextViewController()
                //{
                    self.navigationController?.pushViewController(vc, animated: true)
                /*}
                else
                {
                    self.navigationController?.popToRootViewController(animated: true)
                    Server.shared.logOut()
                }*/
            }
            onFailure:
            { error in
                UIView.showError(text: NSLocalizedString("Server Error", comment: "Server error"), detailText: error, image: nil)
            }
        }
        onFailure:
        { error in
            UIView.showError(text: NSLocalizedString("Sign Up", comment:""), detailText: error, image: nil)
        }
    }
}
