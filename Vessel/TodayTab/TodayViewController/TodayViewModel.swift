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
}

enum TodayViewSection: Equatable
{
    case header(name: String, goals: [String])
    case progressDays(progress: [String: Double])
    case insights(insights: [Lesson], isToday: Bool)
    case activities(activities: [Tip], selectedDate: String)
    case food(foods: [Food], selectedDate: String)
    case water(glassesNumber: Int?, checkedGlasses: Int)
    //case customize
    case footer
    
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
        }
    }
    
    var cells: [TodayViewCell]
    {
        switch self
        {
        case .header(let name, let goals): return [.header(name: name, goals: goals)]
        case .progressDays(let progress): return createProgressDaySection(progress: progress)
        case .insights(let lessons, let isToday): return createInsightsSection(lessons: lessons, isToday: isToday)
        case .activities(let activities, let selectedDate): return createActivitiesSection(activities: activities, selectedDate: selectedDate)
        case .food(let foods, let selectedDate): return createFoodSection(foods: foods, selectedDate: selectedDate)
        case .water(let glassesNumber, let checkedGlasses): return createWaterSection(glassesNumber: glassesNumber, checkedGlasses: checkedGlasses)
        case .footer: return [.footer]
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
        guard lessons.count > 0 else { return [] }
        var cells: [TodayViewCell] = [.sectionTitle(icon: "todayInsightsIcon", name: "Insights")]
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
                                            type: .lesson))
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
                        cells.append(.text(text: NSLocalizedString("Today's insight is done!", comment: "")))
                    }
                    if lesson == lessons.last && LessonsManager.shared.nextLesson != nil
                    {
                        if lessons.count == 4
                        {
                            cells.append(.text(text: NSLocalizedString("Come back tomorrow for more insights", comment: "")))
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
    
    func createActivitiesSection(activities: [Tip], selectedDate: String) -> [TodayViewCell]
    {
        guard activities.count > 0 else { return [] }
        var cells: [TodayViewCell] = [.sectionTitle(icon: "activities-icon", name: "Activities")]
        for activity in activities
        {
            let plan = PlansManager.shared.getActivities().first(where: { $0.typeId == activity.id })
            if (plan?.completed ?? []).contains(selectedDate)
            {
                cells.append(.foldedCheckMarkCard(title: activity.title,
                                                  subtitle: "",
                                                  backgroundImage: activity.imageUrl))
            }
            else
            {
                cells.append(.checkMarkCard(title: activity.title,
                                            subtitle: activity.frequency,
                                            description: activity.description ?? "",
                                            backgroundImage: activity.imageUrl,
                                            isCompleted: false,
                                            id: activity.id,
                                            type: .activity))
            }
        }
        return cells
    }
    
    func createFoodSection(foods: [Food], selectedDate: String) -> [TodayViewCell]
    {
        guard foods.count > 0 else { return [] }
        return [
            .sectionTitle(icon: "food-icon", name: "Food"),
            .foodDetails(foods: foods, selectedDate: selectedDate)
        ]
    }
    
    func createWaterSection(glassesNumber: Int?, checkedGlasses: Int) -> [TodayViewCell]
    {
        guard let glassesNumber = glassesNumber else { return [] }
        return [
            .sectionTitle(icon: "water-icon", name: "\(glassesNumber * 8) \(NSLocalizedString(" oz Water", comment: "Water amount"))"),
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
    case sectionTitle(icon: String, name: String)
    case foodDetails(foods: [Food], selectedDate: String)
    case waterDetails(glassesNumber: Int, checkedGlasses: Int)
    case checkMarkCard(title: String, subtitle: String, description: String, backgroundImage: String, isCompleted: Bool, id: Int, type: CheckMarkCardType)
    case foldedCheckMarkCard(title: String, subtitle: String, backgroundImage: String)
    case text(text: String)
    case button(text: String)
    case footer
    
    var height: CGFloat
    {
        let progressDaysHeight: CGFloat
        switch UIScreen.main.getScreenSize()
        {
        case .large:
            progressDaysHeight = 49.0
        case .mid:
            progressDaysHeight = 40.0
        case .small:
            progressDaysHeight = 38.0
        }
        switch self
        {
        case .header: return 177.0
        case .progressDays: return progressDaysHeight
        case .sectionTitle: return 56.0
        case .foodDetails(let foods, _):
            let foodHeight: Int = Int(ceil(Double(foods.count) / 2.0) * 56)
            let spacingHeight: Int = Int((ceil(Double(foods.count) / 2.0) - 1) * 17)
            return CGFloat(foodHeight + spacingHeight + 32)
        case .waterDetails(let glassesNumber, _): return glassesNumber < 10 ? 61.0 : 130.0
        case .checkMarkCard: return 203.0
        case .foldedCheckMarkCard: return 112.0
        case .text: return 22.0
        case .button: return 60.0
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
        case .checkMarkCard: return "CheckmarkCardCell"
        case .foldedCheckMarkCard: return "FoldedCheckmarkCardCell"
        case .text: return "TodayTextCell"
        case .button: return "TodayButtonCell"
        case .footer: return "TodayFooterCell"
        }
    }
}

class TodayViewModel
{
    @Resolved private var analytics: Analytics
    private var contact = Contact.main()!
    
    // Feature flags

    private var showProgressDays: Bool = RemoteConfigManager.shared.getValue(for: .progressDaysFeature) as? Bool ?? false
    private var showInsights: Bool = RemoteConfigManager.shared.getValue(for: .insightsFeature) as? Bool ?? false
    private var showActivites: Bool = RemoteConfigManager.shared.getValue(for: .activitiesFeature) as? Bool ?? false
    private var showFoods: Bool = RemoteConfigManager.shared.getValue(for: .foodFeature) as? Bool ?? false
    private var showWater: Bool = RemoteConfigManager.shared.getValue(for: .waterFeature) as? Bool ?? false
    
    var selectedDate: String = Date.serverDateFormatter.string(from: Date())
    
    var numberOfGlasses: Int?
    {
        contact.dailyWaterIntake
    }
    
    var drinkedWaterGlasses: Int
    {
        WaterManager.shared.getDrinkedWaterGlasses(date: selectedDate)
    }
    
    var isToday: Bool
    {
        return selectedDate == Date.serverDateFormatter.string(from: Date())
    }
    
    var sections: [TodayViewSection] {
        contact = Contact.main()!
        let progressDays: [String: Double] = showProgressDays ? PlansManager.shared.getLastWeekPlansProgress() : [:]
        let lessons = showInsights ? ( isToday ? LessonsManager.shared.todayLessons : LessonsManager.shared.getLessonsCompletedOn(dateString: selectedDate)) : []
        let plans = PlansManager.shared.getActivities()
        let activities = showActivites ? PlansManager.shared.activities.filter({ activity in
            return plans.contains(where: { $0.typeId == activity.id })
        }) : []
        let foods = showFoods ? contact.suggestedFoods : []
        let dailyWaterIntake = showWater ? contact.dailyWaterIntake : nil
        
        return [
            .header(name: contact.first_name ?? "", goals: contact.getGoals()),
            .progressDays(progress: progressDays),
            .insights(insights: lessons, isToday: self.isToday),
            .activities(activities: activities, selectedDate: selectedDate),
            .food(foods: foods, selectedDate: selectedDate),
            .water(glassesNumber: dailyWaterIntake, checkedGlasses: drinkedWaterGlasses),
            .footer
        ]
    }
    
    func updateCheckedGlasses(_ glasses: Int)
    {
        analytics.log(event: .waterComplete(waterAmount: glasses, totalWaterAmount: contact.dailyWaterIntake ?? 0))
        WaterManager.shared.setDrinkedWaterGlasses(value: glasses, date: selectedDate)
    }
    
    func refreshContactSuggestedfoods()
    {
        contact.refreshSuggestedFoods()
    }
}
