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
        guard let contact = Contact.main(),
              let accessToken = Server.shared.accessToken else
        {
            assertionFailure("LiveChatManager-navigateToLiveChat: mainContact or accessToken not available")
            return
        }
        LiveChat.name = contact.fullName
        LiveChat.email = contact.email
        LiveChat.groupId = UserDefaults.standard.bool(forKey: Constants.KEY_ENABLE_CHAT_GPT_COACH) ? "10" : "2" //nutritionist coach group == 2  support == 1 chatGPT = 10
        LiveChat.licenseId = Constants.LiveChatLicenseID
        LiveChat.delegate = self
        LiveChat.customPresentationStyleEnabled = true
        LiveChat.setVariable(withKey: "access_token", value: accessToken)

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
