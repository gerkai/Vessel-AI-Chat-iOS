//
//  BoughtCardLoginViewController.swift
//  vessel-ios
//
//  Created by Mohamed El-Taweel on 05/26/2021.
//  Copyright © 2021 Vessel Health Inc. All rights reserved.
//

import UIKit
//import Bugsee

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
            return  (isValid: false,error: "Wrong Email")
        }
        guard let password = form.password, password.count >= Constants.MinimumPasswordLength else
        {
            return  (isValid: false,error: "Wrong Password")
        }
        return (isValid: true,error: nil)
    }
}

class BoughtCardLoginViewController: UIViewController
{
    
    @IBOutlet var formFields: [VesselTextField]!
    @IBOutlet weak var doYouRememberLabel: UILabel!
    
    //private lazy var analyticManager = AnalyticManager()
    private var validator = BoughtCardLoginValidator()
    //private let authenticationRepository: AuthenticationRepositoryProtocol = AuthenticationRepository()
    //private let contactRepositroy: ContactRepositoryProtocol = ContactRepository()
    //private lazy var pushwooshManager = PushwooshHelper()
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
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onContinueButtonTapped(_ sender: Any)
    {
        //analyticManager.trackEvent(event: .SIGN_UP_LOG_IN(email: email))
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
                    self.showLoginComplete()
                    Server.shared.getContact
                    {
                        print("GOT CONTACT")
                    }
                    onFailure:
                    {
                        print("FAILED TO GET CONTACT")
                    }
                }
                onFailure:
                { string in
                    UIView.showError(text: "Sign In", detailText: string, image: nil)
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
            UIView.showError(text: "Error", detailText: validationResult.error ?? "", image: nil)
        }
        return validationResult.isValid
    }
    
    @IBAction func onForgetPasswordButton(_ sender: UIButton)
    {
        //let event = AnalyticEvent.FORGOT_PASSWORD_TAPPED
        //analyticManager.trackEvent(event: event)
        
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ForgotPasswordViewController")
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true)
    }
    
    //temp until we get more screens
    func showLoginComplete()
    {
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
