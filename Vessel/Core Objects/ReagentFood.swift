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
    
    static func == (lhs: ReagentFood, rhs: ReagentFood) -> Bool
    {
        return lhs.id == rhs.id &&
        lhs.foodTitle == rhs.foodTitle &&
        lhs.imageUrl == rhs.imageUrl
    }
    
    enum CodingKeys: CodingKey
    {
        case id
        case foodTitle
        case imageUrl
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
