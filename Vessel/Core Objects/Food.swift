//
//  Food.swift
//  Vessel
//
//  Created by Nicolas Medina on 10/5/22.
//

import Foundation

struct Food: CoreObjectProtocol, Equatable, Codable
{
    var storage: StorageType = .cacheAndDisk
    var id: Int
    var last_updated: Int
    var title: String
    var servingQuantity: Double
    var servingUnit: String
    var servingGrams: Double
    var popularity: Int
    var usda_ndb_number: Int
    var categories: [String]?
    var imageUrl: String
    var nutrients: [Nutrient]
    var allergyIds: [Int]
    var dietIds: [Int]
    
    internal init(id: Int, lastUpdated: Int, title: String, serving_quantity: Double, serving_unit: String, serving_grams: Double, popularity: Int, usda_ndb_number: Int, categories: [String]?, image_url: String)
    {
        self.id = id
        self.last_updated = lastUpdated
        self.title = title
        self.servingQuantity = serving_quantity
        self.servingUnit = serving_unit
        self.servingGrams = serving_grams
        self.popularity = popularity
        self.usda_ndb_number = usda_ndb_number
        self.categories = categories
        self.imageUrl = image_url
        self.dietIds = []
        self.allergyIds = []
        self.nutrients = []
    }
    
    static func == (lhs: Food, rhs: Food) -> Bool
    {
        return lhs.id == rhs.id &&
        lhs.last_updated == rhs.last_updated &&
        lhs.title == rhs.title &&
        lhs.servingQuantity == rhs.servingQuantity &&
        lhs.servingUnit == rhs.servingUnit &&
        lhs.servingGrams == rhs.servingGrams &&
        lhs.popularity == rhs.popularity &&
        lhs.usda_ndb_number == rhs.usda_ndb_number &&
        lhs.categories == rhs.categories &&
        lhs.imageUrl == rhs.imageUrl
    }

    enum CodingKeys: String, CodingKey
    {
        case id
        case last_updated
        case title
        case servingQuantity = "serving_quantity"
        case servingUnit = "serving_unit"
        case servingGrams = "serving_grams"
        case popularity
        case usda_ndb_number
        case categories
        case imageUrl = "image_url"
        case nutrients
        case allergyIds = "allergy_ids"
        case dietIds = "diet_ids"
    }
    
    func getActivityDetailsModel(planId: Int) -> ActivityDetailsModel
    {
        let subtitle: String
        let serving_quantity = servingQuantity
        let serving_unit = servingUnit
        if serving_quantity == Double(Int(serving_quantity))
        {
            subtitle = "\(Int(serving_quantity)) \(serving_unit)"
        }
        else
        {
            subtitle = "\(serving_quantity) \(serving_unit)"
        }
        
        var reagents = ""
        var quantities = ""
        for nutrient in nutrients
        {
            let microgramsSymbol = NSLocalizedString("μg", comment: "Micrograms abbreviation")
            let milligramsSymbol = NSLocalizedString("mg", comment: "Milligrams abbreviation")

            if nutrient.quantity > 0
            {
                reagents.append("• \(nutrient.name)\(nutrient == nutrients.last ? "" : "\n")")
                if nutrient.quantity < 1
                {
                    quantities.append("\(Int(nutrient.quantity * 1000))\(nutrient == nutrients.last ? " \(microgramsSymbol)" : " \(microgramsSymbol)\n")")
                }
                else
                {
                    quantities.append("\(Int(nutrient.quantity))\(nutrient == nutrients.last ? " \(milligramsSymbol)" : " \(milligramsSymbol)\n")")
                }
            }
        }
        
        return ActivityDetailsModel(id: planId, imageUrl: self.imageUrl, title: self.title, subtitle: subtitle, description: "", reagents: reagents, quantities: quantities)
    }
}

struct Nutrient: Codable, Equatable
{
    var id: Int
    var name: String
    var foodId: Int
    var quantity: Double
    var reagentId: Int?
    var servingGrams: Int
    
    enum CodingKeys: String, CodingKey
    {
        case id
        case name
        case foodId = "food_id"
        case quantity
        case reagentId = "reagent_id"
        case servingGrams = "serving_grams"
    }
}
