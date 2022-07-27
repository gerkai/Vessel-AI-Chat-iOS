//
//  MyAccountViewModel.swift
//  Vessel
//
//  Created by Nicolas Medina on 7/26/22.
//

import Foundation

enum MyAccountOptions
{
    case profile
    case manageMyGoals
    case manageMyDietOrAllergies
    case manageMembership
    
    var title: String
    {
        switch self
        {
        case .profile: return NSLocalizedString("Profile", comment: "")
        case .manageMyGoals: return NSLocalizedString("Manage my Goals", comment: "")
        case .manageMyDietOrAllergies: return NSLocalizedString("Manage my Diet/Allergies", comment: "")
        case .manageMembership: return NSLocalizedString("Manage Membership", comment: "")
        }
    }
}

class MyAccountViewModel
{
    let options: [MyAccountOptions] =
    [
        .profile,
        .manageMyGoals,
        .manageMyDietOrAllergies,
        .manageMembership
    ]
}
