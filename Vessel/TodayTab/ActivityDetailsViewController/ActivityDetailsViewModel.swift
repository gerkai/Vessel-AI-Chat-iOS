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
        URL(string: food.image_url)
    }
    
    var title: String
    {
        food.title
    }
    
    var subtitle: String
    {
        if isMetric
        {
            return NSLocalizedString("\(food.serving_grams) gr", comment: "Food amount")
        }
        else
        {
            return "\(Int(food.serving_quantity)) \(food.serving_unit)"
        }
    }
    
    var description: String
    {
        NSLocalizedString("Recomended because you are \("low") in \("Vitamin C and Vitamin B7")", comment: "Food recommendation description")
    }
    
    var reagents: String
    {
        var reagents = ""
        for reagent in food.reagents
        {
            reagents.append("• \(reagent.name)\(reagent.name == food.reagents.last?.name ? "" : "\n")")
        }
        return reagents
    }
    
    init(food: Food)
    {
        self.food = food
    }
}
