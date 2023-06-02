//
//  DashboardViewModel.swift
//  Vessel
//
//  Created by Nicolas Medina on 5/23/23.
//

import UIKit

class DashboardViewModel
{    
    var leaderboard: LeaderboardResponse?
    var ranking: [Staff]
    {
        leaderboard?.ranking.sorted(by: {
            if $0.sales == $1.sales
            {
                return  $0.first_name ?? "" < $1.first_name ?? ""
            }
            else
            {
                return $0.sales ?? 0 < $1.sales ?? 0
            }
        }) ?? []
    }
    let expertId: Int
    let reloadUI: () -> Void
    private var startDate: Date?
    private var endDate: Date?
    
    init(expertId: Int, reloadUI: @escaping () -> Void)
    {
        self.expertId = expertId
        self.reloadUI = reloadUI
        
        loadLeaderboard()
    }
    
    func setDates(startDate: Date?, endDate: Date?)
    {
        self.startDate = startDate
        self.endDate = endDate
    }
    
    let pickerOptions = [
        NSLocalizedString("This Month", comment: ""),
        NSLocalizedString("Last Month", comment: ""),
        NSLocalizedString("This Week", comment: ""),
        NSLocalizedString("Last Week", comment: ""),
        NSLocalizedString("Custom", comment: ""),
    ]
    var selectedPickerOptionIndex = 0
    var selectedPickerOption: String
    {
        if selectedPickerOptionIndex == 4
        {
            return datesString()
        }
        else
        {
            return pickerOptions[selectedPickerOptionIndex].lowercased()
        }
    }
    
    func datesString() -> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.VERBOSE_FORMAT
        guard let startDate = startDate, let endDate = endDate else { return "custom" }
        return "\(formatter.string(from: startDate)) - \(formatter.string(from: endDate))"
    }
    
    func loadLeaderboard()
    {
        let dates = getPeriodDates()
        Server.shared.getLeaderboard(expertId: expertId, startDate: dates?.startDate, endDate: dates?.endDate) { leaderboard in
            self.leaderboard = leaderboard
            self.reloadUI()
        } onFailure: { message in
            print("Error loading dashboard: \(message!)")
        }
    }
    
    func getPeriodDates() -> (startDate: String, endDate: String)?
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        var startDate: Date?
        var endDate: Date?
        
        let currentDate = Date()
        let calendar = Calendar.current
        
        switch selectedPickerOptionIndex
        {
        case 0:
            startDate = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate))
            endDate = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startDate!)
            self.startDate = nil
            self.endDate = nil
        case 1:
            startDate = calendar.date(byAdding: DateComponents(month: -1), to: calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate))!)
            endDate = calendar.date(byAdding: DateComponents(day: -1), to: calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate))!)
            self.startDate = nil
            self.endDate = nil
        case 2:
            startDate = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentDate))
            endDate = calendar.date(byAdding: DateComponents(day: 6), to: startDate!)
            self.startDate = nil
            self.endDate = nil
        case 3:
            startDate = calendar.date(byAdding: DateComponents(weekOfYear: -1), to: calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentDate))!)
            endDate = calendar.date(byAdding: DateComponents(day: -1), to: calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentDate))!)
            self.startDate = nil
            self.endDate = nil
        case 4:
            startDate = self.startDate
            endDate = self.endDate
        default:
            return nil
        }
        
        guard let start = startDate, let end = endDate else
        {
            return nil
        }
        
        let startDateString = dateFormatter.string(from: start)
        let endDateString = dateFormatter.string(from: end)
        
        return (startDate: startDateString, endDate: endDateString)
    }
}
