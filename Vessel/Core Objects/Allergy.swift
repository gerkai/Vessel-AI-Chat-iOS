//
//  Allergy.swift
//  Vessel
//
//  Created by Carson Whitsett on 7/7/22.
//

import Foundation

struct Allergy
{
    var name: String
    
    enum ID: Int, CaseIterable
    {
        case PEANUTS = 6
        case SOY = 8
        case MILK = 2
        case WHEAT = 7
        case SEEDS = 10
        case SHELLFISH = 4
        case GLUTEN = 9
        case TREE_NUTS = 5
        case FISH = 3
        case EGGS = 1
        case NONE = 20
    }
}

let Allergies: [Allergy.ID: Allergy] =
    [Allergy.ID.PEANUTS: Allergy(name: NSLocalizedString("peanuts", comment: "Type of allergy")),
     Allergy.ID.SOY: Allergy(name: NSLocalizedString("soybeans", comment: "Type of allergy")),
     Allergy.ID.MILK: Allergy(name: NSLocalizedString("milk", comment: "Type of allergy")),
     Allergy.ID.WHEAT: Allergy(name: NSLocalizedString("wheat", comment: "Type of allergy")),
     Allergy.ID.SEEDS: Allergy(name: NSLocalizedString("seeds", comment: "Type of allergy")),
     Allergy.ID.SHELLFISH: Allergy(name: NSLocalizedString("crustacean", comment: "Type of allergy")),
     Allergy.ID.GLUTEN: Allergy(name: NSLocalizedString("gluten", comment: "Type of allergy")),
     Allergy.ID.TREE_NUTS: Allergy(name: NSLocalizedString("tree nuts", comment: "Type of allergy")),
     Allergy.ID.FISH: Allergy(name: NSLocalizedString("fish", comment: "Type of allergy")),
     Allergy.ID.EGGS: Allergy(name: NSLocalizedString("eggs", comment: "Type of allergy")),

     Allergy.ID.NONE: Allergy(name: NSLocalizedString("none", comment: "Type of allergy"))
]
