//
//  TodayViewModel.swift
//  Vessel
//
//  Created by Nicolas Medina on 9/27/22.
//

import UIKit

enum TodayViewSection: Equatable
{
    case header(name: String, goals: [String])
    //case days
    case insights(insights: [Lesson])
    //case activities
    case food(foods: [Food])
    case water(glassesNumber: Int, checkedGlasses: Int)
    //case customize
    case footer
    
    var sectionIndex: Int
    {
        switch self
        {
        case .header: return 0
        case .insights: return 1
        case .food: return 2
        case .water: return 3
        case .footer: return 4
        }
    }
    
    var cells: [TodayViewCell]
    {
        switch self
        {
        case .header(let name, let goals): return [.header(name: name, goals: goals)]
        case .insights(let lessons): return createInsightsSection(lessons: lessons)
        case .food(let foods):
            if foods.count > 0
            {
                return [
                    .sectionTitle(icon: "food-icon", name: "Food"),
                    .foodDetails(foods: foods)
                ]
            }
            else
            {
                return []
            }
        case .water(let glassesNumber, let checkedGlasses): return [
            .sectionTitle(icon: "water-icon", name: NSLocalizedString("\(glassesNumber * 8) oz Water", comment: "Water amount")),
            .waterDetails(glassesNumber: glassesNumber, checkedGlasses: checkedGlasses)
        ]
        case .footer: return [.footer]
        }
    }
    
    func createInsightsSection(lessons: [Lesson]) -> [TodayViewCell]
    {
        guard lessons.count > 0 else { return [] }
        var cells: [TodayViewCell] = [.sectionTitle(icon: "todayInsightsIcon", name: "Insights")]
        for lesson in lessons
        {
            cells.append(.checkMarkCard(title: lesson.title,
                                        subtitle: "",
                                        description: lesson.description ?? "",
                                        backgroundImage: lesson.imageUrl ?? "",
                                        completed: lesson.completedDate != nil))
        }
        return cells
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
    case checkMarkCard(title: String, subtitle: String, description: String, backgroundImage: String, completed: Bool)
    case footer
    
    var height: CGFloat
    {
        switch self
        {
        case .header: return 177.0
        case .sectionTitle: return 32.0
        case .foodDetails(let foods):
            let foodHeight: Int = Int(ceil(Double(foods.count) / 2.0) * 56)
            let spacingHeight: Int = Int((ceil(Double(foods.count) / 2.0) - 1) * 17)
            return CGFloat(foodHeight + spacingHeight + 32)
        case .waterDetails(let glassesNumber, _): return glassesNumber < 10 ? 61.0 : 130.0
        case .checkMarkCard: return 203.0
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
        case .footer: return "TodayFooterCell"
        }
    }
}

class TodayViewModel
{
    private var contact = Contact.main()!
    
    // Feature flags
    var showInsights: Bool = RemoteConfigManager.shared.getValue(for: .insightsFeature) as? Bool ?? false
    
    var numberOfGlasses: Int?
    {
        contact.dailyWaterIntake
    }
    
    var drinkedWaterGlasses: Int?
    {
        contact.drinkedWaterGlasses
    }
    
    var sections: [TodayViewSection] {
        contact = Contact.main()!
        let firstLesson = LessonsManager.shared.lessons.first
        let lessons = showInsights && firstLesson != nil ? [firstLesson!] : []
        return [
            .header(name: contact.first_name ?? "", goals: contact.getGoals()),
            .insights(insights: lessons),
            .food(foods: contact.suggestedFoods),
            .water(glassesNumber: contact.dailyWaterIntake ?? Constants.MINIMUM_WATER_INTAKE, checkedGlasses: contact.drinkedWaterGlasses ?? 0),
            .footer
        ]
    }
    
    func updateCheckedGlasses(_ glasses: Int)
    {
        contact.drinkedWaterGlasses = glasses
        ObjectStore.shared.ClientSave(contact)
    }
    
    func refreshContactSuggestedfoods()
    {
        contact.refreshSuggestedFoods()
    }
}
