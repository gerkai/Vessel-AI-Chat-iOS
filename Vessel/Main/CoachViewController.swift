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
        navigateToLiveChat()
    }
}

extension CoachViewController: LiveChatDelegate
{
    func chatDismissed()
    {
        LiveChat.chatViewController!.dismiss(animated: true)
    }
}

private extension CoachViewController
{
    func navigateToLiveChat()
    {
        guard let contact = Contact.main() else { return }
        LiveChat.name = contact.fullName
        LiveChat.email = contact.email
        LiveChat.groupId = "2" //nutritionist coach group == 2  support == 1
        LiveChat.licenseId = Constants.LiveChatLicenseID
        LiveChat.delegate = self
        LiveChat.customPresentationStyleEnabled = true

        present(LiveChat.chatViewController!, animated: true)
    }
}
