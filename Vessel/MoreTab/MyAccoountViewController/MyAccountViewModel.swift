//
//  MyAccountViewModel.swift
//  Vessel
//
//  Created by Nicolas Medina on 7/26/22.
//

import UIKit

enum MyAccountOptions: String
{
    case profile = "Profile"
    case manageMyGoals = "Manage my Goals"
    case manageMyDietOrAllergies = "Manage my Diet/Allergies"
    case manageMembership = "Manage Membership"
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
