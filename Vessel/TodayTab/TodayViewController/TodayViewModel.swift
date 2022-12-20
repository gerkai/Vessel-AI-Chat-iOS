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
    //case days
    case insights(insights: [Lesson])
    case activities(activities: [Tip])
    case food(foods: [Food])
    case water(glassesNumber: Int?, checkedGlasses: Int)
    //case customize
    case footer
    
    var sectionIndex: Int
    {
        switch self
        {
        case .header: return 0
        case .insights: return 1
        case .activities: return 2
        case .food: return 3
        case .water: return 4
        case .footer: return 5
        }
    }
    
    var cells: [TodayViewCell]
    {
        switch self
        {
        case .header(let name, let goals): return [.header(name: name, goals: goals)]
        case .insights(let lessons): return createInsightsSection(lessons: lessons)
        case .activities(let activities): return createActivitiesSection(activities: activities)
        case .food(let foods): return createFoodSection(foods: foods)
        case .water(let glassesNumber, let checkedGlasses): return createWaterSection(glassesNumber: glassesNumber, checkedGlasses: checkedGlasses)
        case .footer: return [.footer]
        }
    }
    
    func createInsightsSection(lessons: [Lesson]) -> [TodayViewCell]
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
        return cells
    }
    
    func createActivitiesSection(activities: [Tip]) -> [TodayViewCell]
    {
        guard activities.count > 0 else { return [] }
        var cells: [TodayViewCell] = [.sectionTitle(icon: "activities-icon", name: "Activities")]
        for activity in activities
        {
            let plan = PlansManager.shared.getActivities().first(where: { $0.typeId == activity.id })
            if (plan?.completed ?? []).contains(Date.serverDateFormatter.string(from: Date()))
            {
                cells.append(.foldedCheckMarkCard(title: activity.title,
                                                  subtitle: "",
                                                  backgroundImage: activity.imageUrl))
            }
            else
            {
                cells.append(.checkMarkCard(title: activity.title,
                                            subtitle: activity.frequency,
                                            description: activity.description,
                                            backgroundImage: activity.imageUrl,
                                            isCompleted: plan?.isComplete ?? false,
                                            id: activity.id,
                                            type: .activity))
            }
        }
        return cells
    }
    
    func createFoodSection(foods: [Food]) -> [TodayViewCell]
    {
        guard foods.count > 0 else { return [] }
        return [
            .sectionTitle(icon: "food-icon", name: "Food"),
            .foodDetails(foods: foods)
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
        case (.insights(let lhInsights), .insights(let rhInsights)):
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
    case sectionTitle(icon: String, name: String)
    case foodDetails(foods: [Food])
    case waterDetails(glassesNumber: Int, checkedGlasses: Int)
    case checkMarkCard(title: String, subtitle: String, description: String, backgroundImage: String, isCompleted: Bool, id: Int, type: CheckMarkCardType)
    case foldedCheckMarkCard(title: String, subtitle: String, backgroundImage: String)
    case text(text: String)
    case button(text: String)
    case footer
    
    var height: CGFloat
    {
        switch self
        {
        case .header: return 177.0
        case .sectionTitle: return 56.0
        case .foodDetails(let foods):
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
    var showInsights: Bool = RemoteConfigManager.shared.getValue(for: .insightsFeature) as? Bool ?? false
    var showActivites: Bool = RemoteConfigManager.shared.getValue(for: .activitiesFeature) as? Bool ?? false
    var showFoods: Bool = RemoteConfigManager.shared.getValue(for: .foodFeature) as? Bool ?? false
    var showWater: Bool = RemoteConfigManager.shared.getValue(for: .waterFeature) as? Bool ?? false
    
    var numberOfGlasses: Int?
    {
        contact.dailyWaterIntake
    }
    
    var drinkedWaterGlasses: Int?
    {
        WaterManager.shared.drinkedWaterGlasses
    }
    
    var sections: [TodayViewSection] {
        contact = Contact.main()!
        let lessons = showInsights ? LessonsManager.shared.todayLessons : []
        let plans = PlansManager.shared.getActivities()
        let activities = showActivites ? PlansManager.shared.activities.filter({ activity in
            return plans.contains(where: { $0.typeId == activity.id })
        }) : []
        let foods = showFoods ? contact.suggestedFoods : []
        let dailyWaterIntake = showWater ? contact.dailyWaterIntake : nil
        
        return [
            .header(name: contact.first_name ?? "", goals: contact.getGoals()),
            .insights(insights: lessons),
            .activities(activities: activities),
            .food(foods: foods),
            .water(glassesNumber: dailyWaterIntake, checkedGlasses: WaterManager.shared.drinkedWaterGlasses),
            .footer
        ]
    }
    
    func updateCheckedGlasses(_ glasses: Int)
    {
        analytics.log(event: .waterComplete(waterAmount: glasses, totalWaterAmount: contact.dailyWaterIntake ?? 0))
        WaterManager.shared.drinkedWaterGlasses = glasses
        ObjectStore.shared.ClientSave(contact)
    }
    
    func refreshContactSuggestedfoods()
    {
        contact.refreshSuggestedFoods()
    }
}
