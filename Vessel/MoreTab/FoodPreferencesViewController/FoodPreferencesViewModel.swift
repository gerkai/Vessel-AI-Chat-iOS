//
//  FoodPreferencesViewModel.swift
//  Vessel
//
//  Created by Nicolas Medina on 8/11/22.
//

import Foundation

class FoodPreferencesViewModel
{
    var selectedSegmentIndex = 0
    var userDiets: [Int] = Contact.main()?.diet_ids ?? []
    var userAllergies: [Int] = Contact.main()?.allergy_ids ?? []

    var itemType: ItemPreferencesType
    {
        if selectedSegmentIndex == 0
        {
            return .Diet
        }
        else
        {
            return .Allergy
        }
    }
    
    func anyItemChecked() -> Bool
    {
        switch itemType
        {
        case .Diet:
            if userDiets.count == 0
            {
                return false
            }
            return true
        case .Allergy:
            if userAllergies.count == 0
            {
                return false
            }
            return true
        default:
            return false
        }
    }
    
    func infoForItemAt(indexPath: IndexPath, type: ItemPreferencesType) -> (name: String, id: Int, imageName: String?)
    {
        let row = indexPath.row
        switch type
        {
        case .Diet:
            let dietID = Diet.ID.allCases[row]
            return (Diets[dietID]!.name.capitalized, dietID.rawValue, imageName: nil)
        case .Allergy:
            let allergyID = Allergy.ID.allCases[row]
            return (Allergies[allergyID]!.name.capitalized, allergyID.rawValue, imageName: nil)
        default:
            return ("", -1, nil)
        }
    }
    
    func itemCount() -> Int
    {
        switch itemType
        {
        case .Diet:
            return Diets.count
        case .Allergy:
            return Allergies.count
        default:
            return 0
        }
    }
    func itemIsChecked(id: Int) -> Bool
    {
        var result = false
        switch itemType
        {
            case .Diet:
                for dietID in userDiets
                {
                    if dietID == id
                    {
                        result = true
                        break
                    }
                }
            case .Allergy:
                for allergyID in userAllergies
                {
                    if allergyID == id
                    {
                        result = true
                        break
                    }
                }
                
        default:
            break
        }
        return result
    }
    
    func selectItem(id: Int, selected: Bool)
    {
        //this will add/remove selected items from the chosen[items] array based on selected parameter.
        //If user selects NONE then any previously selected items are erased.
        //If user selects any item while NONE is selected, then NONE will be cleared.
        switch itemType
        {
        case .Diet:
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
            
        case .Allergy:
            
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
        default:
            break
        }
    }
    
    func save()
    {
        guard let contact = Contact.main() else { return }
        contact.diet_ids = userDiets
        contact.allergy_ids = userAllergies
        
        ObjectStore.shared.ClientSave(contact)
    }
}
