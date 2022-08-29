//
//  GenderSelectViewModel.swift
//  Vessel
//
//  Created by Nicolas Medina on 8/25/22.
//

import Foundation

class GenderSelectViewModel
{
    var userGender: Int?

    deinit
    {
        print("📘 deinit \(self)")
    }
    
    func getGender() -> Int?
    {
        return userGender
    }
    
    func setGender(gender: Int)
    {
        userGender = gender
    }
}
