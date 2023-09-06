//
//  RemindersManager.swift
//  Vessel
//
//  Created by Nicolas Medina on 2/3/23.
//

import UIKit

class RemindersManager
{
    static let shared = RemindersManager()
    var reminders = Storage.retrieve(as: Reminder.self)
        
    func reloadReminders()
    {
        reminders = Storage.retrieve(as: Reminder.self)
    }
    
    func getRemindersForPlan(planId: Int) -> [Reminder]
    {
        return reminders.filter({ $0.planId == planId })
    }
    
    func setupRemindersIfNeeded()
    {
        let center = UNUserNotificationCenter.current()

        for reminder in reminders
        {
            guard let plan = PlansManager.shared.plans.first(where: { $0.id == reminder.planId }) else { continue }
            
            let content = UNMutableNotificationContent()
            
            switch plan.type
            {
            case .activity:
                guard let tip = PlansManager.shared.activities.first(where: { $0.isLifestyleRecommendation == false && $0.id == plan.typeId }) else { continue }
                content.title = String(format: NSLocalizedString("%@.", comment: ""), tip.title)
                content.body = String(format: NSLocalizedString("Remember to %@ now!", comment: "Instructions when to do activity"), tip.title.lowercased())
            case .reagentLifestyleRecommendation:
                guard let tip = PlansManager.shared.activities.first(where: { $0.isLifestyleRecommendation == true && $0.id == plan.typeId }) else { continue }
                content.title = String(format: NSLocalizedString("%@.", comment: ""), tip.title)
                content.body = String(format: NSLocalizedString("Remember to %@ now!", comment: "Instructions when to do lifestyle recommendation"), tip.title.lowercased())
            case .food:
                guard let food = Contact.main()?.suggestedFood.first(where: { $0.id == plan.typeId }) else { continue }
                content.title = String(format: NSLocalizedString("Eat %@.", comment: ""), food.title.lowercased())
                content.body = String(format: NSLocalizedString("Remember to eat %@ today!", comment: "Instructions when to eat food"), food.title.lowercased())
            }
                        
            let timeOfDay = getTimeOfDay(from: reminder.timeOfDay)
            let hour = timeOfDay.hour
            let minute = timeOfDay.minute
            
            for day in reminder.dayOfWeek
            {
                let adjustedDay = (day + 6) % 7 + 1
                let dateComponents = DateComponents(hour: hour, minute: minute, weekday: adjustedDay)
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                
                let identifier = "\(reminder.id)+\(day)"
                center.getPendingNotificationRequests { (requests) in
                    let existingRequests = requests.filter({ $0.identifier == identifier })
                    if existingRequests.isEmpty
                    {
                        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                        center.add(request) { (error) in
                            if let error = error
                            {
                                print("Error scheduling notification: \(error.localizedDescription)")
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getNextReminderTime(forPlan planId: Int?) -> String?
    {
        guard let planId = planId else { return nil }
        
        let calendar = Calendar.current
        let currentDate = Date()
        var currentWeekday = calendar.component(.weekday, from: currentDate) - 1 // Adjust for Monday being 0 and Sunday being 7
        if currentWeekday == -1
        {
            currentWeekday = 7
        }
        let currentTime = calendar.component(.hour, from: currentDate) * 60 + calendar.component(.minute, from: currentDate)
        
        let schedules = getReminderSchedules(forPlanId: planId)
        
        for schedule in schedules
        {
            if let index = Constants.DAYS_OF_THE_WEEK.firstIndex(of: schedule.day),
               index > currentWeekday
            {
                let reminderTimeComponents = schedule.time.split(separator: ":")
                if reminderTimeComponents.count == 2,
                   let reminderHour = Int(reminderTimeComponents[0]),
                   let reminderMinute = Int(reminderTimeComponents[1])
                {
                    let reminderTime = reminderHour * 60 + reminderMinute
                    if reminderTime > currentTime
                    {
                        return schedule.time
                    }
                }
            }
        }
        
        return schedules.first?.time
    }
    
    func getTimeOfDay(from string: String) -> (hour: Int, minute: Int)
    {
        switch string
        {
        case NSLocalizedString("Morning", comment: ""):
            return (8, 0)
        case NSLocalizedString("Daytime", comment: ""):
            return (12, 0)
        case NSLocalizedString("Evening", comment: ""):
            return (19, 0)
        default:
            let components = string.split(separator: ":")
            guard components.count == 2, let hour = Int(components[0]), let minute = Int(components[1]) else
            {
                return (0, 0)
            }
            return (hour, minute)
        }
    }
    
    func getReminderSchedules(forPlanId id: Int) -> [(day: String, time: String)]
    {
        reloadReminders()
        let reminders = getRemindersForPlan(planId: id)
        var schedules = [(day: String, time: String)]()
        for reminder in reminders
        {
            schedules.append(contentsOf: reminder.dayOfWeek.map { (day: Constants.DAYS_OF_THE_WEEK[$0], reminder.timeOfDay) })
        }
        return schedules.sorted(by:
                                    {
            guard let firstDayIndex = Constants.DAYS_OF_THE_WEEK.firstIndex(of: $0.day),
                  let secondDayIndex = Constants.DAYS_OF_THE_WEEK.firstIndex(of: $1.day) else { return false }
            if let firstTimeIndex = Constants.REMINDERS_DEFAULT_TIMES.firstIndex(of: $0.time),
               let secondTimeindex = Constants.REMINDERS_DEFAULT_TIMES.firstIndex(of: $1.time)
            {
                return  firstDayIndex == secondDayIndex ? firstTimeIndex < secondTimeindex : firstDayIndex < secondDayIndex
            }
            else if let _ = Constants.REMINDERS_DEFAULT_TIMES.firstIndex(of: $1.time)
            {
                return  firstDayIndex == secondDayIndex ? true : firstDayIndex < secondDayIndex
            }
            else if let _ = Constants.REMINDERS_DEFAULT_TIMES.firstIndex(of: $1.time)
            {
                return  firstDayIndex == secondDayIndex ? false : firstDayIndex < secondDayIndex
            }
            else
            {
                return  firstDayIndex == secondDayIndex ? $0.time < $1.time : firstDayIndex < secondDayIndex
            }
        })
    }
    
    func setupActivityReminders(activities: [Tip])
    {
        let dayOfWeek = Date().dayNumberOfWeek()!
        let reminders = RemindersManager.shared.reminders
        
        // Arrange reminders to every activity
        activities.forEach({ activity in
            reminders.forEach({ reminder in
                if reminder.planId == activity.id
                {
                    activity.reminders.append(reminder)
                }
            })
        })
        
        // Select closest reminder for activity
        activities.forEach({ activity in
            activity.closestReminder = activity.reminders.first(where: { reminder in
                if let first = reminder.dayOfWeek.first(where: { $0 >= dayOfWeek })
                {
                    return first >= dayOfWeek
                }
                return false
            })
        })
        
        // Sort activitires by closest reminder
        var sortedActivities = [Tip]()
        activities.forEach({ activity in
            if let reminder = activity.closestReminder
            {
                if reminder.dayOfWeek.contains(where: { $0 == dayOfWeek })
                {
                    sortedActivities.insert(activity, at: 0)
                }
                else
                {
                    sortedActivities.append(activity)
                }
            }
            else
            {
                sortedActivities.append(activity)
            }
        })
        
        PlansManager.shared.activities = sortedActivities
    }
}
