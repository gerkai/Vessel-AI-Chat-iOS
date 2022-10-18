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
    
    var foods = [Food]()
    
    func loadFoods()
    {
        Server.shared.getAllFoods { foods in
            self.foods.append(contentsOf: foods)
            NotificationCenter.default.post(name: .foodsLoaded, object: nil, userInfo: [:])
        } onFailure: { error in
            print(error)
        }
    }
}
