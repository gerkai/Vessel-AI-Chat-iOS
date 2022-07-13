//
//  BoughtCardLoginViewController.swift
//  vessel-ios
//
//  Created by Carson Whitsett on 05/26/2022.
//  Copyright © 2022 Vessel Health Inc. All rights reserved.
//  Based on Login Flow: https://www.notion.so/vesselhealth/Login-2dbc7f76cf4c4953abd8b4aa7bc34bc5

import UIKit

struct BoughtCardLoginForm
{
    var email: String?
    var password: String?
}

struct BoughtCardLoginValidator
{
    func validateForm(form: BoughtCardLoginForm)->(isValid: Bool,error: String?)
    {
        guard let email = form.email?.trimmingCharacters(in: .whitespacesAndNewlines), email.count > 0, email.isValidEmail() else
        {
            return  (isValid: false,error: "Please enter a valid email")
        }
        guard let password = form.password, password.count >= Constants.MinimumPasswordLength else
        {
            return  (isValid: false,error: "Please enter your password")
        }
        return (isValid: true,error: nil)
    }
}

class BoughtCardLoginViewController: KeyboardFriendlyViewController, UITextFieldDelegate
{
    
    @IBOutlet var formFields: [VesselTextField]!
    @IBOutlet weak var doYouRememberLabel: UILabel!
    
    private var validator = BoughtCardLoginValidator()
    var email = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if view.frame.height < Constants.SMALL_SCREEN_HEIGHT_THRESHOLD
        {
            doYouRememberLabel.text = NSLocalizedString("Remember what email you used?", comment: "Short version of 'Do you remember what email you used?")
        }
    }
    
    @IBAction func onCallCustomerSupport(_ sender: UIButton)
    {
        openInSafari(url: Server.shared.SupportURL())
    }
    
    @IBAction func onBackButtonTapped(_ sender: UIButton)
    {
        self.navigationController?.fadeOut()
    }
    
    @IBAction func onContinueButtonTapped(_ sender: Any)
    {
        login()
    }
    
    private func login()
    {
        let validationResult = validate()
        if validationResult
        {
            self.view.endEditing(true)
            if let email = formFields[0].text, let password = formFields[1].text
            {
                Server.shared.login(email: email , password: password)
                {
                    Server.shared.getContact
                    { contact in
                        Contact.MainID = contact.id
                        ObjectStore.shared.serverSave(contact)
                        
                        let storyboard = UIStoryboard(name: "Login", bundle: nil)
                        let vc = storyboard.instantiateViewController(identifier: "GiftedCardRegisterViewController") as! GiftedCardRegisterViewController
                        
                        self.navigationController?.fadeTo(vc)
                        
                    }
                    onFailure:
                    { error in
                        UIView.showError(text: "The email and password combination is incorrect", detailText: "\(error)", image: nil)
                    }
                }
                onFailure:
                { string in
                    UIView.showError(text: "", detailText: string, image: nil)
                }
            }
        }
    }
    
    private func validate()->Bool
    {
        let form = BoughtCardLoginForm(email: formFields[0].text, password: formFields[1].text)
        let validationResult = validator.validateForm(form: form)
        if !validationResult.isValid
        {
            UIView.showError(text: "", detailText: validationResult.error ?? "", image: nil)
        }
        return validationResult.isValid
    }
    
    @IBAction func onForgetPasswordButton(_ sender: UIButton)
    {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ForgotPasswordViewController")
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true)
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
