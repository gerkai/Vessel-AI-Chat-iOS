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
        
        if userDiets.contains(Diet.ID.NONE.rawValue)
        {
            contact.diet_ids = []
        }
        else
        {
            contact.diet_ids = userDiets
        }
        
        if userAllergies.contains(Allergy.ID.NONE.rawValue)
        {
            contact.allergy_ids = []
        }
        else
        {
            contact.allergy_ids = userAllergies
        }
        
        contact.setDietsAnalytics()
        contact.setAllergiesAnalytics()
        
        ObjectStore.shared.ClientSave(contact)
    }
}
