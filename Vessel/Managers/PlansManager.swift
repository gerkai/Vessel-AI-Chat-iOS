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
        print("loadActivitiesForPlans()")
        let activityIDs = self.getActivityPlans().map({ $0.typeId })
        let uniqueActivityIds = Array(Set(activityIDs))
        if uniqueActivityIds.count != 0
        {
            ObjectStore.shared.get(type: Tip.self, ids: uniqueActivityIds)
            { activities in
                self.activities = activities
                self.addFuelActivities()
                done()
            }
        onFailure:
            {
                self.addFuelActivities()
                done()
            }
        }
        else
        {
            addFuelActivities()
            done()
        }
    }
    
    func addFuelActivities()
    {
        print("Adding fuel activities")
        if Contact.main()!.hasFuel
        {
            print("CONTACT HAS FUEL")
            if let getAMFuelRecommendation = ObjectStore.shared.quickGet(type: LifestyleRecommendation.self, id: Constants.FUEL_AM_LIFESTYLE_RECOMMENDATION_ID)
            {
                //Show the AM Fuel Supplement card
                if Contact.main()!.hasAMFormula
                {
                    let amFuelCard = Tip(id: -getAMFuelRecommendation.id, last_updated: 0, title: getAMFuelRecommendation.title, description: getAMFuelRecommendation.description, imageUrl: getAMFuelRecommendation.imageURL ?? "", frequency: getAMFuelRecommendation.subtext ?? "", isLifestyleRecommendation: true)
                    if !activities.contains(where: { $0.id == -getAMFuelRecommendation.id })
                    {
                        self.activities.append(amFuelCard)
                    }
                    
                    //make it show up every day
                    let plan = Plan(id: -getAMFuelRecommendation.id, type: .lifestyleRecommendation, typeId: -getAMFuelRecommendation.id, dayOfWeek: [0, 1, 2, 3, 4, 5, 6])
                    if !plans.contains(where: { $0.id == -getAMFuelRecommendation.id })
                    {
                        plans.append(plan)
                    }
                }
                
                if let getPMFuelRecommendation = ObjectStore.shared.quickGet(type: LifestyleRecommendation.self, id: Constants.FUEL_PM_LIFESTYLE_RECOMMENDATION_ID)
                {
                    //Show the PM Fuel Supplement card
                    if Contact.main()!.hasPMFormula
                    {
                        let pmFuelCard = Tip(id: -getPMFuelRecommendation.id, last_updated: 0, title: getPMFuelRecommendation.title, description: getPMFuelRecommendation.description, imageUrl: getPMFuelRecommendation.imageURL ?? "", frequency: getPMFuelRecommendation.subtext ?? "", isLifestyleRecommendation: true)
                        if !activities.contains(where: { $0.id == -getPMFuelRecommendation.id })
                        {
                            self.activities.append(pmFuelCard)
                        }
                        
                        //make it show up every day
                        let plan = Plan(id: -getPMFuelRecommendation.id, type: .lifestyleRecommendation, typeId: -getPMFuelRecommendation.id, dayOfWeek: [0, 1, 2, 3, 4, 5, 6])
                        if !plans.contains(where: { $0.id == -getPMFuelRecommendation.id })
                        {
                            plans.append(plan)
                        }
                    }
                }
                else
                {
                    print("Unable to get PM card from Object Store")
                }
            }
            else
            {
                print("Unable to get AM card from Object Store")
            }
        }
        else
        {
            print("CONTACT DOES NOT HAVE FUEL. Adding Get Supplement Plan card")
            //add get fuel card to both activities array and plans array
            if let getFuelRecommendation = ObjectStore.shared.quickGet(type: LifestyleRecommendation.self, id: Constants.GET_SUPPLEMENTS_LIFESTYLE_RECOMMENDATION_ID)
            {
                let getFuelCard = Tip(id: getFuelRecommendation.id, last_updated: 0, title: getFuelRecommendation.title, description: getFuelRecommendation.description, imageUrl: getFuelRecommendation.imageURL ?? "", frequency: getFuelRecommendation.subtext ?? "", isLifestyleRecommendation: true)
                if !activities.contains(where: { $0.id == getFuelRecommendation.id })
                {
                    activities.append(getFuelCard)
                }
                
                //make it show up every day
                let plan = Plan(id: getFuelRecommendation.id, type: .lifestyleRecommendation, typeId: getFuelRecommendation.id, dayOfWeek: [0, 1, 2, 3, 4, 5, 6])
                if !plans.contains(where: { $0.id == getFuelRecommendation.id })
                {
                    plans.append(plan)
                }
            }
            else
            {
                //This is a workaround for a bug with the quickGet function where randomly won't return stored objects (maybe those got deteled?)
                // TODO: Fix
                //CW: I think this section won't ever get called now as I fixed the race condition that was causing the objects to sometimes not be in the object store.
                print("FUEL RECOMMENDATION DOESN'T EXISTS")
                Server.shared.getLifestyleRecommendation(id: Constants.GET_SUPPLEMENTS_LIFESTYLE_RECOMMENDATION_ID, onSuccess:
                                                            { result in
                    ObjectStore.shared.serverSave(result)
                    self.addFuelActivities()
                    Log_Add("PlansManager: loadPlans() - post .newDataArrived: Plan")
                    NotificationCenter.default.post(name: .newDataArrived, object: nil, userInfo: ["objectType": String(describing: Plan.self)])
                },
                                                         onFailure:
                                                            { error in
                    print("ERROR ADDING FUEL ACTIVITIES: \(String(describing: error))")
                })
            }
        }
    }
    
    func addPlans(plansToAdd: [Plan])
    {
        for plan in plansToAdd
        {
            ObjectStore.shared.serverSave(plan, notifyNewDataArrived: plan == plansToAdd.last)
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
        NotificationCenter.default.post(name: .newPlanAdded, object: nil)
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
        NotificationCenter.default.post(name: .newPlanAdded, object: nil)
    }
    
    func setPlanCompleted(planId: Int, date: String, isComplete: Bool)
    {
        guard let index = plans.firstIndex(where: { $0.id == planId }) else { return }
        if isComplete
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
    
    //returns array of only food plans
    func getFoodPlans() -> [Plan]
    {
        return plans.filter({ $0.type == .food })
    }
    
    //returns array of only activities
    func getActivityPlans() -> [Plan]
    {
        return plans.filter({ $0.type == .activity })
    }
    
    //returns array of only reagentLifestyleRecommendations
    func getLifestyleRecommendationPlans() -> [Plan]
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
        let showWater: Bool = RemoteConfigManager.shared.getValue(for: .waterFeature) as? Bool ?? false
        let showFood: Bool = RemoteConfigManager.shared.getValue(for: .foodFeature) as? Bool ?? false

        var progress: Double = 0.0
        var parts: Double = 0.0
        
        // Activities
        let plans = getActivityPlans() + getLifestyleRecommendationPlans().filter({ $0.typeId != Constants.WATER_LIFESTYLE_RECOMMENDATION_ID && $0.typeId != Constants.GET_SUPPLEMENTS_LIFESTYLE_RECOMMENDATION_ID })
        if showActivites
        {
            if !plans.isEmpty
            {
                parts += 1
                progress += Double(plans.filter({ $0.completed.contains(date) }).count) / Double(plans.count)
            }
        }
        
        // Foods
        let foods = getFoodPlans()
        if showFood && !foods.isEmpty && !Contact.main()!.suggestedFoods.isEmpty
        {
            parts += 1
            progress += foods.contains(where: { $0.completed.contains(date) }) ? 1.0 : 0.0
        }
        
        // Insights
        if showInsights
        {
            parts += 1
            let completedLessonsCount = LessonsManager.shared.getLessonsCompletedOn(dateString: date).count
            progress += completedLessonsCount > 0 ? 1.0 : 0.0
        }
        
        // Water
        if let contact = Contact.main(), let waterActivity = getWaterPlan(), let dailyWaterIntake = contact.dailyWaterIntake, showWater
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
    
    func calculateWeekStreak() -> Int
    {
        let progress = getLastWeekPlansProgress()
        var maxStreak = 0
        var currentStreak = 0
        for day in progress.keys.sorted(by: { $0 < $1 })
        {
            if progress[day] == 1.0
            {
                currentStreak += 1
            }
            else
            {
                currentStreak = 0
            }
            if currentStreak > maxStreak
            {
                maxStreak = currentStreak
            }
        }
        return maxStreak
    }
    
    func allCompletedDaysCount() -> Int
    {
        let completedPlanDates = Array<String>(plans.map({ $0.completed }).joined())
        let completedLessonsDates = LessonsManager.shared.completedLessonsDates()
        var completedDates = [String]()
        completedDates.append(contentsOf: completedPlanDates)
        completedDates.append(contentsOf: completedLessonsDates)
        let uniqueDates = Array(Set(completedDates)).sorted(by: { $0 < $1 })
        
        var completeDays = 0
        for date in uniqueDates
        {
            if calculateProgressFor(date: date) == 1.0
            {
                completeDays += 1
            }
        }
        return completeDays
    }
}

// MARK: - Water Logic
extension PlansManager
{
    func getWaterPlan() -> Plan?
    {
        return getLifestyleRecommendationPlans().first(where: { $0.typeId == Constants.WATER_LIFESTYLE_RECOMMENDATION_ID })
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
        
        ObjectStore.shared.clientSave(plans[waterPlanIndex])
        NotificationCenter.default.post(name: .newDataArrived, object: nil, userInfo: ["objectType": String(describing: Plan.self)])
    }
    
    func resetDrinkedWaterGlasses(date: String)
    {
        guard let waterPlanIndex = plans.firstIndex(where: { $0.typeId == Constants.WATER_LIFESTYLE_RECOMMENDATION_ID && $0.type == .lifestyleRecommendation }),
              plans[waterPlanIndex].completionInfo?.first(where: { $0.date == date }) == nil else { return }
        plans[waterPlanIndex].completionInfo?.append(CompletionInfo(date: date, units: 0))
    }
}
