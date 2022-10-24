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
        Server.shared.getAllFoods
        { foods in
            self.foods.append(contentsOf: foods)
            //print("Sending .newDataArrived notificaiton with \(String(describing: Food.self))")
            NotificationCenter.default.post(name: .newDataArrived, object: nil, userInfo: ["objectType": String(describing: Food.self)])
        }
        onFailure:
        { error in
            print(error)
        }
    }
}
