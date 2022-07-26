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
        }
    }
    
    var text: String
    {
        switch self
        {
        case .myAccount:
            return "My Account"
        case .takeATest:
            return "Take a Test"
        case .orderCards:
            return "Order Cards"
        case .customSupplements:
            return "Custom Supplements"
        case .chatWithNutritionist:
            return "Chat with a Nutritionist"
        case .backedByScience:
            return "Backed by Science"
        case .support:
            return "Support"
        }
    }
}

class MoreViewModel
{
    let options: [MoreTabOptions] =
    [
        .myAccount,
        .takeATest,
        .orderCards,
        .customSupplements,
        .chatWithNutritionist,
        .backedByScience,
        .support
    ]
    
    let versionString: String = {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        return "Version \(appVersion)"
    }()
}
