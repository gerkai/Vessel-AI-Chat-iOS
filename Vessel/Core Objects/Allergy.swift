//
//  Allergy.swift
//  Vessel
//
//  Created by Carson Whitsett on 7/7/22.
//

import Foundation

struct Allergy
{
    var id: Int
    var name: String
}

let Allergies: [Allergy] = [Allergy(id: 4, name: NSLocalizedString("crustacean", comment: "Type of allergy")),
                            Allergy(id: 1, name: NSLocalizedString("eggs", comment: "Type of allergy")),
                            Allergy(id: 3, name: NSLocalizedString("fish", comment: "Type of allergy")),
                            Allergy(id: 9, name: NSLocalizedString("gluten", comment: "Type of allergy")),
                            Allergy(id: 2, name: NSLocalizedString("milk", comment: "Type of allergy")),
                            Allergy(id: 6, name: NSLocalizedString("peanuts", comment: "Type of allergy")),
                            Allergy(id: 10, name: NSLocalizedString("seeds", comment: "Type of allergy")),
                            Allergy(id: 8, name: NSLocalizedString("soybeans", comment: "Type of allergy")),
                            Allergy(id: 5, name: NSLocalizedString("tree nuts", comment: "Type of allergy")),
                            Allergy(id: 7, name: NSLocalizedString("wheat", comment: "Type of allergy")),
                            Allergy(id: 20, name: NSLocalizedString("none", comment: "Type of allergy"))
]
