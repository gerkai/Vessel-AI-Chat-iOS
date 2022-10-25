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
    var plans = Storage.retrieve(as: Plan.self)
    // Commented out to fix a bug where the plans would not arrive from the server after completing
    let lastUpdated: Int = 1//UserDefaults.standard.object(forKey: Constants.PLANS_LAST_UPDATED_DATE) as? Int ?? 1

    func loadPlans()
    {
        ObjectStore.shared.loadPlans(lastUpdated: lastUpdated, onSuccess: { [weak self] plans in
            guard let self = self else { return }
            self.plans = plans
        }, onFailure: { error in
            print(error)
        })
    }
    
    func addPlans(plan: [Plan])
    {
        for plan in plans
        {
            ObjectStore.shared.serverSave(plan)
        }
        self.plans = Storage.retrieve(as: Plan.self)
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
