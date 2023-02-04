//
//  MoreViewModel.swift
//  Vessel
//
//  Created by Nicolas Medina on 7/25/22.
//  Based on the More Tab Flow: https://www.notion.so/vesselhealth/More-Tab-d69ecf4a2e60469096da1f96f33ca01a
//

import Foundation

//var moreViewModel: MoreViewModel?

enum MoreTabOptions
{
    case myAccount
    case takeATest
    case orderCards
    case customSupplements
    case chatWithNutritionist
    case backedByScience
    case support
    case debug
    case debugLog
    
    var icon: String
    {
        switch self
        {
        case .myAccount:
            return "myAccountIcon"
        case .takeATest:
            return "takeATestIcon"
        case .orderCards:
            return "orderCardsIcon"
        case .customSupplements:
            return "customSupplementsIcon"
        case .chatWithNutritionist:
            return "chatWithNutritionistIcon"
        case .backedByScience:
            return "backedByScienceIcon"
        case .support:
            return "supportIcon"
        case .debug:
            return "InsightsIcon"
        case .debugLog:
            return "InsightsIcon"
        }
    }
    
    var text: String
    {
        switch self
        {
        case .myAccount:
            return NSLocalizedString("My Account", comment: "")
        case .takeATest:
            return NSLocalizedString("Take a Test", comment: "")
        case .orderCards:
            return NSLocalizedString("Order Cards", comment: "")
        case .customSupplements:
            return NSLocalizedString("Custom Supplements", comment: "")
        case .chatWithNutritionist:
            return NSLocalizedString("Chat with a Nutritionist", comment: "")
        case .backedByScience:
            return NSLocalizedString("Backed by Science", comment: "")
        case .support:
            return NSLocalizedString("Support", comment: "")
        case .debug:
            return NSLocalizedString("Debug Menu", comment: "")
        case .debugLog:
            return NSLocalizedString("Debug Log", comment: "")
        }
    }
}

class MoreViewModel
{
    var options: [MoreTabOptions] =
    [
        .myAccount,
        .takeATest,
        .orderCards,
        .customSupplements,
        .chatWithNutritionist,
        .backedByScience,
        .support
    ]
    
    let debugMenuLock = [1, 0, 0, 0, 1, 0] //this is the pattern the user must enter (1 is right button, 0 is left button)
    let debugLogLock = [1, 0, 0, 0, 0, 1] //enter this pattern to expose the debug log
    var key = [0, 0, 0, 0, 0, 0]
    
    let versionString: String =
    {
        let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        return "Version: \(appVersion) - Build: \(buildNumber)"
    }()
    
    func addDebugMenu()
    {
        UserDefaults.standard.set(true, forKey: Constants.KEY_DEBUG_MENU)
        options.append(.debug)
    }
    
    func removeDebugMenu()
    {
        UserDefaults.standard.removeObject(forKey: Constants.KEY_DEBUG_MENU)
        let index = options.firstIndex(of: .debug)!
        options.remove(at: index)
    }
    
    func addDebugLog()
    {
        UserDefaults.standard.set(true, forKey: Constants.KEY_DEBUG_LOG)
        options.append(.debugLog)
    }
    
    func removeDebugLog()
    {
        UserDefaults.standard.removeObject(forKey: Constants.KEY_DEBUG_LOG)
        let index = options.firstIndex(of: .debugLog)!
        options.remove(at: index)
    }
    
    func shouldShowPractitionerSection() -> Bool
    {
        if Contact.main()!.expert_id == nil
        {
            return false
        }
        return true
    }
    
    //attempts to return expert business name. If nil, attempts to return expert first & last name. If also nil, name = ""
    //if download_url is nil, returns failure (as we cannot generate a QR code then). Otherwise returns the download_url.
    func practitionerInfo(onSuccess success: @escaping (_ name: String, _ qrString: String) -> Void, onFailure failure: @escaping () -> Void) -> ()
    {
        if let expertID = Contact.main()!.expert_id
        {
            ObjectStore.shared.get(type: Expert.self, id: expertID)
            { expert in
                var name = ""
                if expert.business_name != nil
                {
                    name = expert.business_name!
                }
                else
                {
                    if let firstName = expert.first_name, let lastName = expert.last_name
                    {
                        name = firstName + " " + lastName
                    }
                }
                if expert.url_code != nil
                {
                    success(name, expert.url_code!)
                }
                else
                {
                    failure()
                }
            }
            onFailure:
            {
                failure()
            }
        }
    }
}
