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
    case mainGoal
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
    }
    
    deinit
    {
        if UserDefaults.standard.bool(forKey: Constants.KEY_PRINT_INIT_DEINIT)
        {
            print("📘 deinit \(self)")
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
            if userGoals.count < Constants.MAX_GOALS_AT_A_TIME
            {
                return false
            }
            return true
        case .mainGoal:
            if mainGoal == nil
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
        case .mainGoal:
            //search the 3 goals the user selected if onboarding
            // if goalsPreferences should appear all cases
            let goalID = userGoals.count > 0 ? Goal.ID.allCases[userGoals[row]] : Goal.ID.allCases[row]
            return (Goals[goalID]!.name.capitalized, goalID.rawValue, Goals[goalID]!.imageName)
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
        case .mainGoal:
            return userGoals.count > 0 ? userGoals.count : Goal.ID.allCases.count
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
        case .mainGoal:
            if mainGoal != nil
            {
                if mainGoal == id
                {
                    return true
                }
            }
            return false
        }
        return result
    }
    
    func selectItem(id: Int, selected: Bool)
    {
        //this will add/remove selected items from the chosen[items] array based on selected parameter.
        //If user selects NONE then any previously selected items are erased.
        //If user selects any item while NONE is selected, then NONE will be cleared.
        switch type
        {
        case .diet:
            if selected
            {
                //add id to userDiets
                if id == Constants.ID_NO_DIETS
                {
                    //clear any previously chosen diets
                    userDiets = []
                }
                else
                {
                    //remove ID_NO_DIET from chosenDiets
                    userDiets = userDiets.filter(){$0 != Constants.ID_NO_DIETS}
                }
                userDiets.append(id)
            }
            else
            {
                //remove dietID from chosenDiets
                userDiets = userDiets.filter(){$0 != id}
            }
            
        case .allergy:
            
            if selected
            {
                //add id to chosenDiets
                if id == Constants.ID_NO_ALLERGIES
                {
                    //clear any previously chosen ids
                    userAllergies = []
                }
                else
                {
                    //remove ID_NO_ALLERGIES from userAllergies
                    userAllergies = userAllergies.filter(){$0 != Constants.ID_NO_ALLERGIES}
                }
                userAllergies.append(id)
            }
            else
            {
                //remove id from chosenDiets
                userAllergies = userAllergies.filter(){$0 != id}
            }
            
        case .goals:
            if selected
            {
                //only allow maximum selected amount. If user selects more, delete the oldest
                if userGoals.count >= Constants.MAX_GOALS_AT_A_TIME
                {
                    userGoals.removeFirst()
                }
                //add id to chosenGoals
                userGoals.append(id)
            }
            else
            {
                //remove id from chosenGoals
                userGoals = userGoals.filter(){$0 != id}
            }
            
        case .mainGoal:
            if selected
            {
                if userGoals.count > 0
                {
                    mainGoal = id
                }
                else
                {
                    let goalID = Goal.ID.allCases[id]
                    mainGoal = goalID.rawValue
                }
            }
            else
            {
                mainGoal = nil
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
            return NSLocalizedString("Please choose 3 goals", comment: "Error message when user hasn't chosen 3 goals")
        case .mainGoal:
            return defaultText
        }
    }
}
