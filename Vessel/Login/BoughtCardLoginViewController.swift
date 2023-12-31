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
    func validateForm(form: BoughtCardLoginForm) -> (isValid: Bool, error: String?)
    {
        guard let email = form.email?.trimmingCharacters(in: .whitespacesAndNewlines), email.count > 0, email.isValidEmail() else
        {
            return  (isValid: false, error: Constants.ENTER_VALID_EMAIL_STRING)
        }
        guard let password = form.password, !password.isEmpty else
        {
            return (isValid: false, error: Constants.ENTER_PASSWORD_STRING)
        }
        if password.count < Constants.MinimumPasswordLength
        {
            return  (isValid: false, error: Constants.INCORRECT_PASSWORD_STRING)
        }
        return (isValid: true, error: nil)
    }
}

class BoughtCardLoginViewController: KeyboardFriendlyViewController, UITextFieldDelegate, VesselScreenIdentifiable
{
    @IBOutlet var formFields: [VesselTextField]!
    @IBOutlet weak var doYouRememberLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var validator = BoughtCardLoginValidator()
    var email = ""
    
    @Resolved internal var analytics: Analytics
    let flowName: AnalyticsFlowName = .loginFlow
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        DispatchQueue.main.async
        {
            self.scrollView.flashScrollIndicators()
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
                Server.shared.login(email: email, password: password)
                {
                    ObjectStore.shared.loadMainContact
                    {
                        let storyboard = UIStoryboard(name: "Login", bundle: nil)
                        let vc = storyboard.instantiateViewController(identifier: "GiftedCardRegisterViewController") as! GiftedCardRegisterViewController
                        
                        self.navigationController?.fadeTo(vc)
                    }
                    onFailure:
                    {
                        let errorString = NSLocalizedString("Couldn't get contact", comment: "")
                        UIView.showError(text: NSLocalizedString("Oops, Something went wrong", comment: "Server Error Message"), detailText: errorString, image: nil)
                    }
                }
                onFailure:
                { string in
                    UIView.showError(text: "", detailText: string, image: nil)
                }
            }
        }
    }
    
    private func validate() -> Bool
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
