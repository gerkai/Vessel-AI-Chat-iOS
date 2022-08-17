//
//  FoodPreferencesViewModel.swift
//  Vessel
//
//  Created by Nicolas Medina on 8/16/22.
//

import Foundation

class GoalsPreferencesViewModel
{
    var mainGoal: Int? = Contact.main()?.main_goal_id
    
    func anyItemChecked() -> Bool
    {
        if mainGoal == nil
        {
            return false
        }
        return true
    }
    func infoForItemAt(indexPath: IndexPath) -> (name: String, id: Int, imageName: String?)
    {
        let row = indexPath.row
        let goalID = Goal.ID.allCases[row]
        return (Goals[goalID]!.name.capitalized, goalID.rawValue, Goals[goalID]!.imageName)
    }
    
    func itemCount() -> Int
    {
        return Goal.ID.allCases.count
    }
    
    func itemIsChecked(id: Int) -> Bool
    {
        if mainGoal != nil
        {
            if mainGoal == id
            {
                return true
            }
        }
        return false
    }
    
    func selectItem(id: Int, selected: Bool)
    {
        if selected
        {
            let goalID = Goal.ID.allCases[id]
            mainGoal = goalID.rawValue
        }
        else
        {
            mainGoal = nil
        }
    }
    
    func save()
    {
        guard let contact = Contact.main() else { return }
        contact.main_goal_id = mainGoal

        ObjectStore.shared.ClientSave(contact)
    }
}
