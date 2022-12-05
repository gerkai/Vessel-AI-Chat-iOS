//
//  PlansManager.swift
//  Vessel
//
//  Created by Nicolas Medina on 10/15/22.
//

import Foundation

class PlansManager
{
    static let shared = PlansManager()
    var plans = [Plan]()
    // Commented out to fix a bug where the plans would not arrive from the server after completing
    let lastUpdated = 1//Storage.newestLastUpdatedFor(type: Plan.self)

    func loadPlans()
    {
        plans = Storage.retrieve(as: Plan.self)
        NotificationCenter.default.post(name: .newDataArrived, object: nil, userInfo: ["objectType": String(describing: Plan.self)])
    }
    
    func addPlans(plansToAdd: [Plan])
    {
        for plan in plansToAdd
        {
            ObjectStore.shared.ClientSave(plan)
        }
        self.plans = Storage.retrieve(as: Plan.self)
        NotificationCenter.default.post(name: .newDataArrived, object: nil, userInfo: ["objectType": String(describing: Plan.self)])
    }
    
    func togglePlanCompleted(planId: Int, date: String, completed: Bool)
    {
        guard let index = plans.firstIndex(where: { $0.id == planId }) else { return }
        if completed
        {
            if plans[index].completed.count == 0
            {
                plans[index].completed = [date]
            }
            else
            {
                plans[index].completed.append(date)
            }
        }
        else
        {
            plans[index].completed.removeAll(where: { $0 == date })
        }
        ObjectStore.shared.ClientSave(plans[index])
    }
    
    func remove(plan: Plan)
    {
        plans.removeAll{$0.id == plan.id}
        //TODO: Need to be able to delete plans from object store
    }
    
    //returns array of only food plans
    func getFoodPlans() -> [Plan]
    {
        return plans.filter({ $0.type == .food })
    }
    
    //returns array of only activities
    func getActivities() -> [Plan]
    {
        return plans.filter({ $0.type == .activity })
    }
    
    //returns array of only reagentLifestyleRecommendations
    func getLifestyleRecommendations() -> [Plan]
    {
        return plans.filter({ $0.type == .lifestyleRecommendation })
    }
}
