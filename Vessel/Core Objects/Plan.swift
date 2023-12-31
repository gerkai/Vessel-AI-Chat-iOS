//
//  Plan.swift
//  Vessel
//
//  Created by Nicolas Medina on 10/11/22.
//

import Foundation

enum PlanType: String, Codable
{
    case food
    case activity
    case reagentLifestyleRecommendation
}

struct PlanResponse: Decodable
{
    let plans: [Plan]
    
    internal init(plans: [Plan])
    {
        self.plans = plans
    }
}

struct CompletionInfo: Codable, Equatable, Hashable
{
    let date: String
    var units: Int
    var dailyWaterIntake: Int?
    
    enum CodingKeys: String, CodingKey
    {
        case date
        case units
        case dailyWaterIntake = "daily_water_intake"
    }
}

struct Plan: CoreObjectProtocol, Codable, Equatable
{
    var id: Int
    var last_updated: Int
    var createdDate: String!
    var removedDate: String?
    let storage: StorageType = .disk
    var type: PlanType = .food
    var typeId: Int
    var completed: [String]
    var completionInfo: [CompletionInfo]?
    let timeOfDay: String?
    var dayOfWeek: [Int]?
    
    var isComplete: Bool
    {
        completed.contains(Date.serverDateFormatter.string(from: Date()))
    }
    
    init(id: Int = 0,
         last_updated: Int = 0,
         createdDate: String? = nil,
         removedDate: String? = nil,
         type: PlanType = .food,
         typeId: Int = 0,
         completed: [String] = [],
         completionInfo: [CompletionInfo]? = nil,
         timeOfDay: String? = nil,
         dayOfWeek: [Int]? = nil)
         
    {
        self.id = id
        self.last_updated = last_updated
        self.createdDate = createdDate
        self.removedDate = removedDate
        self.type = type
        self.typeId = typeId
        self.completed = completed
        self.completionInfo = completionInfo
        self.timeOfDay = timeOfDay
        self.dayOfWeek = dayOfWeek
    }
    
    init(plan: Plan)
    {
        self.id = abs(plan.id)
        self.last_updated = plan.last_updated
        self.createdDate = plan.createdDate
        self.removedDate = plan.removedDate
        self.type = plan.type
        self.typeId = abs(plan.typeId)
        self.completed = plan.completed
        self.completionInfo = plan.completionInfo
        self.timeOfDay = plan.timeOfDay
        self.dayOfWeek = plan.dayOfWeek
    }
    
    enum CodingKeys: String, CodingKey
    {
        case id
        case last_updated
        case createdDate = "created_date"
        case removedDate = "removed_date"
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
    
    internal init(isDeleted: Bool? = nil, date: String, programDay: Int? = nil, completed: Bool)
    {
        self.isDeleted = isDeleted

        self.date = date
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
            plans.append(Plan(type: .reagentLifestyleRecommendation, typeId: reagentLifestyleRecommendationsId))
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
