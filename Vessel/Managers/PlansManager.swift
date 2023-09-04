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
            RemindersManager.shared.setupRemindersIfNeeded()
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
                self.addExtraActivities()
                done()
            }
        onFailure:
            {
                self.addExtraActivities()
                done()
            }
        }
        else
        {
            addExtraActivities()
            done()
        }
    }
    
    func addExtraActivities()
    {
        addHardcodedActivities()
        addFuelActivities()
        addTakeATestActivityIfNeeded()
    }
    
    func addHardcodedActivities()
    {
        let act =
        [
            Tip(id: 1, last_updated: 1, title: "Meal Plan", description: "Research shows a well-crafted meal plan boosts nutrition, manages weight, and sustains energy", imageUrl: "https://s3.amazonaws.com/violetdemo.com/meal_plan_home.jpg", frequency: "Made just for you", isPlan: true, subtitle: "take a simple 3 minute quiz", longDescription: "Meal Plan:\n\nDay 1:\n\nLunch: Grilled Chicken Salad\n\nIngredients:\n2 chicken breasts\n2 cups mixed greens\n1 tomato\n1 cucumber\n1/4 cup feta cheese\n1/4 cup balsamic vinaigrette\nInstructions:\nGrill the chicken until no longer pink in the center.\nSlice the chicken and place it on top of the mixed greens.\nAdd sliced tomato and cucumber.\nSprinkle feta cheese on top.\nDrizzle with balsamic vinaigrette.\nSnack: Protein Shake\n\nIngredients:\n1 scoop protein powder\n1 cup almond milk\n1 banana\n1 tbsp peanut butter\nInstructions:\nBlend all ingredients until smooth.\nDinner: Salmon with Quinoa and Steamed Vegetables\n\nIngredients:\n1 salmon fillet\n1 cup quinoa\n2 cups mixed vegetables\nInstructions:\nCook the salmon until it flakes easily with a fork.\nCook the quinoa according to package instructions.\nSteam the vegetables until tender.\nServe the salmon with the quinoa and vegetables.\n...same for the rest of the week..."),
            Tip(id: 2, last_updated: 1, title: "Grocery Plan", description: "The healthy food you need to follow your food plan", imageUrl: "https://s3.amazonaws.com/violetdemo.com/grocery_plan_home.jpg", frequency: "Food for 7 days", isPlan: true, subtitle: "take a simple 3 minute quiz", longDescription: "Meat:\n\n14 chicken breasts (2 per day)\n7 salmon fillets (1 per day)\nVegetables:\n\n14 cups mixed greens (2 per day)\n7 tomatoes (1 per day)\n7 cucumbers (1 per day)\n14 cups mixed vegetables (2 per day)\nDairy:\n\n1.75 cups feta cheese (1/4 cup per day)\nGrains:\n\n7 cups quinoa (1 cup per day)\nProtein Powder:\n\n7 scoops protein powder (1 scoop per day)\nFruit:\n\n7 bananas (1 per day)\nNuts and Seeds:\n\n7 tbsp peanut butter (1 tbsp per day)\nCondiments:\n\n1.75 cups balsamic vinaigrette (1/4 cup per day)\nDrinks:\n\n7 cups almond milk (1 cup per day)"),
            Tip(id: 3, last_updated: 1, title: "Fitness Plan", description: "Scientific findings suggest a tailored fitness plan enhances strength, improves endurance, and boosts mood.", imageUrl: "https://s3.amazonaws.com/violetdemo.com/fitness_plan_home.jpg", frequency: "", isPlan: true, subtitle: "take a simple 3 minute quiz", longDescription: "• Day 1: Start with a warm-up of light jogging or brisk walking for 10 minutes. Then, move on to weight lifting - focus on compound movements like squats, bench press, and deadlifts. Aim for 3 sets of 8-12 reps for each. Take it slowly and focus on form. Finish with a cool down of stretching for 10 minutes.\n• Day 2: It's cardio day! Start with a 10-minute warm-up of jumping jacks or skipping rope. Then, go for a run - start with a pace you're comfortable with for 20-30 minutes. Try to push yourself a little harder each time. End with a cool down walk and stretching for 10 minutes.\n• Day 3: Rest day. But don't forget, rest doesn't mean doing nothing! Get some light activities like walking or stretching. It's a great time to use a foam roller for muscle recovery and to help reduce muscle soreness.\n• Day 4: Time for a full-body workout. Start with a 10-minute warm-up. Then, let's do some push-ups, pull-ups, lunges and planks. Aim for 3 sets of 10-15 reps for each. Remember, quality over quantity. Always maintain good form. Finish with a 10-minute full-body stretch.\n• Day 5: Cardio again! Let's mix it up with some interval training. Warm up for 10 minutes. Then, alternate between 2 minutes of intense running and 1 minute of walking for a total of 20 minutes. End with a cool down walk and stretching.\n• Day 6: Back to weight lifting. This time, let's focus on isolation exercises like bicep curls, tricep extensions, and leg curls. Go for 3 sets of 10-12 reps for each. And don't forget to stretch afterwards!\n• Day 7: Another rest day. Remember, your body needs this time to recover and build muscle. You might consider some light yoga or meditation to help reduce your stress levels."),
            Tip(id: 4, last_updated: 1, title: "Supplement Plan", description: "Personalized to you, toy help you feel your best", imageUrl: "https://s3.amazonaws.com/violetdemo.com/supplements.jpeg", frequency: "Your daily supplement routine", isPlan: true, subtitle: "take a simple 3 minute quiz", longDescription: "• Magnesium (Glycinate): 400 mg per day\n• Melatonin: 3 mg per day\n• L-Theanine: 200 mg per day\n• B6 as P-5-P: 25 mg per day\n• B12 as Methylcobalamin: 500 mcg per day\n• Sensoril Ashwagandha: 125 mg per day\n• Zinc Chelate: 15 mg per day")]
        activities.insert(contentsOf: act, at: 0)
    }
    
    func addFuelActivities()
    {
        //user must have taken at least one test before we show any fuel cards
        var results: [Result] = []
        if UserDefaults.standard.bool(forKey: Constants.KEY_USE_MOCK_RESULTS)
        {
            results = mockResults
        }
        else
        {
            results = Storage.retrieve(as: Result.self)
        }
        
        if results.count != 0
        {
            print("Adding fuel activities")
            var fuelActive = false
            guard Contact.FuelInfo != nil else
            {
                Contact.main()?.getFuel(onDone: {
                    self.addFuelActivities()
                })
                return
            }
            
            if Contact.FuelInfo?.is_active == true
            {
                fuelActive = true
            }
            if fuelActive
            {
                let fuel = Contact.FuelInfo!
                print("CONTACT HAS FUEL")
                if let getAMFuelRecommendation = ObjectStore.shared.quickGet(type: LifestyleRecommendation.self, id: Constants.FUEL_AM_LIFESTYLE_RECOMMENDATION_ID)
                {
                    //Show the AM Fuel Supplement card
                    if fuel.hasAMFormula()
                    {
                        var amMessage: String?
                        if let amCapsPerServing = fuel.amCapsulesPerServing()
                        {
                            if amCapsPerServing == 1
                            {
                                amMessage = NSLocalizedString("1 capsule after first meal", comment: "")
                            }
                            else
                            {
                                amMessage = String(format: NSLocalizedString("%i capsules after first meal", comment: ""), amCapsPerServing)
                            }
                        }
                        let amFuelCard = Tip(id: -getAMFuelRecommendation.id, last_updated: 0, title: getAMFuelRecommendation.title, description: getAMFuelRecommendation.description, imageUrl: getAMFuelRecommendation.imageURL ?? "", frequency: amMessage ?? "", isLifestyleRecommendation: true)
                        if !activities.contains(where: { $0.id == -getAMFuelRecommendation.id })
                        {
                            self.activities.append(amFuelCard)
                        }
                        
                        //make it show up every day
                        let plan = Plan(id: -getAMFuelRecommendation.id, type: .reagentLifestyleRecommendation, typeId: -getAMFuelRecommendation.id, dayOfWeek: [0, 1, 2, 3, 4, 5, 6])
                        if !plans.contains(where: { $0.id == -getAMFuelRecommendation.id })
                        {
                            plans.append(plan)
                        }
                    }
                    
                    if let getPMFuelRecommendation = ObjectStore.shared.quickGet(type: LifestyleRecommendation.self, id: Constants.FUEL_PM_LIFESTYLE_RECOMMENDATION_ID)
                    {
                        //Show the PM Fuel Supplement card
                        if fuel.hasPMFormula()
                        {
                            var pmMessage: String?
                            if let pmCapsPerServing = fuel.pmCapsulesPerServing()
                            {
                                if pmCapsPerServing == 1
                                {
                                    pmMessage = NSLocalizedString("1 capsule after last meal", comment: "")
                                }
                                else
                                {
                                    pmMessage = String(format: NSLocalizedString("%i capsules after last meal", comment: ""), pmCapsPerServing)
                                }
                            }
                            let pmFuelCard = Tip(id: -getPMFuelRecommendation.id, last_updated: 0, title: getPMFuelRecommendation.title, description: getPMFuelRecommendation.description, imageUrl: getPMFuelRecommendation.imageURL ?? "", frequency: pmMessage ?? "", isLifestyleRecommendation: true)
                            if !activities.contains(where: { $0.id == -getPMFuelRecommendation.id })
                            {
                                self.activities.append(pmFuelCard)
                            }
                            
                            //make it show up every day
                            let plan = Plan(id: -getPMFuelRecommendation.id, type: .reagentLifestyleRecommendation, typeId: -getPMFuelRecommendation.id, dayOfWeek: [0, 1, 2, 3, 4, 5, 6])
                            if !plans.contains(where: { $0.id == -getPMFuelRecommendation.id })
                            {
                                plans.append(plan)
                            }
                        }
                    }
                    else
                    {
                        assertionFailure("Unable to get PM card from Object Store")
                    }
                }
                else
                {
                    assertionFailure("Unable to get AM card from Object Store")
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
                    let plan = Plan(id: getFuelRecommendation.id, type: .reagentLifestyleRecommendation, typeId: getFuelRecommendation.id, dayOfWeek: [0, 1, 2, 3, 4, 5, 6])
                    if !plans.contains(where: { $0.id == getFuelRecommendation.id })
                    {
                        plans.append(plan)
                    }
                }
                else
                {
                    assertionFailure("Unable to get supplements card from Object Store")
                }
            }
        }
    }
    
    func addTakeATestActivityIfNeeded()
    {
        let todayDate = Date.serverDateFormatter.string(from: Date())
        let results = Storage.retrieve(as: Result.self).sorted(by: { $0.last_updated < $1.last_updated })
        let lastResult = results.last
        
        let lastResultInsertDate = lastResult?.last_updated == nil ? nil : Date.from(vesselTime: lastResult!.last_updated)
        if lastResultInsertDate == nil || (results.count <= Constants.WEEKS_UNTIL_START_REMINDING_TAKE_A_TEST_MONTHLY && lastResultInsertDate!.isMoreThan7DaysAgo()) || lastResultInsertDate!.isMoreThan1MonthAgo() || Date.isSameDay(date1: lastResultInsertDate!, date2: Date())
        {
            if let takeATestRecommendation = ObjectStore.shared.quickGet(type: LifestyleRecommendation.self, id: Constants.TAKE_A_TEST_LIFESTYLE_RECOMMENDATION_ID)
            {
                let takeATestCard = Tip(id: -takeATestRecommendation.id, last_updated: 0, title: takeATestRecommendation.title, description: takeATestRecommendation.description, imageUrl: takeATestRecommendation.imageURL ?? "", frequency: takeATestRecommendation.subtext ?? "", isLifestyleRecommendation: true)
                if !activities.contains(where: { $0.id == -takeATestRecommendation.id })
                {
                    activities.append(takeATestCard)
                }
                
                //make it show up every day
                var plan = Plan(id: -takeATestRecommendation.id, type: .reagentLifestyleRecommendation, typeId: -takeATestRecommendation.id, dayOfWeek: [0, 1, 2, 3, 4, 5, 6])
                guard let lastResultInsertDate = lastResultInsertDate else { return }
                if Date.isSameDay(date1: lastResultInsertDate, date2: Date())
                {
                    plan.completed = [todayDate]
                }
                if !plans.contains(where: { $0.id == -takeATestRecommendation.id })
                {
                    plans.append(plan)
                }
            }
        }
    }
    
    func addPlans(plansToAdd: [Plan])
    {
        for plan in plansToAdd
        {
            var plan = plan
            plan.createdDate = Date.serverDateFormatter.string(from: Date())
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
        NotificationCenter.default.post(name: .newPlanAddedOrRemoved, object: nil)
    }
    
    func removePlans(plansToRemove: [Plan], onComplete: (() -> ())? = nil)
    {
        for plan in plansToRemove
        {
            var plan = plan
            plan.removedDate = Date.serverDateFormatter.string(from: Date())
            ObjectStore.shared.clientSave(plan)
        }
        self.plans = Storage.retrieve(as: Plan.self)
        loadActivitiesForPlans
        {
            Log_Add("PlansManager: removePlans() - post .newDataArrived: Plan")
            NotificationCenter.default.post(name: .newDataArrived, object: nil, userInfo: ["objectType": String(describing: Plan.self)])
            onComplete?()
        }
        if plansToRemove.contains(where: {  $0.type == .food })
        {
            NotificationCenter.default.post(name: .newDataArrived, object: nil, userInfo: ["objectType": String(describing: Food.self)])
        }
        NotificationCenter.default.post(name: .newPlanAddedOrRemoved, object: nil)
    }
    
    func setPlanCompleted(planId: Int, date: String, isComplete: Bool)
    {
        guard let index = plans.firstIndex(where: { $0.id == planId }) else
        {
            assertionFailure("PlansManager-setPlanCompleted: Couldn't find plan index")
            return
        }
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
        if plans[index].id < 0
        {
            let plan = Plan(plan: plans[index])
            ObjectStore.shared.clientSave(plan)
        }
        else
        {
            ObjectStore.shared.clientSave(plans[index])
        }
    }
    
    //returns array of only food plans, if variable shouldFilterForToday is true then it will return all food without removedDate, or if shouldFilterForPastDay variable has a value, it will filter for food existing on that date with server format (yyyy-MM-dd)
    func getFoodPlans(shouldFilterForToday: Bool = false, shouldFilterForSelectedDay selectedDate: String? = nil) -> [Plan]
    {
        let todayDate = Date.serverDateFormatter.string(from: Date())

        if shouldFilterForToday
        {
            return plans.filter({ $0.type == .food && $0.removedDate == nil })
        }
        else if let selectedDate = selectedDate
        {
            return plans.filter({ $0.type == .food && (selectedDate >= $0.createdDate && selectedDate < ($0.removedDate ?? todayDate)) })
        }
        else
        {
            return plans.filter({ $0.type == .food })
        }
    }
    
    func getFirstFoodPlan(withId foodId: Int, shouldFilterForToday: Bool, shouldFilterForSelectedDay selectedDate: String? = nil) -> Plan?
    {
        getFoodPlans(shouldFilterForToday: shouldFilterForToday, shouldFilterForSelectedDay: selectedDate).first(where: { $0.typeId == foodId })
    }
    
    //returns array of only activities, if variable shouldFilterForToday is true then it will return all activities without removedDate, or if shouldFilterForPastDay variable has a value, it will filter for activities existing on that date with server format (yyyy-MM-dd)
    func getActivityPlans(shouldFilterForToday: Bool = false, shouldFilterForSelectedDate selectedDate: String? = nil) -> [Plan]
    {
        let todayDate = Date.serverDateFormatter.string(from: Date())

        if shouldFilterForToday
        {
            return plans.filter({ $0.type == .activity && $0.removedDate == nil })
        }
        else if let selectedDate = selectedDate
        {
            return plans.filter({ $0.type == .activity && (selectedDate >= $0.createdDate && selectedDate < ($0.removedDate ?? todayDate)) })
        }
        else
        {
            return plans.filter({ $0.type == .activity })
        }
    }
    
    func getFirstActivityPlan(withId foodId: Int, shouldFilterForToday: Bool, shouldFilterForSelectedDay selectedDate: String? = nil) -> Plan?
    {
        getActivityPlans(shouldFilterForToday: shouldFilterForToday, shouldFilterForSelectedDate: selectedDate).first(where: { $0.typeId == foodId })
    }
    
    //returns array of only reagentLifestyleRecommendations
    func getLifestyleRecommendationPlans() -> [Plan]
    {
        return plans.filter({ $0.type == .reagentLifestyleRecommendation })
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
    
    // Given a certain date in server format (yyyy-MM-dd) calculate the progress for this date and returns it in a value from 0 to 1
    func calculateProgressFor(date: String) -> Double
    {
        guard let contact = Contact.main(),
              let createdDate = contact.createdDate, createdDate <= date else
        {
//            assertionFailure("PlansManager-calculateProgressFor: mainContact not available or mainContact's createdDate not set")

            return 0
        }
        
        let todayDate = Date.serverDateFormatter.string(from: Date())
        
        // Feature flags
        let showInsights: Bool = RemoteConfigManager.shared.getValue(for: .insightsFeature) as? Bool ?? false
        let showActivites: Bool = RemoteConfigManager.shared.getValue(for: .activitiesFeature) as? Bool ?? false
        let showWater: Bool = RemoteConfigManager.shared.getValue(for: .waterFeature) as? Bool ?? false
        let showFood: Bool = RemoteConfigManager.shared.getValue(for: .foodFeature) as? Bool ?? false

        var progress: Double = 0.0
        var parts: Double = 0.0
        
        // Activities
        let activities: [Plan] = getActivityPlans(shouldFilterForToday: date == todayDate, shouldFilterForSelectedDate: date)
        
        let plans = activities + getLifestyleRecommendationPlans().filter({ $0.typeId != Constants.WATER_LIFESTYLE_RECOMMENDATION_ID && $0.typeId != Constants.GET_SUPPLEMENTS_LIFESTYLE_RECOMMENDATION_ID && $0.typeId != -Constants.TAKE_A_TEST_LIFESTYLE_RECOMMENDATION_ID })
        if showActivites
        {
            if !plans.isEmpty
            {
                parts += 1
                progress += Double(plans.filter({ $0.completed.contains(date) }).count) / Double(plans.count)
            }
        }
        
        // Food
        let food: [Plan] = getFoodPlans(shouldFilterForToday: date == todayDate, shouldFilterForSelectedDay: date)

        if showFood && !food.isEmpty && !Contact.main()!.suggestedFood.isEmpty
        {
            parts += 1
            progress += food.contains(where: { $0.completed.contains(date) }) ? 1.0 : 0.0
        }
        
        // Insights
        if showInsights && LessonsManager.shared.lessonsAvailable(forDate: date)
        {
            parts += 1
            let completedLessonsCount = LessonsManager.shared.getLessonsCompletedOn(dateString: date).count
            progress += completedLessonsCount > 0 ? 1.0 : 0.0
        }
        
        // Water
        if let waterActivity = getWaterPlan(), let dailyWaterIntake = WaterManager.shared.getDailyWaterIntake(date: date), showWater
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
        // Get unique completion dates from plans and lessons
        let completedPlanDates = Array<String>(plans.map({ $0.completed }).joined())
        let completedLessonsDates = LessonsManager.shared.completedLessonsDates()
        var completedDates = [String]()
        completedDates.append(contentsOf: completedPlanDates)
        completedDates.append(contentsOf: completedLessonsDates)
        let uniqueDates = Array(Set(completedDates)).sorted(by: { $0 < $1 })

        // Convert dates strings to Date array and sort them
        var dateArray: [Date] = []
        for dateString in uniqueDates
        {
            if let date = Date.serverDateFormatter.date(from: dateString)
            {
                dateArray.append(date)
            }
        }
        dateArray.sort()
        
        // Calculate maxConsecutiveWeeks
        var maxConsecutiveWeeks = 0
        var currentConsecutiveWeeks = 0
        var previousWeek = -1
        for (index, date) in dateArray.enumerated()
        {
            let progress = calculateProgressFor(date: uniqueDates[index])
            let weekOfYear = Calendar.current.component(.weekOfYear, from: date)
            
            if previousWeek == -1 && progress == 1.0
            {
                currentConsecutiveWeeks = 1
                previousWeek = weekOfYear
            }
            else if previousWeek + 1 == weekOfYear && progress == 1.0
            {
                currentConsecutiveWeeks += 1
                previousWeek = weekOfYear
            }
            else
            {
                maxConsecutiveWeeks = max(maxConsecutiveWeeks, currentConsecutiveWeeks)
                currentConsecutiveWeeks = 1
                previousWeek = weekOfYear
            }
        }
        maxConsecutiveWeeks = max(maxConsecutiveWeeks, currentConsecutiveWeeks)
        return maxConsecutiveWeeks
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
        guard let waterPlanIndex = plans.firstIndex(where: { $0.typeId == Constants.WATER_LIFESTYLE_RECOMMENDATION_ID && $0.type == .reagentLifestyleRecommendation }) else
        {
            assertionFailure("PlansManager-setValueToWaterPlan: Couldn't find water plan index")
            return
        }
        if let completionInfoIndex = plans[waterPlanIndex].completionInfo?.firstIndex(where: { $0.date == date })
        {
            plans[waterPlanIndex].completionInfo![completionInfoIndex].units = value
        }
        else if plans[waterPlanIndex].completionInfo != nil
        {
            plans[waterPlanIndex].completionInfo!.append(CompletionInfo(date: date, units: value, dailyWaterIntake: Contact.main()?.dailyWaterIntake))
        }
        else
        {
            plans[waterPlanIndex].completionInfo = [CompletionInfo(date: date, units: value, dailyWaterIntake: Contact.main()?.dailyWaterIntake)]
        }
        
        ObjectStore.shared.clientSave(plans[waterPlanIndex])
        NotificationCenter.default.post(name: .newDataArrived, object: nil, userInfo: ["objectType": String(describing: Plan.self)])
    }
    
    func resetDrinkedWaterGlasses(date: String)
    {
        guard let waterPlanIndex = plans.firstIndex(where: { $0.typeId == Constants.WATER_LIFESTYLE_RECOMMENDATION_ID && $0.type == .reagentLifestyleRecommendation }),
              plans[waterPlanIndex].completionInfo?.first(where: { $0.date == date }) == nil,
              let dailyWaterIntake = Contact.main()?.dailyWaterIntake else { return }
        plans[waterPlanIndex].completionInfo?.append(CompletionInfo(date: date, units: 0, dailyWaterIntake: dailyWaterIntake))
        ObjectStore.shared.clientSave(plans[waterPlanIndex])
    }
}
