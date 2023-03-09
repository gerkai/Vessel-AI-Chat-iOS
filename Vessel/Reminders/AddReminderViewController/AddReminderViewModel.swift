//
//  AddRemindersViewModel.swift
//  Vessel
//
//  Created by Nicolas Medina on 2/2/23.
//

import Foundation

class AddReminderViewModel
{
    @Resolved private var analytics: Analytics
    var planId: Int
    private let food: Food?
    private let activity: Tip?
    private let lifestyleRecommendation: LifestyleRecommendation?
    lazy var reminder = Reminder(planId: planId)
    var temporarySelectedExactTime: String?
        
    var imageUrl: String?
    {
        return food?.imageUrl ?? activity?.imageUrl ?? lifestyleRecommendation?.imageURL
    }
    
    var title: String?
    {
        return food?.title ?? activity?.title ?? lifestyleRecommendation?.title
    }
    
    var subtitle: String?
    {
        return food?.servingUnit ?? activity?.frequency ?? lifestyleRecommendation?.subtext
    }
    
    var shouldShowHowMuchSection: Bool
    {
        return food != nil
    }
    
    var selection: [Bool]
    {
        return Array(0...7).map { value in
            return self.reminder.dayOfWeek.contains(where: { $0 == value })
        }
    }
    
    var selectedWeekdays: String
    {
        guard !reminder.dayOfWeek.isEmpty else
        {
            return NSLocalizedString("None selected", comment: "")
        }
        return reminder.dayOfWeek.sorted(by: { $0 < $1 }).map({ self.getWeekday(for: $0) }).joined(separator: ", ")
    }
    
    var hasSelecteedWeekdays: Bool
    {
        return !reminder.dayOfWeek.isEmpty
    }
    
    var selectedTime: String
    {
        return reminder.timeOfDay.convertTo12HourFormat()
    }
    
    var quantityText: String
    {
        return "\(reminder.quantity) \(food?.servingUnit ?? "") / \(NSLocalizedString("day", comment: ""))"
    }
    
    var shouldShowExactTime: Bool
    {
        return !reminder.timeOfDay.isEmpty && !Constants.REMINDERS_DEFAULT_TIMES.contains(reminder.timeOfDay)
    }
    
    var typeId: Int?
    {
        return food?.id ?? activity?.id ?? lifestyleRecommendation?.id
    }
    
    var type: PlanType?
    {
        return food != nil ? .food : activity != nil ? .activity : lifestyleRecommendation != nil ? .lifestyleRecommendation : nil
    }
    
    init(planId: Int, food: Food? = nil, activity: Tip? = nil, lifestyleRecommendation: LifestyleRecommendation? = nil)
    {
        self.planId = planId
        self.food = food
        self.activity = activity
        self.lifestyleRecommendation = lifestyleRecommendation
    }
    
    func toggleDayOfWeek(_ day: Int)
    {
        if let index = reminder.dayOfWeek.firstIndex(of: day)
        {
            reminder.dayOfWeek.remove(at: index)
        }
        else
        {
            reminder.dayOfWeek.append(day)
        }
    }
    
    func selectTime(time: String)
    {
        reminder.timeOfDay = time.convertTo24HourFormat()
    }
    
    func increaseQuantity()
    {
        reminder.quantity += 1
    }
    
    func decreaseQuantity()
    {
        reminder.quantity = max(1, reminder.quantity - 1)
    }
    
    func decreaseButtonIsHidden() -> Bool
    {
        return reminder.quantity == 1
    }
    
    func saveReminder()
    {
        ObjectStore.shared.clientSave(reminder)
        RemindersManager.shared.reloadReminders()

        if let typeId = typeId, let type = type
        {
            analytics.log(event: .reminderAdded(planId: reminder.id, typeId: typeId, planType: type, howMuch: shouldShowHowMuchSection ? quantityText : nil, whatTime: selectedTime, daysOfTheWeek: selectedWeekdays))
        }
    }
    
    private func getWeekday(for number: Int) -> String
    {
        let index = number % 7
        return Constants.ABBREVIATED_WEEK_DAYS[index]
    }
}

