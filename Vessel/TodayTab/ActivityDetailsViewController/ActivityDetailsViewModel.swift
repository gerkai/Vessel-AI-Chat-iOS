//
//  ActivityDetailsViewModel.swift
//  Vessel
//
//  Created by Nicolas Medina on 10/5/22.
//

import Foundation

class ActivityDetailsViewModel
{
    // MARK: - Private vars
    private var food: Food
    private var isMetric: Bool
    {
        //determine if we are using imperial or metric units
        Locale.current.usesMetricSystem
    }
    
    // MARK: - Public properties
    var foodImageURL: URL?
    {
        URL(string: food.imageUrl)
    }
    
    var title: String
    {
        food.title
    }
    
    var subtitle: String
    {
        let serving_grams = food.servingGrams
        let serving_quantity = food.servingQuantity
        let serving_unit = food.servingUnit
        if isMetric
        {
            return NSLocalizedString("\(serving_grams) gr", comment: "Food amount")
        }
        else
        {
            if serving_quantity == Double(Int(serving_quantity))
            {
                return "\(Int(serving_quantity)) \(serving_unit)"
            }
            else
            {
                return "\(serving_quantity) \(serving_unit)"
            }
        }
    }
    
    var description: String
    {
        ""//NSLocalizedString("Recomended because you are \("low") in \("Vitamin C and Vitamin B7")", comment: "Food recommendation description")
    }
    
    var reagents: String
    {
        var reagents = ""
        let nutrientsArray = food.nutrients
        for nutrient in nutrientsArray
        {
            if nutrient.quantity > 0
            {
                reagents.append("• \(nutrient.name)\(nutrient == nutrientsArray.last ? "" : "\n")")
            }
        }
        return reagents
    }
    
    var quantities: String
    {
        var quantities = ""
        let nutrientsArray = food.nutrients
        for nutrient in nutrientsArray
        {
            if nutrient.quantity > 0
            {
                if nutrient.quantity < 1
                {
                    quantities.append("\(Int(nutrient.quantity * 1000))\(nutrient == nutrientsArray.last ? " μg" : " μg\n")")
                }
                else
                {
                    quantities.append("\(Int(nutrient.quantity))\(nutrient == nutrientsArray.last ? " mg" : " mg\n")")
                }
            }
        }
        return quantities
    }
    
    init(food: Food)
    {
        self.food = food
    }
}
