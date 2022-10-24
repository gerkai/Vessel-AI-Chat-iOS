//
//  TodayViewModel.swift
//  Vessel
//
//  Created by Nicolas Medina on 9/27/22.
//

import UIKit

enum TodayViewSection: Equatable
{
    case header(name: String, goals: String)
    //case days
    //case insights(insights: [Insight])
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
        case .food: return 1
        case .water: return 2
        case .footer: return 3
        }
    }
    
    var cells: [TodayViewCell]
    {
        switch self
        {
        case .header(let name, let goals): return [.header(name: name, goals: goals)]
        //case .insights(let insights): return createInsightsSection(insights: insights)
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
    
    func createInsightsSection(insights: [Insight]) -> [TodayViewCell]
    {
        var cells: [TodayViewCell] = [.sectionTitle(icon: "todayInsightsIcon", name: "Insights")]
        for insight in insights
        {
            cells.append(.checkMarkCard(title: insight.title, subtitle: insight.subtitle, description: insight.description, backgroundImage: insight.backgroundImage, completed: insight.completedDate != nil))
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
        /*case (.insights(let lhInsights), .insights(let rhInsights)):
            return lhInsights == rhInsights*/
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
    case header(name: String, goals: String)
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
        case .sectionTitle: return 16.0
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
    private var contact = Contact.main()
    private var insights: [Insight]
    {
        return [Insight(id: 0, lastUpdated: 0, title: "How Yoga Improves Sleep", subtitle: "Mood and Sleep (2 mins)", description: "Legumes have been proven in various studies to reduce your cortisol levels and improve... more", backgroundImage: "yogaImprovesSleep", completedDate: nil)]
    }
    var results: [Result]!
    
    init()
    {
        results = Storage.retrieve(as: Result.self)
    }
    
    func refresh()
    {
        results = Storage.retrieve(as: Result.self)
    }
    
    var isEmpty: Bool { results.isEmpty }
    
    var numberOfGlasses: Int?
    {
        contact?.dailyWaterIntake
    }
    
    var drinkedWaterGlasses: Int?
    {
        contact?.drinkedWaterGlasses
    }
    
    var sections: [TodayViewSection] {
        return [
            .header(name: contact?.first_name ?? "", goals: contact?.getGoalsListedString() ?? ""),
            //.insights(insights: insights),
            .food(foods: contact?.suggestedFoods ?? []),
            .water(glassesNumber: contact?.dailyWaterIntake ?? Constants.MINIMUM_WATER_INTAKE, checkedGlasses: contact?.drinkedWaterGlasses ?? 0),
            .footer
        ]
    }
    
    func updateCheckedGlasses(_ glasses: Int)
    {
        contact?.drinkedWaterGlasses = glasses
        guard let contact = contact else { return }
        ObjectStore.shared.ClientSave(contact)
    }
}
