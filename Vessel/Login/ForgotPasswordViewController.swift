//
//  ForgotPasswordViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 2/26/22.
//

import UIKit

class ForgotPasswordViewController: UIViewController, UITextFieldDelegate
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
    
    // to store the current active textfield
    var activeTextField : UITextField? = nil
    var screenMode = mode.firstScreen
    var initialTitle : String?
    var initialDescription: String?
    var initialSubmitTitle: String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        initialTitle = titleLabel.text
        initialDescription = descriptionLabel.text
        initialSubmitTitle = submitButton.title(for: .normal)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundTap))
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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
                let alertController = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("We're having trouble communicating with the server. Please try again later.", comment:""), preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default)
                { (action) in
                    //print("You've pressed cancel");
                    self.dismiss(animated: true, completion: nil)
                }
                
                alertController.addAction(okAction)
                self.present(alertController, animated:true)
                
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
            self.titleLabel.text = NSLocalizedString("Request sent successfully", comment:"")
            self.descriptionLabel.text = NSLocalizedString("Please check your inbox for a link to reset your password.", comment:"")
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveLinear, animations:
            {
                self.titleLabel.alpha = 1
                self.descriptionLabel.alpha = 1
                self.submitButton.setTitle(NSLocalizedString("Login", comment:""), for: .normal)
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
    
    //MARK: - Handle sliding view up/down so textfield isn't blocked by keyboard
    @objc func keyboardWillShow(notification: NSNotification)
    {
        
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else
        {
            
            // if keyboard size is not available for some reason, dont do anything
           return
        }
        
        var shouldMoveViewUp = false
        
        // if active text field is not nil
        if let activeTextField = activeTextField
        {
            
            let bottomOfTextField = activeTextField.convert(activeTextField.bounds, to: self.view).maxY;
            let topOfKeyboard = self.view.frame.height - keyboardSize.height
            
            if bottomOfTextField > topOfKeyboard
            {
                shouldMoveViewUp = true
            }
        }
        
        if(shouldMoveViewUp)
        {
            self.view.frame.origin.y = 0 - keyboardSize.height
        }
    }

    @objc func keyboardWillHide(notification: NSNotification)
    {
        self.view.frame.origin.y = 0
    }
    
    @objc func backgroundTap(_ sender: UITapGestureRecognizer)
    {
        // go through all of the textfield inside the view, and end editing thus resigning first responder
        // ie. it will trigger a keyboardWillHide notification
        self.view.endEditing(true)
    }
}
