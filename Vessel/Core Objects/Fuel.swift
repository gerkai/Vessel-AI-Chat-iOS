//
//  Fuel.swift
//  Vessel
//
//  Created by Carson Whitsett on 1/24/23.
//
//  This is the Fuel structure as received from the GET /fuel endpoint. All fuel sub-structures are included here as well.

import Foundation

struct Ingredient: Decodable
{
    let name: String?
    let dosage: String
    let time_of_day: String?
    let mil_id: String
    let description: String?
    let unit: String
}

struct Formula: Decodable
{
    let pm_ingredients: [Ingredient]?
    let am_ingredients: [Ingredient]?
    let partner_uuid: String?
    let id: Int
    let caps_per_serving: Int
    let weight: Double
    let capsules: Int
    let days_supply: Int
    let monthly_retail_price: String
    let pm_capsules: Int?
    let total_bottles: Int
    let kind: String
    let email: String?
    let name: String?
    let pm_caps_per_serving: Int?
}

struct Fuel: Decodable
{
    let url_code: String?
    let expert_uuid: String?
    let updated_by: String?
    let affiliate_url: String?
    let expert: Expert?
    let formula: Formula?
    var is_active: Bool
    let fuel_uuid: String?
    
    func amCapsulesPerServing() -> Int?
    {
        return formula?.caps_per_serving
    }
    
    func pmCapsulesPerServing() -> Int?
    {
        return formula?.pm_caps_per_serving
    }
    
    func completedQuiz() -> Bool
    {
        if formula == nil
        {
            return false
        }
        return true
    }
    func hasAMFormula() -> Bool
    {
        var am = false
        
        am = formula?.am_ingredients?.count ?? 0 > 0
        return am
    }
    
    func hasPMFormula() -> Bool
    {
        var pm = false
        
        pm = formula?.pm_ingredients?.count ?? 0 > 0
        return pm
    }
}
