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
    @IBOutlet weak var coachView: UIView!
    
    // MARK: - Model
    var flowName: AnalyticsFlowName = .coachTabFlow
    @Resolved internal var analytics: Analytics
    
    // MARK: - UIViewController Lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onCoachViewTapped))
        coachView.addGestureRecognizer(gestureRecognizer)
    }
    
    // MARK: - Actions
    @objc
    func onCoachViewTapped(gestureRecognizer: UIGestureRecognizer)
    {
        LiveChatManager.shared.navigateToLiveChat(in: self)
    }
}
