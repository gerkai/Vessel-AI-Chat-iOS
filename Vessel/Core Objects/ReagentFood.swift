//
//  ReagentFood.swift
//  Vessel
//
//  Created by Nicolas Medina on 10/15/22.
//

import UIKit

struct ReagentFood: Decodable, Equatable
{
    let id: Int
    let foodTitle: String
    let imageUrl: String
    let reagentId: Int
    let reagentName: String
    let quantity: Double
    let servingGrams: Double
    
    static func == (lhs: ReagentFood, rhs: ReagentFood) -> Bool
    {
        return lhs.id == rhs.id &&
        lhs.foodTitle == rhs.foodTitle &&
        lhs.imageUrl == rhs.imageUrl &&
        lhs.reagentId == rhs.reagentId &&
        lhs.reagentName == rhs.reagentName &&
        lhs.quantity == rhs.quantity &&
        lhs.servingGrams == rhs.servingGrams
    }
    
    enum CodingKeys: CodingKey
    {
        case id
        case foodTitle
        case imageUrl
        case reagentId
        case reagentName
        case quantity
        case servingGrams
    }
}

struct ReagentFoodResponse: Decodable
{
    let foodResponse: [ReagentFood]
    
    internal init(foodResponse: [ReagentFood])
    {
        self.foodResponse = foodResponse
    }
    
    enum CodingKeys: String, CodingKey
    {
        case foodResponse
    }
}
