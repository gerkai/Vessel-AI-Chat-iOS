//
//  Plan.swift
//  Vessel
//
//  Created by Nicolas Medina on 10/11/22.
//

import Foundation

enum PlanType
{
    case food
    case activity
    case reagentLifestyleRecommendationId
    case suplement
}

struct PlanResponse: Decodable
{
    let plans: [Plan]
    
    internal init(plans: [Plan])
    {
        self.plans = plans
    }
}

struct Plan: Codable
{
    let id: Int?
    let last_updated: Int?
//    let storage: StorageType = .cache
    let clear: Bool?
    let timeOfDay: String?
    let dayOfWeek: [Int]?
    let foodId: Int?
    let reagentLifestyleRecommendationId: Int?
    let activityId: Int?
    let planId: Int?
    let contactId: Int?
    let completed: [String]?
    
    var type: PlanType = .food
    
    internal init(id: Int? = nil,
                  last_updated: Int? = nil,
                  timeOfDay: String? = nil,
                  clear: Bool? = nil,
                  dayOfWeek: [Int]? = nil,
                  foodId: Int? = nil,
                  reagentLifestyleRecommendationId: Int? = nil,
                  activityId: Int? = nil,
                  planId: Int? = nil,
                  contactId: Int? = nil,
                  completed: [String]? = nil)
    {
        self.id = id
        self.last_updated = last_updated
        self.timeOfDay = timeOfDay
        self.clear = clear
        self.dayOfWeek = dayOfWeek
        self.foodId = foodId
        self.reagentLifestyleRecommendationId = reagentLifestyleRecommendationId
        self.activityId = activityId
        self.planId = planId
        self.contactId = contactId
        self.completed = completed
    }
    
    enum CodingKeys: String, CodingKey
    {
        case id
        case last_updated
        case clear
        case timeOfDay
        case dayOfWeek
        case foodId
        case reagentLifestyleRecommendationId
        case activityId
        case planId
        case contactId
        case completed
    }
}

struct TogglePlanData: Encodable
{
    let isDeleted: Bool?
    let contactId: Int?
    let date: String
    let programDay: Int?
    let completed: Bool
    
    internal init(isDeleted: Bool? = nil, contactId: Int? = nil, date: Date, programDay: Int? = nil, completed: Bool)
    {
        self.isDeleted = isDeleted
        self.contactId = contactId
        self.date = Date.serverDateFormatter.string(from: date)
        self.programDay = programDay
        self.completed = completed
    }
    
    enum CodingKeys: CodingKey
    {
        case isDeleted
        case contactId
        case date
        case programDay
        case completed
    }
}

struct MultiplePlans: Codable
{
    let clear: Bool
    let supplementsIds: [Int]?
    let foodIds: [Int]?
    let reagentLifestyleRecommendationsIds: [Int]?
    
    internal init(clear: Bool,
                  supplementsIds: [Int]? = nil,
                  foodIds: [Int]? = nil,
                  reagentLifestyleRecommendationsIds: [Int]? = nil)
    {
        self.clear = clear
        self.supplementsIds = supplementsIds
        self.foodIds = foodIds
        self.reagentLifestyleRecommendationsIds = reagentLifestyleRecommendationsIds
    }
    
    func convertToPlansArray() -> [Plan]
    {
        var plans = [Plan]()
        /*for supplementId in supplementsIds ?? []
        {
            plans.append(Plan(supplementId: supplementId))
        }*/
        for foodId in foodIds ?? []
        {
            plans.append(Plan(foodId: foodId))
        }
        for reagentLifestyleRecommendationsId in reagentLifestyleRecommendationsIds ?? []
        {
            plans.append(Plan(reagentLifestyleRecommendationId: reagentLifestyleRecommendationsId))
        }
        return plans
    }
    
    enum CodingKeys: String, CodingKey
    {
        case clear
        case supplementsIds
        case foodIds
        case reagentLifestyleRecommendationsIds
    }
}
