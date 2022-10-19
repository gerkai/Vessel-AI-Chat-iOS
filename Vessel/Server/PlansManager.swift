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
        Server.shared.getPlans(onSuccess: { plans in
            self.plans.append(contentsOf: plans)
            NotificationCenter.default.post(name: .plansLoaded, object: nil, userInfo: [:])
        }, onFailure: { error in
            print(error)
        })
    }
    
    func addPlans(plan: [Plan])
    {
        for plan in plans
        {
            plans.append(plan)   
        }
        NotificationCenter.default.post(name: .plansLoaded, object: nil, userInfo: [:])
    }
}
