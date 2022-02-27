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
    //private lazy var analyticManager = AnalyticManager()
    private var validator = BoughtCardLoginValidator()
    //private let authenticationRepository: AuthenticationRepositoryProtocol = AuthenticationRepository()
    //private let contactRepositroy: ContactRepositoryProtocol = ContactRepository()
    //private lazy var pushwooshManager = PushwooshHelper()
    var email = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
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
            let form = BoughtCardLoginForm(email: formFields[0].text, password: formFields[1].text)
            getAuthenticationToken(with: form)
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
        
        /*UIView.animate(withDuration: 0.1, animations:
        {
            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        },
        completion:
        { _ in
            UIView.animate(withDuration: 0.1)
            { [weak self] in*/
                            
                //sender.transform = CGAffineTransform.identity
                            
                let storyboard = UIStoryboard(name: "Login", bundle: nil)
                    
                let fpvc = storyboard.instantiateViewController(identifier: "ForgotPasswordViewController")
                navigationController?.pushViewController(fpvc, animated: true)
           // }
        //})
    }
    
    
}

//MARK: - NetworkCalls
extension BoughtCardLoginViewController
{
    private func getAuthenticationToken(with form: BoughtCardLoginForm)
    {
        #warning("CW FIX")
        /*
        let credentials = Login(email: form.email ?? "", password: form.password ?? "", contact_id_override: nil)
        authenticationRepository.login(parameters: credentials) { [weak self] result in
            guard let self = self else { return }
            switch result
            {
            case .success(let tokens):
                if let accessToken = tokens.access_token,
                   let refreshToken = tokens.refresh_token
                {
                    SessionManager.shared.storeAuthenticationInfo(email: form.email ?? "", password: form.password ?? "", token: accessToken, refreshToken: refreshToken)
                    let event = AnalyticEvent.SIGN_IN_SUCCESS(email: form.email ?? "")
                    self.analyticManager.trackEvent(event: event)
                    self.getContact()
                }
                else
                {
                    UIView.showError(text: "Sign In", detailText: "Something went wrong", image: nil)
                    let event = AnalyticEvent.SIGN_IN_FAIL(email: form.email ?? "", error:  "Something went wrong")
                    self.analyticManager.trackEvent(event: event)
                }
            case .failure(let error):
                UIView.showError(text: "Sign In", detailText: error.localizedDescription, image: nil)
                let event = AnalyticEvent.SIGN_IN_FAIL(email: form.email ?? "", error:  error.localizedDescription)
                self.analyticManager.trackEvent(event: event)
            }
        }*/
    }
    
    private func getContact()
    {
        #warning("CW FIX")
        /*
        contactRepositroy.get
        { [weak self] result in
            guard let self = self else { return }
            switch result
            {
            case .success(let contact):
                UserManager.shared.contact = contact
                if let userEmail = UserManager.shared.contact?.email, let contactId = UserManager.shared.contact?.id
                {
                    Bugsee.setEmail(userEmail)
                    Bugsee.setAttribute("contact_id", value: contactId)
                }
                self.analyticManager.setupUserIdentity()
                if let isFirstReminder = UserDefaults.standard.value(forKey: UserDefaultsKeys.isFirstReminder.rawValue) as? Bool,
                   isFirstReminder
                {
                    self.pushwooshManager.register()
                }
                NotificationCenter.default.post(name: Notification.Name.didAuthenticate, object: nil)
                
            case .failure(let error):
                UIView.showError(text: "Sign In", detailText: error.localizedDescription, image: nil)
            }
        }*/
    }
}
