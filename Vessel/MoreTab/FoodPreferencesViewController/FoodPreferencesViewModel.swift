//
//  FoodPreferencesViewModel.swift
//  Vessel
//
//  Created by Nicolas Medina on 8/11/22.
//

import Foundation

class FoodPreferencesViewModel: ItemPreferencesViewModel
{
    var selectedSegmentIndex = 0
    {
        didSet
        {
            if selectedSegmentIndex == 0
            {
                type = .diet
            }
            else
            {
                type = .allergy
            }
        }
    }
    
    override init()
    {
        super.init()
        userDiets = Contact.main()?.diet_ids ?? []
        userAllergies = Contact.main()?.allergy_ids ?? []
    }
    
    func save()
    {
        guard let contact = Contact.main() else { return }
        contact.diet_ids = userDiets
        contact.allergy_ids = userAllergies
        
        contact.setDietsAnalytics()
        contact.setAllergiesAnalytics()
        
        ObjectStore.shared.ClientSave(contact)
        NotificationCenter.default.post(name: .foodPreferencesChangedNotification, object: nil)
    }
}
