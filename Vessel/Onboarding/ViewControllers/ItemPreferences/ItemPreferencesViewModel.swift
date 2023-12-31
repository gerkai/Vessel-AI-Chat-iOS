//
//  ItemPreferencesViewModel.swift
//  Vessel
//
//  Created by Nicolas Medina on 8/26/22.
//

import Foundation

enum ItemPreferencesType
{
    case diet
    case allergy
    case goals
}

class ItemPreferencesViewModel
{
    var userDiets: [Int] = []
    var userAllergies: [Int] = []
    var userGoals: [Int] = []
    var mainGoal: Int?
    var type: ItemPreferencesType = .diet
    var titleText: String?
    var subtext: String?
    var hideBackground: Bool
    
    init()
    {
        userDiets = []
        userAllergies = []
        userGoals = []
        type = .diet
        hideBackground = false
        if UserDefaults.standard.bool(forKey: Constants.KEY_PRINT_INIT_DEINIT)
        {
            print("✳️ \(self)")
        }
    }
    
    deinit
    {
        if UserDefaults.standard.bool(forKey: Constants.KEY_PRINT_INIT_DEINIT)
        {
            print("❌ \(self)")
        }
    }
    
    func anyItemChecked() -> Bool
    {
        switch type
        {
        case .diet:
            if userDiets.count == 0
            {
                return false
            }
            return true
        case .allergy:
            if userAllergies.count == 0
            {
                return false
            }
            return true
        case .goals:
            if userGoals.count < Constants.MIN_GOALS_AT_A_TIME
            {
                return false
            }
            return true
        }
    }
    func infoForItemAt(indexPath: IndexPath) -> (name: String, id: Int, imageName: String?)
    {
        let row = indexPath.row
        switch type
        {
        case .diet:
            let dietID = Diet.ID.allCases[row]
            return (Diets[dietID]!.name.capitalized, dietID.rawValue, imageName: nil)
        case .allergy:
            let allergyID = Allergy.ID.allCases[row]
            return (Allergies[allergyID]!.name.capitalized, allergyID.rawValue, imageName: nil)
        case .goals:
            let goalID = Goal.ID.allCases[row]
            return (Goals[goalID]!.name.capitalized, goalID.rawValue, imageName: nil)
        }
    }
    
    func itemCount() -> Int
    {
        switch type
        {
        case .diet:
            return Diets.count
        case .allergy:
            return Allergies.count
        case .goals:
            return Goals.count
        }
    }
    
    func itemIsChecked(id: Int) -> Bool
    {
        var result = false
        switch type
        {
        case .diet:
            for dietID in userDiets
            {
                if dietID == id
                {
                    result = true
                    break
                }
            }
        case .allergy:
            for allergyID in userAllergies
            {
                if allergyID == id
                {
                    result = true
                    break
                }
            }
            
        case .goals:
            for goalID in userGoals
            {
                if goalID == id
                {
                    result = true
                    break
                }
            }
        }
        return result
    }
    
    func itemTapped(id: Int)
    {
        //this will add/remove selected items from the chosen[items] array based on selected parameter.
        //If user selects NONE then any previously selected items are erased.
        //If user selects any item while NONE is selected, then NONE will be cleared.
        switch type
        {
            case .diet:
                if userDiets.contains(id)
                {
                    //remove dietID from array
                    userDiets = userDiets.filter(){$0 != id}
                }
                else
                {
                    //add id to userDiets
                    let noDietID = Diet.ID.NONE.rawValue
                    if id == noDietID
                    {
                        //clear any previously chosen diets
                        userDiets = [noDietID]
                    }
                    else
                    {
                        //remove NO_DIETS item and append new item
                        userDiets = userDiets.filter(){$0 != noDietID}
                        userDiets.append(id)
                    }
                }
            case .allergy:
                if userAllergies.contains(id)
                {
                    //remove allergy from array
                    userAllergies = userAllergies.filter(){$0 != id}
                }
                else
                {
                    //add id to userAllergies
                    let noAllergyID = Allergy.ID.NONE.rawValue
                    if id == noAllergyID
                    {
                        //clear any previously chosen allergies
                        userAllergies = [noAllergyID]
                    }
                    else
                    {
                        //remove NO_ALLERGIES item and append new item
                        userAllergies = userAllergies.filter(){$0 != noAllergyID}
                        userAllergies.append(id)
                    }
                }
            case .goals:
                if userGoals.contains(id)
                {
                    //remove id from chosenGoals
                    userGoals = userGoals.filter(){$0 != id}
                }
                else
                {
                    userGoals.append(id)
                    
                    //only allow maximum selected amount. If user selects more, delete the oldest
                    if userGoals.count > Constants.MAX_GOALS_AT_A_TIME
                    {
                        userGoals.removeFirst()
                    }
                }
        }
    }
    
    func tooFewItemsSelectedText() -> String
    {
        let defaultText = NSLocalizedString("Please select an answer", comment: "Error message when user hasn't yet made a selection")
        switch type
        {
        case .diet:
            return defaultText
        case .allergy:
            return defaultText
        case .goals:
            return NSLocalizedString("Please select at least 1 goal", comment: "Error message when user hasn't chosen 3 goals")
        }
    }
}
