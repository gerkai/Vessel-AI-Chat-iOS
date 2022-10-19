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
        URL(string: food.imageUrl ?? "")
    }
    
    var title: String
    {
        food.title
    }
    
    var subtitle: String
    {
        guard let servingGrams = food.servingGrams,
              let servingQuantity = food.servingQuantity,
              let servingUnit = food.servingUnit else { return "" }
        if isMetric
        {
            return NSLocalizedString("\(servingGrams) gr", comment: "Food amount")
        }
        else
        {
            return "\(Int(servingQuantity)) \(servingUnit)"
        }
    }
    
    var description: String
    {
        ""//NSLocalizedString("Recomended because you are \("low") in \("Vitamin C and Vitamin B7")", comment: "Food recommendation description")
    }
    
    var reagents: String
    {
        var reagents = ""
        guard let nutrientsArray = food.nutrients else { return "" }
        for nutrient in nutrientsArray
        {
            reagents.append("• \(nutrient.name)\(nutrient == nutrientsArray.last ? "" : "\n")")
        }
        return reagents
    }
    
    var quantities: String
    {
        var quantities = ""
        guard let nutrientsArray = food.nutrients else { return "" }
        for nutrient in nutrientsArray
        {
            quantities.append("\(Int(nutrient.quantity))\(nutrient == nutrientsArray.last ? "" : "\n")")
        }
        return quantities
    }
    
    init(food: Food)
    {
        self.food = food
    }
}
