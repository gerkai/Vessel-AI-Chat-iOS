//
//  HeightWeightSelectViewModel.swift
//  Vessel
//
//  Created by Nicolas Medina on 8/25/22.
//

import Foundation

class HeightWeightSelectViewModel
{
    lazy var userHeight: Double = Double(Constants.DEFAULT_HEIGHT - (isMetric ? 0 : Constants.MIN_HEIGHT_METRIC))
    var userWeight: Double?
    
    deinit
    {
        if UserDefaults.standard.bool(forKey: Constants.KEY_PRINT_INIT_DEINIT)
        {
            print("📘 deinit \(self)")
        }
    }
    
    var isMetric: Bool
    {
        //determine if we are using imperial or metric units
        Locale.current.usesMetricSystem
    }

    func getHeightWeight() -> (height: Double, weight: Double?)
    {
        return (userHeight, userWeight)
    }
    
    func setHeightWeight(height: Double, weight: Double)
    {
        userHeight = height + (isMetric ? 0 : Double(Constants.MIN_HEIGHT_METRIC))
        userWeight = max(min(isMetric ? convertKgToLbs(kg: weight) : weight, Constants.MAX_WEIGHT_IMPERIAL), Constants.MIN_WEIGHT_IMPERIAL)
    }
    
    internal func convertCentimetersToFeetInches(centimeters: Double) -> (Int, Int)
    {
        let heightCentimeters = Measurement(value: centimeters, unit: UnitLength.centimeters)
        let heightFeet = heightCentimeters.converted(to: UnitLength.feet)
        let inches = Int((heightFeet.value - floor(heightFeet.value)) * 12)
        let feet = Int(heightFeet.value)
        return (feet, inches)
    }
    
    private func convertKgToLbs(kg: Double) -> Double
    {
        return kg / 0.45359237
    }
}
