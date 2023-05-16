//
//  CoachViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 8/3/22.
//

import UIKit
import LiveChat

class CoachViewController: UIViewController, VesselScreenIdentifiable
{
    // MARK: - View
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Model
    var flowName: AnalyticsFlowName = .coachTabFlow
    @Resolved internal var analytics: Analytics
    
    // MARK: - UIViewController Lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onToggleChatGPT))
        gestureRecognizer.numberOfTapsRequired = 3
        imageView.addGestureRecognizer(gestureRecognizer)
        
//        let gestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(onLaunchChat))
//        imageView.addGestureRecognizer(gestureRecognizer2)
        
        if UserDefaults.standard.bool(forKey: Constants.KEY_PRINT_INIT_DEINIT)
        {
            print("❇️ \(self)")
        }
    }
    
    deinit
    {
        if UserDefaults.standard.bool(forKey: Constants.KEY_PRINT_INIT_DEINIT)
        {
            print("❌ \(self)")
        }
    }
    
    // MARK: - Actions

    @IBAction func onLaunchChat()
    {
        LiveChatManager.shared.navigateToLiveChat(in: self)
    }
    
    @objc
    func onToggleChatGPT()
    {
        let value = UserDefaults.standard.bool(forKey: Constants.KEY_ENABLE_CHAT_GPT_COACH)
        UserDefaults.standard.set(!value, forKey: Constants.KEY_ENABLE_CHAT_GPT_COACH)
        Log_Add("CHAT GPT COACH TOGGLED: \(UserDefaults.standard.bool(forKey: Constants.KEY_ENABLE_CHAT_GPT_COACH))")
    }
}
