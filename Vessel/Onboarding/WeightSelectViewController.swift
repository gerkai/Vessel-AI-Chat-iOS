//
//  WeightSelectViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 3/5/22.
//

import UIKit

class WeightSelectViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var weightTextField: UITextField!
    override func viewDidLoad()
    {
        super.viewDidLoad()

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundTap))
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func onBackButtonPressed(_ sender: Any)
    {
        self.navigationController?.fadeOut()
    }
    
    @IBAction func onContinueButtonPressed()
    {
        self.view.endEditing(true)
        if let weight = weightTextField.text, weight.count != 0
        {
            if let contact = Contact.main()
            {
                if let weight = weightTextField.text, let weightValue = Double(weight)
                {
                    contact.weight = weightValue
                    ObjectStore.shared.ClientSave(contact)
                }
            }
            let vc = OnboardingNextViewController()
            //{
                //navigationController?.pushViewController(vc, animated: true)
                navigationController?.fadeTo(vc)
            /*}
            else
            {
                self.navigationController?.popToRootViewController(animated: true)
                Server.shared.logOut()
            }*/
        }
        else
        {
            UIView.showError(text: "", detailText: NSLocalizedString("Please enter your weight", comment:""))
        }
    }
    
    //MARK: - textfield delegates
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        return true
    }
    
    //MARK: - Handle sliding view up/down so textfield isn't blocked by keyboard
    @objc func keyboardWillShow(notification: NSNotification)
    {
        
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else
        {
            // if keyboard size is not available for some reason, dont do anything
           return
        }
        self.view.frame.origin.y = 0 - keyboardSize.height
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
