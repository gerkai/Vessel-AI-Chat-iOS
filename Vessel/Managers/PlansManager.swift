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
        loadPlans(lastUpdated: lastUpdated, onSuccess:
        { [weak self] plans in
            guard let self = self else { return }
            self.plans = plans
            NotificationCenter.default.post(name: .newDataArrived, object: nil, userInfo: ["objectType": String(describing: Plan.self)])
        },
        onFailure:
        { error in
            print(error)
        })
    }
    
    func loadPlans(lastUpdated: Int, onSuccess success: @escaping ([Plan]) -> Void, onFailure failure: @escaping (_ error: String) -> Void)
    {
        Server.shared.getPlans(lastUpdated: lastUpdated)
        { newPlans in
            for plan in newPlans
            {
                ObjectStore.shared.serverSave(plan)
            }
            
            //let plans = Storage.retrieve(as: Plan.self)
            success(newPlans)
        }
        onFailure:
        { error in
            failure(error.description)
        }
    }
    
    func loadFoods(lastUpdated: Int, onSuccess success: @escaping ([Food]) -> Void, onFailure failure: @escaping (_ error: String) -> Void)
    {
        Server.shared.getAllFoods(lastUpdated: lastUpdated) { newFoods in
            for food in newFoods
            {
                ObjectStore.shared.serverSave(food)
            }
            
            let foods = Storage.retrieve(as: Food.self)
            
            success(foods)
        } onFailure: { error in
            failure(error.description)
        }
    }
    
    func addPlans(plansToAdd: [Plan])
    {
        /*for plan in plansToAdd
        {
            ObjectStore.shared.serverSave(plan)
        }
        self.plans = Storage.retrieve(as: Plan.self)*/
        self.plans.append(contentsOf: plansToAdd)
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
    }
    
    func remove(plan: Plan)
    {
        plans.removeAll{$0.id == plan.id}
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
