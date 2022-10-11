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
    case food
    case water
    //case customize
    case footer
    
    var cells: [TodayViewCell]
    {
        switch self
        {
        case .header(let name, let goals): return [.header(name: name, goals: goals)]
        //case .insights(let insights): return createInsightsSection(insights: insights)
        case .food: return [.sectionTitle(icon: "food-icon", name: "Food")]
        case .water: return [.sectionTitle(icon: "water-icon", name: "64 oz Water")]
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
    case checkMarkCard(title: String, subtitle: String, description: String, backgroundImage: String, completed: Bool)
    case footer
    
    var height: CGFloat
    {
        switch self
        {
        case .header: return 177.0
        case .sectionTitle: return 30.0
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
    
    var isEmpty: Bool = false
    
    lazy var sections: [TodayViewSection] =
    [
        .header(name: contact?.first_name ?? "", goals: contact?.getGoalsListedString() ?? ""),
        //.insights(insights: insights),
        .food,
        .water,
        .footer
    ]
}
