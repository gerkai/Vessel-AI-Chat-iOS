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
import Lottie

class WelcomeSignInViewController: UIViewController, DebugViewControllerDelegate, VesselScreenIdentifiable, GenericAlertDelegate
{
    @IBOutlet private weak var mindLabel: UILabel!
    @IBOutlet private weak var debugButton: VesselButton!
    @IBOutlet private weak var environmentLabel: UILabel!
    @IBOutlet private weak var buttonStackView: UIStackView!
    @IBOutlet private weak var splashView: UIView!
    @IBOutlet private weak var animationContainerView: UIView!
    @IBOutlet private weak var vesselLogoImageView: UIImageView!
    
    var timer: Timer!
    var animationView: LottieAnimationView!
    
    @Resolved internal var analytics: Analytics
    let flowName: AnalyticsFlowName = .loginFlow
    
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
                 NSLocalizedString("calm", comment: ""),
                 NSLocalizedString("fitness", comment: "")]
    var goalIndex = 0
    let lock = [1, 0, 0, 0, 1, 0] //this is the pattern the user must enter (1 is right button, 0 is left button)
    var key = [0, 0, 0, 0, 0, 0]
    
    var leftButtonTaps = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //kick off first word
        mindLabel.text = goals[goalIndex]
        updateGoals()
        if UserDefaults.standard.bool(forKey: Constants.KEY_PRINT_INIT_DEINIT)
        {
            print("WelcomeSignIn did load")
        }
        
        if UserDefaults.standard.bool(forKey: Constants.KEY_DEBUG_MENU) == true
        {
            showDebugButton()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(hideSplashScreen), name: .hideSplashScreen, object: nil)
    }
    
    @objc func hideSplashScreen()
    {
        self.splashView.alpha = 0.0
    }
    
    func onAlertDismissed(_ alert: GenericAlertViewController, alertDescription: String)
    {
        //try connecting to the internet again.
        checkInternet()
    }
    
    func playAnimation()
    {
        animationView = .init(name: "splash_animation")
        animationView!.frame = animationContainerView.bounds
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .playOnce
        animationView!.animationSpeed = 1.0
        animationContainerView.addSubview(animationView!)
        animationView!.play
        {(isFinished) in
            if isFinished
            {
                self.checkInternet()
            }
        }
    }
    
    deinit
    {
        if UserDefaults.standard.bool(forKey: Constants.KEY_PRINT_INIT_DEINIT)
        {
            print("WelcomeSignIn deinit")
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        let savedEnvironment = UserDefaults.standard.integer(forKey: Constants.environmentKey)
        updateEnvironmentLabel(env: savedEnvironment)
        timer = Timer.scheduledTimer(timeInterval: labelRefreshInterval, target: self, selector: #selector(updateGoals), userInfo: nil, repeats: true)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        playAnimation()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        timer.invalidate()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let destination = segue.destination as? DebugViewController
        {
            destination.delegate = self
        }
    }
    
    func checkInternet()
    {
        if Reachability.isConnectedToNetwork()
        {
            if Server.shared.isLoggedIn()
            {
                ObjectStore.shared.loadMainContact
                { [weak self] in
                    guard let self = self else { return }
                    print("Successfully loaded contact during auto-login. Jumping to Onboarding")
                    LoginCoordinator.shared.pushLastViewController(to: self.navigationController)
                }
                onFailure:
                {
                    print("Unsuccessful at re-logging in. Making user sign-in again")
                    //fade splash screen in right away since we already spent time trying to load contact from back end
                    UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveLinear)
                    {
                        self.splashView.alpha = 0.0
                    }
                }
            }
            else
            {
                //fade splash screen in after 1 second. (Normal login flow)
                print("Normal sign-in flow. Not re-logging in.")
                UIView.animate(withDuration: 0.25, delay: 1.0, options: .curveLinear)
                {
                    self.splashView.alpha = 0.0
                }
            }
        }
        else
        {
            GenericAlertViewController.presentAlert(in: self, type: .titleSubtitleButton(title: GenericAlertLabelInfo(title: NSLocalizedString("Internet Error", comment: "")),
                                                                                         subtitle: GenericAlertLabelInfo(title: Constants.INTERNET_CONNECTION_STRING, alignment: .center, height: 40.0),
                                                                                         button: GenericAlertButtonInfo(label: GenericAlertLabelInfo(title: NSLocalizedString("OK", comment: "")), type: .dark)), delegate: self)
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
        //toggle Bugsee if user taps left button 50 times
        leftButtonTaps += 1
        if leftButtonTaps == 15
        {
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseOut)
            {
                self.vesselLogoImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }
            let allowBugsee = UserDefaults.standard.bool(forKey: Constants.ALLOW_BUGSEE_KEY)
            if allowBugsee == true
            {
                //disable bugsee
                UserDefaults.standard.removeObject(forKey: Constants.ALLOW_BUGSEE_KEY)
            }
            else
            {
                UserDefaults.standard.set(true, forKey: Constants.ALLOW_BUGSEE_KEY)
            }
        }
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
            showDebugButton()
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
    
    func showDebugButton()
    {
        //show debug button
        debugButton.showAnimated(in: buttonStackView)
        key.append(1)
        key.remove(at: 0)
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
