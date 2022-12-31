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
        
        let gestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(onLaunchChat))
        imageView.addGestureRecognizer(gestureRecognizer2)
        
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
}
