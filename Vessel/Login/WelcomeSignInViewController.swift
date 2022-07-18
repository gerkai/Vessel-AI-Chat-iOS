//
//  WelcomeSignInViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 2/25/22.
//  Based on Login Flow: https://www.notion.so/vesselhealth/Login-2dbc7f76cf4c4953abd8b4aa7bc34bc5
//
//  User can bring up debugViewController by tapping left and right buttons (invisible and located near top of screen)
//  in order specified by "lock" array below. After tapping in the correct order, tap the create account button to
//  reveal a new Debug button.

import UIKit

class WelcomeSignInViewController: UIViewController, DebugViewControllerDelegate
{
    @IBOutlet private weak var mindLabel: UILabel!
    @IBOutlet private weak var debugButton: VesselButton!
    @IBOutlet private weak var environmentLabel: UILabel!
    @IBOutlet private weak var buttonStackView: UIStackView!
    @IBOutlet private weak var splashView: UIView!
    
    let labelRefreshInterval = 2.0 //Seconds
    
    //these are the words that animate under "In pursuit of better"
    let goals = [NSLocalizedString("focus", comment: ""),
                 NSLocalizedString("energy", comment: ""),
                 NSLocalizedString("immunity", comment: ""),
                 NSLocalizedString("sleep", comment: ""),
                 NSLocalizedString("body", comment: ""),
                 NSLocalizedString("mood", comment: ""),
                 NSLocalizedString("digestion", comment: ""),
                 NSLocalizedString("beauty", comment: ""),
                 NSLocalizedString("living", comment: "")]
    var goalIndex = 0
    let lock = [1, 0, 0, 0, 1, 0] //this is the pattern the user must enter (1 is right button, 0 is left button)
    var key = [0, 0, 0, 0, 0, 0]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        Timer.scheduledTimer(timeInterval: labelRefreshInterval, target: self, selector: #selector(updateGoals), userInfo: nil, repeats: true)
        //kick off first word
        mindLabel.text = goals[goalIndex]
        updateGoals()
        UIView.animate(withDuration: 0.25, delay: 1.0, options: .curveLinear)
        {
            self.splashView.alpha = 0.0
        }
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        logPageViewed()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        let savedEnvironment = UserDefaults.standard.integer(forKey: Constants.environmentKey)
        updateEnvironmentLabel(env: savedEnvironment)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let destination = segue.destination as? DebugViewController
        {
            destination.delegate = self
        }
    }
    
    @objc func updateGoals()
    {
        mindLabel.text = goals[goalIndex]
        mindLabel.pushTransition(labelRefreshInterval / 2)
        mindLabel.fadeIn(duration: labelRefreshInterval / 2)
        mindLabel.fadeOut(duration: labelRefreshInterval)
        goalIndex += 1
        if(goalIndex == goals.count)
        {
            goalIndex = 0
        }
    }
    
    @IBAction func onLeftButton()
    {
        key.append(0)
        key.remove(at: 0)
        //print("LEFT: \(key)")
    }
    
    @IBAction func onRightButton()
    {
        key.append(1)
        key.remove(at: 0)
        //print("RIGHT: \(key)")
    }
    
    @IBAction func onDebug()
    {
        performSegue(withIdentifier: "showDebug", sender: self)
    }
    
    @IBAction func onSignIn()
    {
        //begin login flow
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        self.navigationController?.fadeTo(vc)
    }
    
    @IBAction func onCreateAccount()
    {
        if key == lock
        {
            //show debug button
            debugButton.showAnimated(in: buttonStackView)
            key.append(1)
            key.remove(at: 0)
        }
        else
        {
            //begin create account flow
            //performSegue(withIdentifier: "createAccount", sender: self)
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SignupEmailCheckingViewController")
            self.navigationController?.fadeTo(vc)
        }
    }
    
    func updateEnvironmentLabel(env: Int)
    {
        switch env
        {
        case Constants.PROD_INDEX:
            environmentLabel.isHidden = true
        case Constants.STAGING_INDEX:
            environmentLabel.isHidden = false
            environmentLabel.text = "Staging Environment"
        default:
            environmentLabel.isHidden = false
            environmentLabel.text = "Dev Environment"
        }
    }
    
    func didChangeEnvironment(env: Int)
    {
        updateEnvironmentLabel(env: env)
    }
}
