//
//  Diet.swift
//  Vessel
//
//  Created by Carson Whitsett on 7/7/22.
//

import Foundation

struct Diet
{
    //Diets in Onboarding are displayed in the order below
    enum ID: Int, CaseIterable
    {
        case VEGETARIAN = 1
        case VEGAN = 2
        case KETO = 3
        case PALEO = 4
        case LOW_FAT = 5
        case LOW_SUGAR = 6
        case LOW_CALORIE = 7
        case LOW_CARB = 8
        case NONE = 17
    }
    
    var name: String
}

let Diets: [Diet.ID: Diet] =
    [Diet.ID.VEGETARIAN: Diet(name: NSLocalizedString("vegetarian", comment: "Type of diet")),
     Diet.ID.VEGAN: Diet(name: NSLocalizedString("vegan", comment: "Type of diet")),
     Diet.ID.KETO: Diet(name: NSLocalizedString("keto", comment: "Type of diet")),
     Diet.ID.PALEO: Diet(name: NSLocalizedString("paleo", comment: "Type of diet")),
     Diet.ID.LOW_FAT: Diet(name: NSLocalizedString("low fat", comment: "Type of diet")),
     Diet.ID.LOW_SUGAR: Diet(name: NSLocalizedString("low sugar", comment: "Type of diet")),
     Diet.ID.LOW_CALORIE: Diet(name: NSLocalizedString("low calorie", comment: "Type of diet")),
     Diet.ID.LOW_CARB: Diet(name: NSLocalizedString("low carb", comment: "Type of diet")),
     Diet.ID.NONE: Diet(name: NSLocalizedString("none", comment: "Type of diet"))]
