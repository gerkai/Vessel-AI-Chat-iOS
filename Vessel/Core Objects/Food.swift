//
//  Food.swift
//  Vessel
//
//  Created by Nicolas Medina on 10/5/22.
//

import Foundation

struct Food: Equatable
{
    var id: Int
    var last_updated: Int
    var title: String
    var serving_quantity: Double
    var serving_unit: String
    var serving_grams: Double
    var popularity: Int
    var usda_ndb_number: Int
    var categories: [String]
    var image_url: String
    var reagents: [Reagent]
    
    internal init(id: Int, last_updated: Int, title: String, serving_quantity: Double, serving_unit: String, serving_grams: Double, popularity: Int, usda_ndb_number: Int, categories: [String], image_url: String, reagents: [Reagent])
    {
        self.id = id
        self.last_updated = last_updated
        self.title = title
        self.serving_quantity = serving_quantity
        self.serving_unit = serving_unit
        self.serving_grams = serving_grams
        self.popularity = popularity
        self.usda_ndb_number = usda_ndb_number
        self.categories = categories
        self.image_url = image_url
        self.reagents = reagents
    }
    
    static func == (lhs: Food, rhs: Food) -> Bool
    {
        return lhs.id == rhs.id &&
        lhs.last_updated == rhs.last_updated &&
        lhs.title == rhs.title &&
        lhs.serving_quantity == rhs.serving_quantity &&
        lhs.serving_unit == rhs.serving_unit &&
        lhs.serving_grams == rhs.serving_grams &&
        lhs.popularity == rhs.popularity &&
        lhs.usda_ndb_number == rhs.usda_ndb_number &&
        lhs.categories == rhs.categories &&
        lhs.image_url == rhs.image_url
    }
}
