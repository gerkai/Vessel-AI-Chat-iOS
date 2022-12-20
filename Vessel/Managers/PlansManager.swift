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
    var activities = [Tip]()
    
    func loadPlans()
    {
        plans = Storage.retrieve(as: Plan.self)
        loadActivitiesForPlans
        {
            Log_Add("PlansManager: loadPlans() - post .newDataArrived: Plan")
            NotificationCenter.default.post(name: .newDataArrived, object: nil, userInfo: ["objectType": String(describing: Plan.self)])
        }
    }
    
    private func loadActivitiesForPlans(onDone done: @escaping () -> Void)
    {
        let activityIDs = self.getActivities().map({ $0.typeId })
        let uniqueActivityIds = Array(Set(activityIDs))
        if uniqueActivityIds.count != 0
        {
            ObjectStore.shared.get(type: Tip.self, ids: uniqueActivityIds)
            { activities in
                self.activities = activities
                done()
            }
        onFailure:
            {
                done()
            }
        }
    }
    
    func addPlans(plansToAdd: [Plan])
    {
        for plan in plansToAdd
        {
            ObjectStore.shared.serverSave(plan)
        }
        self.plans = Storage.retrieve(as: Plan.self)
        if plansToAdd.contains(where: { $0.type == .activity })
        {
            loadActivitiesForPlans
            {
                Log_Add("PlansManager: addPlans() - post .newDataArrived: Plan")
                NotificationCenter.default.post(name: .newDataArrived, object: nil, userInfo: ["objectType": String(describing: Plan.self)])
            }
        }
    }
    
    func removePlans(plansToRemove: [Plan])
    {
        for plan in plansToRemove
        {
            ObjectStore.shared.removeFromCache(plan)
            Storage.remove(plan.id, objectType: Plan.self)
            plans.removeAll{$0.id == plan.id}
        }
        self.plans = Storage.retrieve(as: Plan.self)
        if plansToRemove.contains(where: { $0.type == .activity })
        {
            loadActivitiesForPlans
            {
                Log_Add("PlansManager: removePlans() - post .newDataArrived: Plan")
                NotificationCenter.default.post(name: .newDataArrived, object: nil, userInfo: ["objectType": String(describing: Plan.self)])
            }
        }
        if plansToRemove.contains(where: {  $0.type == .food })
        {
            NotificationCenter.default.post(name: .newDataArrived, object: nil, userInfo: ["objectType": String(describing: Food.self)])
        }
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
        ObjectStore.shared.serverSave(plans[index])
    }
    
    func remove(plan: Plan)
    {
        plans.removeAll{$0.id == plan.id}
        Storage.remove(plan.id, objectType: Plan.self)
        ObjectStore.shared.removeFromCache(plan)
        if plan.type == .activity
        {
            loadActivitiesForPlans
            {
                Log_Add("PlansManager: remove() - post .newDataArrived: Plan")
                NotificationCenter.default.post(name: .newDataArrived, object: nil, userInfo: ["objectType": String(describing: Plan.self)])
            }
        }
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

// MARK: - Gamification

extension PlansManager
{
    func getLastWeekPlansProgress() -> [String: Double]
    {
        var progress = [String: Double]()
        let currentDate = Date()
        var offset = -6
        var startDate = Calendar.current.date(byAdding: .day, value: offset, to: currentDate) ?? Date()
        while offset <= 0
        {
            let dateString = Date.serverDateFormatter.string(from: startDate)
            progress[dateString] = calculateProgressFor(date: dateString)
            offset += 1
            startDate = Calendar.current.date(byAdding: .day, value: offset, to: currentDate) ?? Date()
        }
        return progress
    }
    
    // Given a certain date in server format calculate the progress for this date and returns it in a value from 0 to 1
    func calculateProgressFor(date: String) -> Double
    {
        // Feature flags
        let showInsights: Bool = RemoteConfigManager.shared.getValue(for: .insightsFeature) as? Bool ?? false
        let showActivites: Bool = RemoteConfigManager.shared.getValue(for: .activitiesFeature) as? Bool ?? false

        var progress: Double = 0.0
        var parts: Double = 0.0
        
        // Activities
        let activities = getActivities()
        if showActivites && !activities.isEmpty
        {
            parts += 1
            progress += Double(activities.filter({ $0.completed.contains(date) }).count) / Double(activities.count)
        }
        
        // Foods
        let foods = getFoodPlans()
        if !foods.isEmpty
        {
            parts += 1
            progress += foods.contains(where: { $0.completed.contains(date) }) ? 1.0 : 0.0
        }
        
        // Insights
        if showInsights && !LessonsManager.shared.lessonsCompleted()
        {
            parts += 1
            let completedLessonsCount = LessonsManager.shared.getLessonsCompletedOn(dateString: date).count
            progress += completedLessonsCount > 0 ? 1.0 : 0.0
        }
        
        // Water
        if let contact = Contact.main(), let waterActivity = getWaterPlan(), let dailyWaterIntake = contact.dailyWaterIntake
        {
            parts += 1
            let amount = waterActivity.completionInfo?.first(where: { $0.date == date })?.units
            progress += Double(amount ?? 0) / Double(dailyWaterIntake)
        }
        
        if parts == 0
        {
            return 0.0
        }
        else
        {
            return progress / parts
        }
    }
}

// MARK: - Water Logic
extension PlansManager
{
    func getWaterPlan() -> Plan?
    {
        return getLifestyleRecommendations().first(where: { $0.typeId == Constants.WATER_LIFESTYLE_RECOMMENDATION_ID })
    }
    
    func setValueToWaterPlan(value: Int, date: String)
    {
        guard let waterPlanIndex = plans.firstIndex(where: { $0.typeId == Constants.WATER_LIFESTYLE_RECOMMENDATION_ID && $0.type == .lifestyleRecommendation }) else { return }
        if let completionInfoIndex = plans[waterPlanIndex].completionInfo?.firstIndex(where: { $0.date == date })
        {
            plans[waterPlanIndex].completionInfo![completionInfoIndex].units = value
        }
        else if plans[waterPlanIndex].completionInfo != nil
        {
            plans[waterPlanIndex].completionInfo!.append(CompletionInfo(date: date, units: value))
        }
        else
        {
            plans[waterPlanIndex].completionInfo = [CompletionInfo(date: date, units: value)]
        }
        
        ObjectStore.shared.ClientSave(plans[waterPlanIndex])
        NotificationCenter.default.post(name: .newDataArrived, object: nil, userInfo: ["objectType": String(describing: Plan.self)])
    }
    
    func resetDrinkedWaterGlasses(date: String)
    {
        guard let waterPlanIndex = plans.firstIndex(where: { $0.typeId == Constants.WATER_LIFESTYLE_RECOMMENDATION_ID && $0.type == .lifestyleRecommendation }),
              plans[waterPlanIndex].completionInfo?.first(where: { $0.date == date }) == nil else { return }
        plans[waterPlanIndex].completionInfo?.append(CompletionInfo(date: date, units: 0))
    }
}
