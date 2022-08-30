//
//  HeightWeightSelectViewModel.swift
//  Vessel
//
//  Created by Nicolas Medina on 8/25/22.
//

import Foundation

class HeightWeightSelectViewModel
{
    var userHeight: Double = Double(Constants.DEFAULT_HEIGHT)
    var userWeight: Double?
    
    deinit
    {
        print("📘 deinit \(self)")
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
        userHeight = height
        userWeight = weight
    }
    
    internal func convertCentimetersToFeetInches(centimeters: Double) -> (Int, Int)
    {
        let heightCentimeters = Measurement(value: centimeters, unit: UnitLength.centimeters)
        let heightFeet = heightCentimeters.converted(to: UnitLength.feet)
        let inches = Int((heightFeet.value - floor(heightFeet.value)) * 12)
        let feet = Int(heightFeet.value)
        return (feet, inches)
    }
}
