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
    
    let lock = [1, 0, 0, 0, 1, 0] //this is the pattern the user must enter (1 is right button, 0 is left button)
    var key = [0, 0, 0, 0, 0, 0]
    
    let versionString: String =
    {
        let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        return "Version: \(appVersion) - Build: \(buildNumber)"
    }()
    
    func addDebugMenu()
    {
        options.append(.debug)
    }
}
