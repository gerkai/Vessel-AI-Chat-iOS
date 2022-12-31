//
//  FuelInfo.swift
//  Vessel
//
//  Created by Carson Whitsett on 12/30/22.
//

import Foundation

struct Ingredient: Codable
{
    let name: String
    let dosage: Double
    let time_of_day: String
    let mil_id: String
}

struct Formula: Codable
{
    let ingredients: [Ingredient]
    let id: Int
}

struct FuelInfo: Codable
{
    let customer_total_price: Double
    let updated_by: Int
    let fuel_uuid: String
    let is_active: Bool
    let updated_at: String
    let formula: Formula
}
