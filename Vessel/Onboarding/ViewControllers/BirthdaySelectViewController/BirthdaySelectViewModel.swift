//
//  BirthdaySelectViewModel.swift
//  Vessel
//
//  Created by Nicolas Medina on 8/25/22.
//

import Foundation

class BirthdaySelectViewModel
{
    var userBirthdate: Date = Date.defaultBirthDate()
    var preferNotToShareBirthdate: Bool = false

    let minAge = Constants.MIN_AGE
    let maxAge = Constants.MAX_AGE
    let calendar = Calendar.current
    var minDateComponents = DateComponents()
    var maxDateComponents = DateComponents()
    var maxDate = Date()
    var minDate = Date()
    
    deinit
    {
        if UserDefaults.standard.bool(forKey: Constants.KEY_PRINT_INIT_DEINIT)
        {
            print("📘 deinit \(self)")
        }
    }
    
    func getBirthDate() -> (date: Date, preferNotToSay: Bool)
    {
        return (userBirthdate, preferNotToShareBirthdate)
    }
    
    func setBirthDate(birthDate: Date, preferNotToSay: Bool)
    {
        userBirthdate = birthDate
        preferNotToShareBirthdate = preferNotToSay
    }
}
