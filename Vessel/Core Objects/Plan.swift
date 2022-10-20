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

struct Plan: Codable, Hashable
{
    let id: Int?
    let last_updated: Int?
//    let storage: StorageType = .cache
    let timeOfDay: String?
    let dayOfWeek: [Int]?
    let foodId: Int?
    let reagentLifestyleRecommendationId: Int?
    let activityId: Int?
    let planId: Int?
    let contactId: Int?
    var completed: [String]?

    var isComplete: Bool
    {
        (completed ?? []).contains(Date.serverDateFormatter.string(from: Date()))
    }
    
    var type: PlanType = .food
    
    internal init(id: Int? = nil,
                  last_updated: Int? = nil,
                  timeOfDay: String? = nil,
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
        self.dayOfWeek = dayOfWeek
        self.foodId = foodId
        self.reagentLifestyleRecommendationId = reagentLifestyleRecommendationId
        self.activityId = activityId
        self.planId = planId
        self.contactId = contactId
        self.completed = completed
    }
    
    enum CodingKeys: CodingKey
    {
        case id
        case last_updated
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

struct TogglePlanData: Codable
{
    let isDeleted: Bool?
    let date: String
    let programDay: Int?
    let completed: Bool
    
    internal init(isDeleted: Bool? = nil, date: Date, programDay: Int? = nil, completed: Bool)
    {
        self.isDeleted = isDeleted

        self.date = Date.serverDateFormatter.string(from: date)
        self.programDay = programDay
        self.completed = completed
    }
    
    enum CodingKeys: CodingKey
    {
        case isDeleted
        case date
        case programDay
        case completed
    }
}

struct MultiplePlans: Codable
{
    let supplementsIds: [Int]?
    let foodIds: [Int]?
    let reagentLifestyleRecommendationsIds: [Int]?
    
    internal init(supplementsIds: [Int]? = nil,
                  foodIds: [Int]? = nil,
                  reagentLifestyleRecommendationsIds: [Int]? = nil)
    {
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
        case supplementsIds
        case foodIds
        case reagentLifestyleRecommendationsIds
    }
}
