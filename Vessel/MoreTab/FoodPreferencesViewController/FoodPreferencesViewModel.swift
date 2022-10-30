//
//  FoodPreferencesViewModel.swift
//  Vessel
//
//  Created by Nicolas Medina on 8/11/22.
//

import Foundation

class FoodPreferencesViewModel: ItemPreferencesViewModel
{
    // MARK: - Public interface
    var isLoading = false
    
    var onContactSaved: (() -> ())?
    var onError: ((_ error: String) -> ())?
    
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
        isLoading = true
        guard Reachability.isConnectedToNetwork() else
        {
            isLoading = false
            onError?(Constants.INTERNET_CONNECTION_STRING)
            return
        }
        
        guard let contact = Contact.main() else { return }
        contact.diet_ids = userDiets
        contact.allergy_ids = userAllergies
        
        contact.setDietsAnalytics()
        contact.setAllergiesAnalytics()
        
        ObjectStore.shared.ClientSave(contact)
        NotificationCenter.default.post(name: .foodPreferencesChangedNotification, object: nil)
        isLoading = false
        onContactSaved?()
    }
}
