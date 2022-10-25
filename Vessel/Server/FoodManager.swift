//
//  FoodManager.swift
//  Vessel
//
//  Created by Nicolas Medina on 10/15/22.
//
// This is a temporary class made to manage foods

import Foundation

class FoodManager
{
    static let shared = FoodManager()
    var foods = Storage.retrieve(as: Food.self)
    let lastUpdated: Int = UserDefaults.standard.object(forKey: Constants.FOODS_LAST_UPDATED_DATE) as? Int ?? 1
    
    func loadFoods()
    {
        ObjectStore.shared.loadFoods(lastUpdated: lastUpdated)
        { [weak self] foods in
            guard let self = self else { return }
            self.foods = foods
        } onFailure: { error in
            print(error)
        }
    }
}
