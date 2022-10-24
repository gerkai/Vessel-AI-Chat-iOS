//
//  PlansManager.swift
//  Vessel
//
//  Created by Nicolas Medina on 10/15/22.
//
// This is a temporary class made to manage foods

import Foundation

class PlansManager
{
    static let shared = PlansManager()
    
    var plans = [Plan]()
    
    func loadPlans()
    {
        //CW: TODO: Use ObjectStore to retrieve plans rather than make server call directly from here
        Server.shared.getPlans(onSuccess: { plans in
            for plan in plans
            {
                //This fixes a bug when there are multiple plans for the same food
                if !self.plans.contains(where: { $0.foodId == plan.foodId })
                {
                    self.plans.append(plan)
                }
            }
            NotificationCenter.default.post(name: .newDataArrived, object: nil, userInfo: ["objectType": String(describing: Plan.self)])
        }, onFailure: { error in
            print(error)
        })
    }
    
    func addPlans(plan: [Plan])
    {
        for plan in plans
        {
            //This fixes a bug when there are multiple plans for the same food
            if !self.plans.contains(where: { $0.foodId == plan.foodId })
            {
                plans.append(plan)
            }
        }
        NotificationCenter.default.post(name: .newDataArrived, object: nil, userInfo: ["objectType": String(describing: Plan.self)])
    }
    
    func togglePlanCompleted(planId: Int, date: String, completed: Bool)
    {
        guard let index = plans.firstIndex(where: { $0.id == planId }) else { return }
        if completed
        {
            plans[index].completed?.append(date)
        }
        else
        {
            plans[index].completed?.removeAll(where: { $0 == date })
        }
    }
}
