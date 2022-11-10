//
//  ZendeskManager.swift
//  Vessel
//
//  Created by Nicolas Medina on 10/19/22.
//

import Foundation
import ZendeskCoreSDK
import SupportSDK
import MessagingSDK
import ChatSDK
import ChatProvidersSDK

protocol ZendeskManagerDelegate: AnyObject
{
    func onZendeskDismissed()
}

class ZendeskManager: NSObject
{
    static let shared = ZendeskManager()
    weak var viewController: UIViewController?
    weak var delegate: ZendeskManagerDelegate?
    
    func navigateToChatWithSupport(in viewController: UIViewController, delegate: ZendeskManagerDelegate? = nil)
    {
        self.delegate = delegate
        guard let contact = Contact.main(),
              let token = Server.shared.accessToken else { return }
        
        self.viewController = viewController
        let identity = Identity.createJwt(token: token)
        Zendesk.instance?.setIdentity(identity)
        do
        {
            let chatAPIConfiguration = ChatAPIConfiguration()
            let chatConfiguration = ChatConfiguration()
            
            chatConfiguration.isPreChatFormEnabled = false
            chatConfiguration.chatMenuActions = []
            chatAPIConfiguration.departmentName = "Support"
            chatConfiguration.isAgentAvailabilityEnabled = true
            chatAPIConfiguration.visitorInfo = .init(
                name: contact.fullName,
                email: contact.email ?? ""
            )
            Chat.instance?.configuration = chatAPIConfiguration
            let chatEngine = try ChatEngine.engine()
            let chatViewController = try Messaging.instance.buildUI(engines: [chatEngine], configs: [chatConfiguration])
            chatViewController.title = "Chat with customer support"
            let button = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(dismissChatView))
            chatViewController.navigationItem.leftBarButtonItem = button
            let chatNavigationController = UINavigationController(rootViewController: chatViewController)
            chatNavigationController.modalPresentationStyle = .overFullScreen
            viewController.present(chatNavigationController, animated: true)
        }
        catch
        {
        }
    }
    
    @objc
    private func dismissChatView()
    {
        viewController?.dismiss(animated: true, completion: nil)
        delegate?.onZendeskDismissed()
        delegate = nil
    }
}
