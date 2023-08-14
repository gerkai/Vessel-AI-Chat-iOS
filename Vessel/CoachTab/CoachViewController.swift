//
//  CoachViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 8/3/22.
//

import UIKit
import LiveChat
import SwiftUI

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
        if UserDefaults.standard.bool(forKey: Constants.KEY_ENABLE_CHAT_GPT_COACH)
        {
//            let chatBot = ChatBotListView(viewModel: ChatBotViewModel())
            let chatBot = ChatBotView(viewModel: ChatBotViewModel())
            let viewController = UIHostingController(rootView: chatBot)
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: true)
        }
        else
        {
            LiveChatManager.shared.navigateToLiveChat(in: self)
        }
    }
    
    @objc
    func onToggleChatGPT()
    {
        let value = UserDefaults.standard.bool(forKey: Constants.KEY_ENABLE_CHAT_GPT_COACH)
        UserDefaults.standard.set(!value, forKey: Constants.KEY_ENABLE_CHAT_GPT_COACH)
        Log_Add("CHAT GPT COACH TOGGLED: \(UserDefaults.standard.bool(forKey: Constants.KEY_ENABLE_CHAT_GPT_COACH))")
    }
}
