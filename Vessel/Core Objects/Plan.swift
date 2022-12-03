//
//  Plan.swift
//  Vessel
//
//  Created by Nicolas Medina on 10/11/22.
//

import Foundation

enum PlanType: Codable
{
    case food
    case activity
    case lifestyleRecommendation
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

struct CompletionInfo: Codable
{
    let date: String
    let units: Int
}

struct Plan: CoreObjectProtocol, Codable
{
    let id: Int
    var last_updated: Int
    var type: PlanType = .food
    var typeId: Int
    var completed: [String]
    @NullCodable var completionInfo: [CompletionInfo]?
    let timeOfDay: String?
    let dayOfWeek: [Int]?
    
    let storage: StorageType = .cacheAndDisk
    
    var isComplete: Bool
    {
        completed.contains(Date.serverDateFormatter.string(from: Date()))
    }
    
    init(id: Int = 0,
         last_updated: Int = 0,
         type: PlanType = .food,
         typeId: Int = 0,
         completed: [String] = [],
         completionInfo: [CompletionInfo]? = nil,
         timeOfDay: String? = nil,
         dayOfWeek: [Int]? = nil)
         
    {
        self.id = id
        self.last_updated = last_updated
        self.type = type
        self.typeId = typeId
        self.completed = completed
        self.completionInfo = completionInfo
        self.timeOfDay = timeOfDay
        self.dayOfWeek = dayOfWeek
    }
    
    enum CodingKeys: String, CodingKey
    {
        case id
        case last_updated
        case type
        case typeId = "type_id"
        case completed
        case completionInfo = "completion_info"
        case timeOfDay = "time_of_day"
        case dayOfWeek = "day_of_week"
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
            plans.append(Plan(type: .food, typeId: foodId))
        }
        for reagentLifestyleRecommendationsId in reagentLifestyleRecommendationsIds ?? []
        {
            plans.append(Plan(type: .lifestyleRecommendation, typeId: reagentLifestyleRecommendationsId))
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
