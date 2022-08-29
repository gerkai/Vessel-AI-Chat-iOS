//
//  FoodPreferencesViewModel.swift
//  Vessel
//
//  Created by Nicolas Medina on 8/16/22.
//

import Foundation

class GoalsPreferencesViewModel: ItemPreferencesViewModel
{
    override init()
    {
        super.init()
        mainGoal = Contact.main()?.main_goal_id
        type = .mainGoal
    }
    
    func save()
    {
        guard let contact = Contact.main() else { return }
        contact.main_goal_id = mainGoal

        ObjectStore.shared.ClientSave(contact)
    }
}
