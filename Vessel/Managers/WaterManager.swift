//
//  WaterManager.swift
//  Vessel
//
//  Created by Nicolas Medina on 10/24/22.
//

import Foundation

class WaterManager
{
    static let shared = WaterManager()
    
    let lastOpenedDay = UserDefaults.standard.string(forKey: Constants.KEY_LAST_OPENED_DAY)
    let todayString: String = Date.serverDateFormatter.string(from: Date())
    
    func resetDrinkedWaterGlassesIfNeeded()
    {
        guard let mainContact = Contact.main() else { return }
        if todayString != lastOpenedDay
        {
            mainContact.drinkedWaterGlasses = 0
            ObjectStore.shared.ClientSave(mainContact)
            UserDefaults.standard.set(todayString, forKey: Constants.KEY_LAST_OPENED_DAY)
        }
    }
}
