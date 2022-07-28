//
//  AfterTestViewModel.swift
//  Vessel
//
//  Created by Carson Whitsett on 7/28/22.
//

import Foundation

class AfterTestViewModel
{
    var reagentInfoFlags: Int = 0
    var testResult: TestResult!
    var currentScreen: Int = 1
    var totalScreens: Int = 0
    var contactFlags: Int = 0
    
    init(testResult: TestResult)
    {
        self.testResult = testResult
        calculateTotalScreens()
    }
    
    func calculateTotalScreens()
    {
        if testResult.isEvaluatedTo(id: Reagent.ID.MAGNESIUM, evaluation: .low)
        {
            contactFlags |= Constants.SAW_MAGNESIUM_INFO
            totalScreens += 2 //skipping 3rd screen for now
        }
        if testResult.isEvaluatedTo(id: Reagent.ID.SODIUM, evaluation: .high)
        {
            contactFlags |= Constants.SAW_SODIUM_INFO
            totalScreens += 3
        }
        if testResult.isEvaluatedTo(id: Reagent.ID.CALCIUM, evaluation: .low)
        {
            contactFlags |= Constants.SAW_CALCIUM_INFO
            totalScreens += 3 //skipping 4th screen for now
        }
        if testResult.isEvaluatedTo(id: Reagent.ID.VITAMIN_C, evaluation: .low)
        {
            contactFlags |= Constants.SAW_VITAMIN_C_INFO
            totalScreens += 3 //skipping 4th screen for now
        }
        if testResult.isEvaluatedTo(id: Reagent.ID.PH, evaluation: .low)
        {
            contactFlags |= Constants.SAW_PH_LOW_INFO
            totalScreens += 2 //skipping 3rd screen for now
        }
        if testResult.isEvaluatedTo(id: Reagent.ID.PH, evaluation: .high)
        {
            contactFlags |= Constants.SAW_PH_HIGH_INFO
            totalScreens += 3
        }
        if testResult.isEvaluatedTo(id: Reagent.ID.HYDRATION, evaluation: .low)
        {
            contactFlags |= Constants.SAW_HYDRATION_LOW_INFO
            totalScreens += 2 //Skipping 3rd screen for now
        }
        if testResult.isEvaluatedTo(id: Reagent.ID.HYDRATION, evaluation: .high)
        {
            contactFlags |= Constants.SAW_HYDRATION_HIGH_INFO
            totalScreens += 3 //Skipping 4th screen for now
        }
        if testResult.isEvaluatedTo(id: Reagent.ID.KETONES_A, evaluation: .low)
        {
            contactFlags |= Constants.SAW_KETONES_LOW_INFO
            totalScreens += 3 //Skipping 4th screen for now
        }
        if testResult.isEvaluatedTo(id: Reagent.ID.KETONES_A, evaluation: .elevated)
        {
            contactFlags |= Constants.SAW_KETONES_ELEVATED_INFO
            totalScreens += 1 //Skipping 2nd screen for now
        }
        if testResult.isEvaluatedTo(id: Reagent.ID.KETONES_A, evaluation: .high)
        {
            contactFlags |= Constants.SAW_KETONES_HIGH_INFO
            totalScreens += 2
        }
        if testResult.isEvaluatedTo(id: Reagent.ID.VITAMIN_B7, evaluation: .low)
        {
            contactFlags |= Constants.SAW_B7_LOW_INFO
            totalScreens += 2 //skipping 3rd screen for now
        }
        if testResult.isEvaluatedTo(id: Reagent.ID.CORTISOL, evaluation: .low)
        {
            contactFlags |= Constants.SAW_CORTISOL_LOW_INFO
            totalScreens += 2 //skipping 3rd screen for now
        }
        if testResult.isEvaluatedTo(id: Reagent.ID.CORTISOL, evaluation: .high)
        {
            contactFlags |= Constants.SAW_CORTISOL_HIGH_INFO
            totalScreens += 2 //skipping 3rd screen for now
        }
        let contact = Contact.main()!
        if contact.flags & Constants.SAW_TESTING_REMINDER != 0
        {
            contactFlags |= Constants.SAW_TESTING_REMINDER
            totalScreens += 1
        }
    }
}
