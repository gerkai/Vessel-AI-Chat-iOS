//
//  Diet.swift
//  Vessel
//
//  Created by Carson Whitsett on 7/7/22.
//

import Foundation

struct Diet
{
    var id: Int
    var name: String
}

let Diets: [Diet] = [Diet(id: 1, name: NSLocalizedString("vegetarian", comment: "Type of diet")),
                     Diet(id: 2, name: NSLocalizedString("vegan", comment: "Type of diet")),
                     Diet(id: 3, name: NSLocalizedString("keto", comment: "Type of diet")),
                     Diet(id: 4, name: NSLocalizedString("paleo", comment: "Type of diet")),
                     Diet(id: 5, name: NSLocalizedString("low fat", comment: "Type of diet")),
                     Diet(id: 6, name: NSLocalizedString("low sugar", comment: "Type of diet")),
                     Diet(id: 7, name: NSLocalizedString("low calorie", comment: "Type of diet")),
                     Diet(id: 8, name: NSLocalizedString("low carb", comment: "Type of diet")),
                     Diet(id: 17, name: NSLocalizedString("none", comment: "Type of diet"))
]
