//
//  LiveChatManager.swift
//  Vessel
//
//  Created by Nicolas Medina on 10/20/22.
//

import Foundation
import LiveChat

class LiveChatManager: NSObject
{
    static let shared = LiveChatManager()
    
    func navigateToLiveChat(in viewController: UIViewController)
    {
        guard let contact = Contact.main() else { return }
        LiveChat.name = contact.fullName
        LiveChat.email = contact.email
        LiveChat.groupId = "2" //nutritionist coach group == 2  support == 1
        LiveChat.licenseId = Constants.LiveChatLicenseID
        LiveChat.delegate = self
        LiveChat.customPresentationStyleEnabled = true

        viewController.present(LiveChat.chatViewController!, animated: true)
    }
}

extension LiveChatManager: LiveChatDelegate
{
    func chatDismissed()
    {
        LiveChat.chatViewController!.dismiss(animated: true)
    }
}
