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
    
    func getDailyWaterIntake(date: String) -> Int?
    {
        guard let waterPlan = PlansManager.shared.getWaterPlan(),
              let completionInfo = waterPlan.completionInfo?.first(where: { $0.date == date }) else
        {
            return (PlansManager.shared.getWaterPlan()?.completionInfo ?? []).first(where: { $0.date > date })?.dailyWaterIntake ?? Contact.main()?.dailyWaterIntake
        }
        return completionInfo.dailyWaterIntake ?? Contact.main()?.dailyWaterIntake
    }
    
    func getDrinkedWaterGlasses(date: String) -> Int
    {
        guard let waterPlan = PlansManager.shared.getWaterPlan(),
              let completionInfo = waterPlan.completionInfo?.first(where: { $0.date == date }) else { return 0 }
        return completionInfo.units
    }
    
    func setDrinkedWaterGlasses(value: Int, date: String)
    {
        PlansManager.shared.setValueToWaterPlan(value: value, date: date)
    }
    
    func resetDrinkedWaterGlassesIfNeeded()
    {
        guard let _ = PlansManager.shared.getWaterPlan() else
        {
            createWaterPlanIfNeeded()
            return
        }
        let lastOpenedDay = UserDefaults.standard.string(forKey: Constants.KEY_LAST_OPENED_DAY)
        let todayString: String = Date.serverDateFormatter.string(from: Date())
        
        if todayString != lastOpenedDay
        {
            PlansManager.shared.resetDrinkedWaterGlasses(date: todayString)
        }
    }
    
    func createWaterPlanIfNeeded()
    {
        if Contact.main()?.dailyWaterIntake == nil
        {
            print("WATER NOT YET ASKED")
        }
        else if let waterPlan = PlansManager.shared.getWaterPlan()
        {
            print("WATER PLAN ALREADY EXISTS")
            guard let dailyWaterIntake = Contact.main()?.dailyWaterIntake,
                  (waterPlan.completionInfo?.contains(where: { $0.dailyWaterIntake == nil }) ?? false) else { return }
            var waterPlan = waterPlan
            for index in stride(from: 0, to: waterPlan.completionInfo?.count ?? 0, by: 1)
            {
                if waterPlan.completionInfo?[index].dailyWaterIntake == nil
                {
                    waterPlan.completionInfo?[index].dailyWaterIntake = dailyWaterIntake
                }
            }
            ObjectStore.shared.clientSave(waterPlan)
            NotificationCenter.default.post(name: .newDataArrived, object: nil, userInfo: ["objectType": String(describing: Plan.self)])
        }
        else
        {
              let waterPlan = Plan(type: .reagentLifestyleRecommendation,
                                 typeId: Constants.WATER_LIFESTYLE_RECOMMENDATION_ID,
                                 completionInfo: [CompletionInfo(date: todayString, units: 0, dailyWaterIntake: Contact.main()?.dailyWaterIntake)])
            Server.shared.addSinglePlan(plan: waterPlan) { addedPlan in
                PlansManager.shared.addPlans(plansToAdd: [addedPlan])
                NotificationCenter.default.post(name: .newDataArrived, object: nil, userInfo: ["objectType": String(describing: Plan.self)])
            } onFailure: { error in
            }
        }
    }
}
