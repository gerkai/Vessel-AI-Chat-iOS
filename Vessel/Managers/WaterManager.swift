//
//  WaterManager.swift
//  Vessel
//
//  Created by Nicolas Medina on 10/24/22.
//

import Foundation

class WaterManager
{
    static let shared = WaterManager()
    
    let lastOpenedDay = UserDefaults.standard.string(forKey: Constants.KEY_LAST_OPENED_DAY)
    var todayString: String
    {
        Date.serverDateFormatter.string(from: Date())
    }
    
    var drinkedWaterGlasses: Int
    {
        get
        {
            guard let waterPlan = PlansManager.shared.getWaterPlan(),
                  let completionInfo = waterPlan.completionInfo?.first(where: { $0.date == todayString }) else { return 0 }
            return completionInfo.units
        }
        set (value)
        {
            PlansManager.shared.setValueToWaterPlan(value: value)
        }
    }
    
    func resetDrinkedWaterGlassesIfNeeded()
    {
        guard let plan = PlansManager.shared.getWaterPlan() else
        {
            createWaterPlanIfNeeded()
            return
        }
        var waterPlan = plan
        guard waterPlan.completionInfo?.first(where: { $0.date == todayString }) == nil else { return }
        waterPlan.completionInfo?.append(CompletionInfo(date: todayString, units: 0))
        ObjectStore.shared.ClientSave(waterPlan)
    }
    
    func createWaterPlanIfNeeded()
    {
        if Contact.main()?.dailyWaterIntake == nil
        {
            print("WATER NOT YET ASKED")
        }
        else if let _ = PlansManager.shared.getWaterPlan()
        {
            print("WATER PLAN ALREADY EXISTS")
        }
        else
        {
            let waterPlan = Plan(type: .lifestyleRecommendation,
                                 typeId: Constants.WATER_LIFESTYLE_RECOMMENDATION_ID,
                                 completionInfo: [CompletionInfo(date: todayString, units: 0)])
            Server.shared.addSinglePlan(plan: waterPlan) { addedPlan in
                PlansManager.shared.addPlans(plansToAdd: [addedPlan])
                NotificationCenter.default.post(name: .newDataArrived, object: nil, userInfo: ["objectType": String(describing: Plan.self)])
            } onFailure: { error in
            }
        }
    }
}
