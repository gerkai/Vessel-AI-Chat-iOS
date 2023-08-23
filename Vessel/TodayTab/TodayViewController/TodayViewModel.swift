//
//  TodayViewModel.swift
//  Vessel
//
//  Created by Nicolas Medina on 9/27/22.
//

import UIKit

enum CheckMarkCardType
{
    case lesson
    case activity
    case lifestyleRecommendation
}

enum TodayViewSection: Equatable
{
    case header(name: String, goals: [String])
    case progressDays(progress: [String: Double])
    case insights(insights: [Lesson], isToday: Bool)
    case activities(activities: [Tip], selectedDate: String, isToday: Bool)
    case food(food: [Food], selectedDate: String, userHasTakenATest: Bool)
    case water(glassesNumber: Int?, checkedGlasses: Int, isWaterPlanCreatedForSelectedDay: Bool, lastSelectedGlassesNumber: Int?, isWaterPlanCreatedToday: Bool)
    //case customize
    case footer
    case userNotYetCreated
    
    var sectionIndex: Int
    {
        switch self
        {
        case .header: return 0
        case .progressDays: return 1
        case .insights: return 2
        case .activities: return 3
        case .food: return 4
        case .water: return 5
        case .footer: return 6
        case .userNotYetCreated: return 1
        }
    }
    
    var cells: [TodayViewCell]
    {
        switch self
        {
        case .header(let name, let goals): return [.header(name: name, goals: goals)]
        case .progressDays(let progress): return createProgressDaySection(progress: progress)
        case .insights(let lessons, let isToday): return createInsightsSection(lessons: lessons, isToday: isToday)
        case .activities(let activities, let selectedDate, let isToday): return createActivitiesSection(activities: activities, selectedDate: selectedDate, isToday: isToday)
        case .food(let food, let selectedDate, let userHasTakenATest): return createFoodSection(food: food, selectedDate: selectedDate, userHasTakenATest: userHasTakenATest)
        case .water(let glassesNumber, let checkedGlasses, let isWaterPlanCreatedForSelectedDay, let lastSelectedGlassesNumber, let isWaterPlanCreatedToday): return createWaterSection(glassesNumber: glassesNumber, checkedGlasses: checkedGlasses, isWaterPlanCreatedForSelectedDay: isWaterPlanCreatedForSelectedDay, lastSelectedGlassesNumber: lastSelectedGlassesNumber, isWaterPlanCreatedToday: isWaterPlanCreatedToday)
        case .footer: return [.footer]
        case .userNotYetCreated: return [.sectionTitle(icon: "starIcon", name: NSLocalizedString("You can't go back in time,", comment: ""), showInfoIcon: false), .text(text: NSLocalizedString("it's just too dangerous Marty.", comment: ""), alignment: .left)]
        }
    }
    
    func createProgressDaySection(progress: [String: Double]) -> [TodayViewCell]
    {
        guard progress.count > 0 else { return [] }
        return [
            .progressDays(progress: progress)
        ]
    }
    
    func createInsightsSection(lessons: [Lesson], isToday: Bool) -> [TodayViewCell]
    {
        guard lessons.count > 0 else
        {
            if isToday
            {
                if LessonsManager.shared.planBuilt
                {
                    return [
                        .sectionTitle(icon: "todayInsightsIcon", name: "Insights", showInfoIcon: true),
                        .text(text: NSLocalizedString("Congratulations you completed all your insights, change your goals to get more.", comment: ""), alignment: .center)
                    ]
                }
                else
                {
                    return [
                        .sectionTitle(icon: "todayInsightsIcon", name: "Insights", showInfoIcon: true),
                        .loader
                    ]
                }
            }
            else
            {
                return [
                    .sectionTitle(icon: "todayInsightsIcon", name: "Insights", showInfoIcon: true),
                    .text(text: NSLocalizedString("Insights you complete will show up here.", comment: ""), alignment: .center)
                ]
            }
        }
        var cells: [TodayViewCell] = [.sectionTitle(icon: "todayInsightsIcon", name: "Insights", showInfoIcon: true)]
        for lesson in lessons
        {
            if lesson.completedDate == nil
            {
                cells.append(.checkMarkCard(title: lesson.title,
                                            subtitle: lesson.subtitleString(),
                                            description: lesson.description,
                                            backgroundImage: lesson.imageUrl ?? "",
                                            isCompleted: false,
                                            id: lesson.id,
                                            type: .lesson,
                                            remindersButtonState: nil,
                                            remindersButtonText: nil,
                                            longDescription: nil))
            }
            else
            {
                cells.append(.foldedCheckMarkCard(title: lesson.title,
                                                  subtitle: lesson.subtitleString(),
                                                  backgroundImage: lesson.imageUrl ?? ""))
                if isToday
                {
                    if lesson == lessons.first
                    {
                        cells.append(.text(text: NSLocalizedString("Today's insight is done!", comment: ""), alignment: .center))
                    }
                    if lesson == lessons.last && LessonsManager.shared.nextLesson != nil
                    {
                        if lessons.count == 4
                        {
                            cells.append(.text(text: NSLocalizedString("Come back tomorrow for more insights", comment: ""), alignment: .center))
                        }
                        else
                        {
                            cells.append(.button(text: NSLocalizedString("Unlock More Insights", comment: "")))
                        }
                    }
                }
            }
        }
        return cells
    }
    
    func createActivitiesSection(activities: [Tip], selectedDate: String, isToday: Bool) -> [TodayViewCell]
    {
        let todayDate = Date.serverDateFormatter.string(from: Date())
        guard activities.count > 0 else { return [] }
        var cells: [TodayViewCell] = [.sectionTitle(icon: "activities-icon", name: "Activities", showInfoIcon: true)]
        for activity in activities
        {
            var plan: Plan?
            if activity.isLifestyleRecommendation
            {
                plan = PlansManager.shared.getLifestyleRecommendationPlans().first(where: { $0.typeId == activity.id })
            }
            else
            {
                if isToday
                {
                    plan = PlansManager.shared.getActivityPlans().first(where: { $0.typeId == activity.id && $0.removedDate == nil  })
                }
                else
                {
                    plan = PlansManager.shared.getActivityPlans().first(where: { $0.typeId == activity.id && selectedDate >= $0.createdDate && selectedDate < ($0.removedDate ?? todayDate)  })
                }
            }
            
            if activity.isPlan
            {
                cells.append(.checkMarkCard(title: activity.title,
                                            subtitle: activity.frequency,
                                            description: activity.description ?? "test desc",
                                            backgroundImage: activity.imageUrl,
                                            isCompleted: false,
                                            id: activity.id,
                                            type: activity.isLifestyleRecommendation ? .lifestyleRecommendation : .activity,
                                            remindersButtonState: true,
                                            remindersButtonText: "",
                                            longDescription: activity.longDescription))
            }
            
            if let plan = plan, activity.isLifestyleRecommendation || (isToday ? plan.removedDate == nil : (selectedDate >= plan.createdDate && selectedDate < (plan.removedDate ?? todayDate)))
            {
                RemindersManager.shared.reloadReminders()
                let reminders = RemindersManager.shared.getRemindersForPlan(planId: plan.id)
                if plan.completed.contains(selectedDate)
                {
                    cells.append(.foldedCheckMarkCard(title: activity.title,
                                                      subtitle: "",
                                                      backgroundImage: activity.imageUrl))
                }
                else
                {
                    let description: String
                    if activity.isLifestyleRecommendation && activity.id == -Constants.FUEL_AM_LIFESTYLE_RECOMMENDATION_ID
                    {
                        var goals = Contact.main()?.getGoals() ?? []
                        if goals.contains("Sleep") && goals.count > 1
                        {
                            goals.removeAll(where: { $0 == "Sleep" })
                        }
                        description = String(format: activity.description ?? "", goals.map({ $0.lowercased() }).joined(separator: ", "))
                    }
                    else
                    {
                        description = activity.description ?? ""
                    }
                    cells.append(.checkMarkCard(title: activity.title,
                                                subtitle: activity.frequency,
                                                description: activity.description ?? "test desc",
                                                backgroundImage: activity.imageUrl,
                                                isCompleted: false,
                                                id: activity.id,
                                                type: activity.isLifestyleRecommendation ? .lifestyleRecommendation : .activity,
                                                remindersButtonState: reminders.count > 0,
                                                remindersButtonText: RemindersManager.shared.getNextReminderTime(forPlan: plan.id),
                                                longDescription: activity.longDescription))
                }
            }
        }
        return cells
        
//        cells.append(.checkMarkCard(title: "Get your supplement plan",// activity.title,
//                                    subtitle: "Take a simple 3 minute quiz",// activity.frequency,
//                                    description: "Get a precise supplement plan personilized to you. get started",// activity.description ?? "test desc",
//                                    backgroundImage: activity.imageUrl,
//                                    isCompleted: false,
//                                    id: activity.id,
//                                    type: activity.isLifestyleRecommendation ? .lifestyleRecommendation : .activity,
//                                    remindersButtonState: true, // reminders.count > 0,
//                                    remindersButtonText: "remindersButtonText"))
    }
    
    func createFoodSection(food: [Food], selectedDate: String, userHasTakenATest: Bool) -> [TodayViewCell]
    {
        guard food.count > 0 else
        {
            if !userHasTakenATest
            {
                return [
                    .sectionTitle(icon: "food-icon", name: "Food", showInfoIcon: true),
                    .lockedCheckMarkCard(backgroundImage: "food-placeholder", subtext: NSLocalizedString("Get personalized food recommendations", comment: ""))
                ]
            }
            else
            {
                return []
            }
        }
        return [
            .sectionTitle(icon: "food-icon", name: "Food", showInfoIcon: true),
            .foodDetails(food: food, selectedDate: selectedDate)
        ]
    }
    
    func createWaterSection(glassesNumber: Int?, checkedGlasses: Int, isWaterPlanCreatedForSelectedDay: Bool, lastSelectedGlassesNumber: Int?, isWaterPlanCreatedToday: Bool) -> [TodayViewCell]
    {
        guard let glassesNumber = glassesNumber else
        {
            if let glassesNumber = lastSelectedGlassesNumber, isWaterPlanCreatedForSelectedDay
            {
                return [
                    .sectionTitle(icon: "water-icon", name: "\(glassesNumber * 8) \(NSLocalizedString(" oz Water", comment: "Water amount in ounces"))", showInfoIcon: true),
                    .waterDetails(glassesNumber: glassesNumber, checkedGlasses: 0)
                ]
            }
            else
            {
                if isWaterPlanCreatedToday
                {
                    return []
                }
                else
                {
                    return [
                        .sectionTitle(icon: "water-icon", name: NSLocalizedString("Water", comment: ""), showInfoIcon: true),
                        .lockedCheckMarkCard(backgroundImage: "water-placeholder", subtext: NSLocalizedString("Get precise hydration recommendations", comment: ""))
                    ]
                }
            }
        }
        
        return [
            .sectionTitle(icon: "water-icon", name: "\(glassesNumber * 8) \(NSLocalizedString(" oz Water", comment: "Water amount"))", showInfoIcon: true),
            .waterDetails(glassesNumber: glassesNumber, checkedGlasses: checkedGlasses)
        ]
    }
    
    // MARK: - Equatable
    static func == (lhs: TodayViewSection, rhs: TodayViewSection) -> Bool
    {
        switch (lhs, rhs)
        {
        case (.header(let lhName, let lhGoals), .header(let rhName, let rhGoals)):
            return lhName == rhName && lhGoals == rhGoals
        case (.insights(let lhInsights, _), .insights(let rhInsights, _)):
            return lhInsights == rhInsights
        case (.food, .food):
            return true
        case (.water, .water):
            return true
        case (.footer, .footer):
            return true
        default:
            return false
        }
    }
}

enum TodayViewCell: Equatable
{
    case header(name: String, goals: [String])
    case progressDays(progress: [String: Double])
    case sectionTitle(icon: String, name: String, showInfoIcon: Bool)
    case foodDetails(food: [Food], selectedDate: String)
    case waterDetails(glassesNumber: Int, checkedGlasses: Int)
    case lockedCheckMarkCard(backgroundImage: String, subtext: String)
    case checkMarkCard(title: String, subtitle: String, description: String, backgroundImage: String, isCompleted: Bool, id: Int, type: CheckMarkCardType, remindersButtonState: Bool?, remindersButtonText: String?, longDescription: String?)
    case foldedCheckMarkCard(title: String, subtitle: String, backgroundImage: String)
    case text(text: String, alignment: NSTextAlignment)
    case loader
    case button(text: String)
    case footer
    
    var height: CGFloat
    {
        let progressDaysHeight: CGFloat
        switch UIScreen.main.getScreenWidth()
        {
        case .large:
            progressDaysHeight = 104.0
        case .mid:
            progressDaysHeight = 80.0
        case .small:
            progressDaysHeight = 74.0
        }
        switch self
        {
        case .header: return 177.0
        case .progressDays: return progressDaysHeight
        case .sectionTitle: return 56.0
        case .foodDetails(let food, _):
            let foodHeight: Int = Int(ceil(Double(food.count) / 2.0) * 56)
            let spacingHeight: Int = Int((ceil(Double(food.count) / 2.0) - 1) * 17)
            return CGFloat(foodHeight + spacingHeight + 32)
        case .waterDetails(let glassesNumber, _): return glassesNumber < 10 ? 61.0 : 130.0
        case .lockedCheckMarkCard: return 96.0
        case .checkMarkCard: return 219.0
        case .foldedCheckMarkCard: return 132.0
        case .text: return 38.0
        case .loader: return 38.0
        case .button: return 76.0
        case .footer: return 173.0
        }
    }
    
    var identifier: String
    {
        switch self
        {
        case .header: return "TodayHeaderCell"
        case .progressDays: return "TodayProgressDaysCell"
        case .sectionTitle: return "TodaySectionTitleCell"
        case .foodDetails: return "TodayFoodDetailsSectionCell"
        case .waterDetails: return "TodayWaterDetailsSectionCell"
        case .lockedCheckMarkCard: return "LockedCheckmarkCardCell"
        case .checkMarkCard: return "CheckmarkCardCell"
        case .foldedCheckMarkCard: return "FoldedCheckmarkCardCell"
        case .text: return "TodayTextCell"
        case .loader: return "TodayLoaderCell"
        case .button: return "TodayButtonCell"
        case .footer: return "TodayFooterCell"
        }
    }
}

class TodayViewModel
{
    @Resolved private var analytics: Analytics
    private var contact = Contact.main()!
    
    weak var resultsViewModel: ResultsTabViewModel?
    
    // Feature flags
    var showProgressDays: Bool = RemoteConfigManager.shared.getValue(for: .progressDaysFeature) as? Bool ?? false
    private var showInsights: Bool = RemoteConfigManager.shared.getValue(for: .insightsFeature) as? Bool ?? false
//    private var showActivites: Bool = RemoteConfigManager.shared.getValue(for: .activitiesFeature) as? Bool ?? false
    private var showActivites: Bool = true
    private var showFood: Bool = RemoteConfigManager.shared.getValue(for: .foodFeature) as? Bool ?? false
    private var showWater: Bool = RemoteConfigManager.shared.getValue(for: .waterFeature) as? Bool ?? false
    var showReminders: Bool = RemoteConfigManager.shared.getValue(for: .remindersFeature) as? Bool ?? false
    
    var selectedDate: String = Date.serverDateFormatter.string(from: Date())
    var lastWeekProgress: [String: Double] = PlansManager.shared.getLastWeekPlansProgress()
    var lastDayProgress: Double = PlansManager.shared.calculateProgressFor(date: Date.serverDateFormatter.string(from: Date()))
    
    var numberOfGlasses: Int?
    {
        WaterManager.shared.getDailyWaterIntake(date: selectedDate)
    }
    
    var drinkedWaterGlasses: Int
    {
        WaterManager.shared.getDrinkedWaterGlasses(date: selectedDate)
    }
    
    var isToday: Bool
    {
        return selectedDate == Date.serverDateFormatter.string(from: Date())
    }
    
    var sections: [TodayViewSection]
    {
        contact = Contact.main()!
        
        // PROGRESS DAYS
        let progressDays: [String: Double] = showProgressDays ? lastWeekProgress : [:]

        guard let createdDateString = contact.createdDate,
              let localCreatedDateString = Date.utcToLocal(dateStr: createdDateString),
              let shortLocalCreatedString = localCreatedDateString.removeISODateEndingToServerFormat(),
              (shortLocalCreatedString < selectedDate) || isToday else
        {
            return [.header(name: contact.first_name ?? "", goals: contact.getGoals()),
                    .progressDays(progress: progressDays),
                    .userNotYetCreated]
        }
        
        let todayDate = Date.serverDateFormatter.string(from: Date())
        // LESSONS
        let lessons = showInsights ? ( isToday ? LessonsManager.shared.todayLessons : LessonsManager.shared.getLessonsCompletedOn(dateString: selectedDate)) : []
//        print("lessons: \(lessons)")
        //ACTIVITIES
        let activityPlans = PlansManager.shared.getActivityPlans()
//        print("activityPlans: \(activityPlans)")
        let lifestyleRecommendationPlans = PlansManager.shared.getLifestyleRecommendationPlans()
//        print("lifestyleRecommendationPlans: \(lifestyleRecommendationPlans)")
//        print("showActivites: \(showActivites)")
//        print("PlansManager.shared.activities.: \(PlansManager.shared.activities)")
        var activityImageURL = "https://images.unsplash.com/photo-1481349518771-20055b2a7b24?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8cmFuZG9tfGVufDB8fDB8fHww&w=1000&q=80"
        var activities = [
            Tip(id: 1, last_updated: 1, title: "Meal Plan", description: "Research shows a well-crafted meal plan boosts nutrition, manages weight, and sustains energy", imageUrl: "https://s3.amazonaws.com/violetdemo.com/meal_plan_home.jpg", frequency: "Made just for you", isPlan: true, subtitle: "take a simple 3 minute quiz", longDescription: "Meal Plan:\n\nDay 1:\n\nLunch: Grilled Chicken Salad\n\nIngredients:\n2 chicken breasts\n2 cups mixed greens\n1 tomato\n1 cucumber\n1/4 cup feta cheese\n1/4 cup balsamic vinaigrette\nInstructions:\nGrill the chicken until no longer pink in the center.\nSlice the chicken and place it on top of the mixed greens.\nAdd sliced tomato and cucumber.\nSprinkle feta cheese on top.\nDrizzle with balsamic vinaigrette.\nSnack: Protein Shake\n\nIngredients:\n1 scoop protein powder\n1 cup almond milk\n1 banana\n1 tbsp peanut butter\nInstructions:\nBlend all ingredients until smooth.\nDinner: Salmon with Quinoa and Steamed Vegetables\n\nIngredients:\n1 salmon fillet\n1 cup quinoa\n2 cups mixed vegetables\nInstructions:\nCook the salmon until it flakes easily with a fork.\nCook the quinoa according to package instructions.\nSteam the vegetables until tender.\nServe the salmon with the quinoa and vegetables.\n...same for the rest of the week..."),
            Tip(id: 2, last_updated: 1, title: "Grocery Plan", description: "The healthy food you need to follow your food plan", imageUrl: "https://s3.amazonaws.com/violetdemo.com/grocery_plan_home.jpg", frequency: "Food for 7 days", isPlan: true, subtitle: "take a simple 3 minute quiz", longDescription: "Meat:\n\n14 chicken breasts (2 per day)\n7 salmon fillets (1 per day)\nVegetables:\n\n14 cups mixed greens (2 per day)\n7 tomatoes (1 per day)\n7 cucumbers (1 per day)\n14 cups mixed vegetables (2 per day)\nDairy:\n\n1.75 cups feta cheese (1/4 cup per day)\nGrains:\n\n7 cups quinoa (1 cup per day)\nProtein Powder:\n\n7 scoops protein powder (1 scoop per day)\nFruit:\n\n7 bananas (1 per day)\nNuts and Seeds:\n\n7 tbsp peanut butter (1 tbsp per day)\nCondiments:\n\n1.75 cups balsamic vinaigrette (1/4 cup per day)\nDrinks:\n\n7 cups almond milk (1 cup per day)"),
            Tip(id: 3, last_updated: 1, title: "Fitness Plan", description: "Scientific findings suggest a tailored fitness plan enhances strength, improves endurance, and boosts mood.", imageUrl: "https://s3.amazonaws.com/violetdemo.com/fitness_plan_home.jpg", frequency: "", isPlan: true, subtitle: "take a simple 3 minute quiz", longDescription: "• Day 1: Start with a warm-up of light jogging or brisk walking for 10 minutes. Then, move on to weight lifting - focus on compound movements like squats, bench press, and deadlifts. Aim for 3 sets of 8-12 reps for each. Take it slowly and focus on form. Finish with a cool down of stretching for 10 minutes.\n• Day 2: It's cardio day! Start with a 10-minute warm-up of jumping jacks or skipping rope. Then, go for a run - start with a pace you're comfortable with for 20-30 minutes. Try to push yourself a little harder each time. End with a cool down walk and stretching for 10 minutes.\n• Day 3: Rest day. But don't forget, rest doesn't mean doing nothing! Get some light activities like walking or stretching. It's a great time to use a foam roller for muscle recovery and to help reduce muscle soreness.\n• Day 4: Time for a full-body workout. Start with a 10-minute warm-up. Then, let's do some push-ups, pull-ups, lunges and planks. Aim for 3 sets of 10-15 reps for each. Remember, quality over quantity. Always maintain good form. Finish with a 10-minute full-body stretch.\n• Day 5: Cardio again! Let's mix it up with some interval training. Warm up for 10 minutes. Then, alternate between 2 minutes of intense running and 1 minute of walking for a total of 20 minutes. End with a cool down walk and stretching.\n• Day 6: Back to weight lifting. This time, let's focus on isolation exercises like bicep curls, tricep extensions, and leg curls. Go for 3 sets of 10-12 reps for each. And don't forget to stretch afterwards!\n• Day 7: Another rest day. Remember, your body needs this time to recover and build muscle. You might consider some light yoga or meditation to help reduce your stress levels."),
            Tip(id: 4, last_updated: 1, title: "Supplement Plan", description: "Personalized to you, toy help you feel your best", imageUrl: "https://s3.amazonaws.com/violetdemo.com/supplements.jpeg", frequency: "Your daily supplement routine", isPlan: true, subtitle: "take a simple 3 minute quiz", longDescription: "• Magnesium (Glycinate): 400 mg per day\n• Melatonin: 3 mg per day\n• L-Theanine: 200 mg per day\n• B6 as P-5-P: 25 mg per day\n• B12 as Methylcobalamin: 500 mcg per day\n• Sensoril Ashwagandha: 125 mg per day\n• Zinc Chelate: 15 mg per day")]
        let additionalAactivities = showActivites ? PlansManager.shared.activities.filter({ activity in
            return activityPlans.contains(where: { $0.typeId == activity.id }) && !activity.isLifestyleRecommendation
        }).sorted(by: { $0.id < $1.id }) : []
        activities.append(contentsOf: additionalAactivities)
        let lifestyleRecommendationsActivities = showActivites ? PlansManager.shared.activities.filter({ activity in
            return lifestyleRecommendationPlans.contains(where: { $0.typeId == activity.id }) && activity.isLifestyleRecommendation && activity.id != Constants.WATER_LIFESTYLE_RECOMMENDATION_ID
        }).sorted(by: { $0.id < $1.id }) : []
        
        // FOOD
        let food = showFood ? contact.suggestedFood : []
        
        // WATER
        let dailyWaterIntake = showWater ? numberOfGlasses : nil
        let isWaterPlanCreatedForSelectedDay = PlansManager.shared.getWaterPlan() != nil ? PlansManager.shared.getWaterPlan()!.createdDate <= selectedDate : false
        let isWaterPlanCreatedToday = PlansManager.shared.getWaterPlan() != nil ? PlansManager.shared.getWaterPlan()!.createdDate <= todayDate : false
        let lastSelectedGlassesNumberIndex = PlansManager.shared.getWaterPlan()?.completionInfo?.firstIndex(where: { $0.date >= selectedDate }) ?? 0 - 1
        let lastSelectedGlasesNumber = lastSelectedGlassesNumberIndex < 0 ? nil : PlansManager.shared.getWaterPlan()?.completionInfo?[safe: lastSelectedGlassesNumberIndex]?.dailyWaterIntake
        
        return [
            .header(name: contact.first_name ?? "", goals: contact.getGoals()),
            .progressDays(progress: progressDays),
            .insights(insights: lessons, isToday: self.isToday),
//            .activities(activities: [Tip(id: 100, last_updated: 100, title: "Activity test", description: "Desc test", imageUrl: "", frequency: "")], selectedDate: "", isToday: self.isToday),
//            .activities(activities: lifestyleRecommendationsActivities + activities, selectedDate: selectedDate, isToday: self.isToday),
            .activities(activities: activities, selectedDate: selectedDate, isToday: self.isToday),
            .food(food: food, selectedDate: selectedDate, userHasTakenATest: !(resultsViewModel?.isEmpty ?? true)),
            .water(glassesNumber: dailyWaterIntake, checkedGlasses: drinkedWaterGlasses, isWaterPlanCreatedForSelectedDay: isWaterPlanCreatedForSelectedDay, lastSelectedGlassesNumber: lastSelectedGlasesNumber, isWaterPlanCreatedToday: isWaterPlanCreatedToday),
            .footer
        ]
    }
    
    init()
    {
        if UserDefaults.standard.bool(forKey: Constants.KEY_PRINT_INIT_DEINIT)
        {
            print("❇️ \(self)")
        }
    }
    
    deinit
    {
        if UserDefaults.standard.bool(forKey: Constants.KEY_PRINT_INIT_DEINIT)
        {
            print("❌ \(self)")
        }
    }
    
    func updateCheckedGlasses(_ glasses: Int)
    {
        analytics.log(event: .waterComplete(waterAmount: glasses, totalWaterAmount: numberOfGlasses ?? 0))
        WaterManager.shared.setDrinkedWaterGlasses(value: glasses, date: selectedDate)
    }
    
    func refreshContactSuggestedFood()
    {
        contact.refreshSuggestedFood(selectedDate: selectedDate, isToday: isToday)
    }
    
    func refreshLastWeekProgress()
    {
        lastWeekProgress = PlansManager.shared.getLastWeekPlansProgress()
    }
}
