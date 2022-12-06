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
    var id: Int
    var last_updated: Int
    var storage: StorageType = .disk
    var timeOfDay: String?
    var dayOfWeek: [Int]?
    var foodId: Int?
    var reagentLifestyleRecommendationId: Int?
    var activityId: Int?
    var planId: Int?
    var contactId: Int?
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
            let plan = convert(serverPlan: sPlan)
            plans.append(plan)
        }
        return plans
    }
    
    //convert old plan structure to new plan structure
    static func convert(serverPlan: ServerPlan) -> Plan
    {
        var planType: PlanType = .food
        var typeID = 0
        
        if serverPlan.activityId != nil
        {
            planType = .activity
            typeID = serverPlan.activityId!
        }
        else if serverPlan.reagentLifestyleRecommendationId != nil
        {
            planType = .lifestyleRecommendation
            typeID = serverPlan.reagentLifestyleRecommendationId!
        }
        else if serverPlan.foodId != nil
        {
            planType = .food
            typeID = serverPlan.foodId!
        }
            
        let plan = Plan(id: serverPlan.id, last_updated: serverPlan.last_updated, type: planType, typeId: typeID, completed: serverPlan.completed ?? [], timeOfDay: serverPlan.timeOfDay, dayOfWeek: serverPlan.dayOfWeek)

        return plan
    }
    
    static func convert(plan: Plan) -> ServerPlan
    {
        var serverPlan = ServerPlan()
        
        serverPlan.id = plan.id
        serverPlan.last_updated = plan.last_updated
        switch plan.type
        {
        case .activity:
            serverPlan.activityId = plan.typeId
        case .food:
            serverPlan.foodId = plan.typeId
        case .lifestyleRecommendation:
            serverPlan.reagentLifestyleRecommendationId = plan.typeId
        case .suplement:
            print("")
        }
        serverPlan.dayOfWeek = plan.dayOfWeek
        serverPlan.timeOfDay = plan.timeOfDay
        serverPlan.completed = nil
        
        return serverPlan
    }
}
