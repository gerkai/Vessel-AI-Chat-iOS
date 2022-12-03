//
//  ServerPlan.swift
//  Vessel
//
//  Created by Carson Whitsett on 12/2/22.
//  This is a temporary file we use to map a Plan structure from the server to the new Plan structure in the app.
//  Once the back end is updated to use the new Plan structure we can ditch this file.

import Foundation

struct ServerPlan: CoreObjectProtocol, Hashable
{
    let id: Int
    var last_updated: Int
    let storage: StorageType = .cacheAndDisk
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
    
    init(id: Int = 0,
         last_updated: Int = 0,
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
    
    enum CodingKeys: String, CodingKey
    {
        case id
        case last_updated
        case timeOfDay = "time_of_day"
        case dayOfWeek = "day_of_week"
        case foodId = "food_id"
        case reagentLifestyleRecommendationId = "reagent_lifestyle_recommendation_id"
        case activityId = "activity_id"
        case planId = "plan_id"
        case contactId = "contact_id"
        case completed
    }
    
    //convert old plan structure to new plan structure
    static func convert(serverPlans: [ServerPlan]) -> [Plan]
    {
        var plans: [Plan] = []
        
        for sPlan in serverPlans
        {
            var planType: PlanType = .food
            var typeID = 0
            
            if sPlan.activityId != nil
            {
                planType = .activity
                typeID = sPlan.activityId!
            }
            else if sPlan.reagentLifestyleRecommendationId != nil
            {
                planType = .lifestyleRecommendation
                typeID = sPlan.reagentLifestyleRecommendationId!
            }
            else if sPlan.foodId != nil
            {
                planType = .food
                typeID = sPlan.foodId!
            }
                
            var plan = Plan(id: sPlan.id, last_updated: sPlan.last_updated, type: planType, typeId: typeID, completed: sPlan.completed ?? [], timeOfDay: sPlan.timeOfDay, dayOfWeek: sPlan.dayOfWeek)
            plans.append(plan)
        }
        return plans
    }
}
