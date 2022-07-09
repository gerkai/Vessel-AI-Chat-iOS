//
//  DebugViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 2/25/22.
//  Based on Login Flow: https://www.notion.so/vesselhealth/Login-2dbc7f76cf4c4953abd8b4aa7bc34bc5

import UIKit
protocol DebugViewControllerDelegate: AnyObject
{
    func didChangeEnvironment(env: Int)
}

class DebugViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var environmentControl: UISegmentedControl!
    @IBOutlet weak var defaultLoginNameTextField: UITextField!
    @IBOutlet weak var defaultLoginPasswordTextField: UITextField!
    @IBOutlet weak var defaultWeightTextField: UITextField!
    
    var savedEnvironment: Int!
    var delegate: DebugViewControllerDelegate?
    let emailFieldTag = 0
    let passwordFieldTag = 1
    let weightFieldTag = 2
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        savedEnvironment = UserDefaults.standard.integer(forKey: Constants.environmentKey)
        environmentControl.selectedSegmentIndex = savedEnvironment
        
        //bypass appearance settings for this control
        let font = UIFont(name: "BananaGrotesk-Semibold", size: 16.0)!
        let selectedAttribute: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: UIColor.black]
        environmentControl.setTitleTextAttributes(selectedAttribute, for: .selected)
        
        if let email = UserDefaults.standard.string(forKey: Constants.KEY_DEFAULT_LOGIN_EMAIL)
        {
            defaultLoginNameTextField.text = email
        }
        if let pw = UserDefaults.standard.string(forKey: Constants.KEY_DEFAULT_LOGIN_PASSWORD)
        {
            defaultLoginPasswordTextField.text = pw
        }
        if let weight = UserDefaults.standard.string(forKey: Constants.KEY_DEFAULT_WEIGHT_LBS)
        {
            defaultWeightTextField.text = weight
        }
    }
    
    deinit
    {
        if environmentControl.selectedSegmentIndex != savedEnvironment
        {
            UserDefaults.standard.set(environmentControl.selectedSegmentIndex, forKey: Constants.environmentKey)
        }
    }
    
    @IBAction func onEnvironment(_ sender: UISegmentedControl)
    {
        delegate?.didChangeEnvironment(env: environmentControl.selectedSegmentIndex)
        switch sender.selectedSegmentIndex
        {
            case Constants.PROD_INDEX:
                print("PROD")
            case Constants.STAGING_INDEX:
                print("STAGING")
            default:
                print("DEV")
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        let text = textField.text ?? ""
        
        if textField.tag == emailFieldTag
        {
            if text.count == 0
            {
                UserDefaults.standard.removeObject(forKey: Constants.KEY_DEFAULT_LOGIN_EMAIL)
            }
            else
            {
                UserDefaults.standard.set(textField.text, forKey:Constants.KEY_DEFAULT_LOGIN_EMAIL)
            }
        }
        else if textField.tag == passwordFieldTag
        {
            if text.count == 0
            {
                UserDefaults.standard.removeObject(forKey: Constants.KEY_DEFAULT_LOGIN_PASSWORD)
            }
            else
            {
                UserDefaults.standard.set(textField.text, forKey:Constants.KEY_DEFAULT_LOGIN_PASSWORD)
            }
        }
        else if textField.tag == weightFieldTag
        {
            if text.count == 0
            {
                UserDefaults.standard.removeObject(forKey: Constants.KEY_DEFAULT_WEIGHT_LBS)
            }
            else
            {
                UserDefaults.standard.set(textField.text, forKey:Constants.KEY_DEFAULT_WEIGHT_LBS)
            }
        }
    }
}
