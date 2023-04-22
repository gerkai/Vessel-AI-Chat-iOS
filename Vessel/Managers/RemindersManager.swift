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
            let content = UNMutableNotificationContent()
            content.title = "\(NSLocalizedString("Plan", comment: "")) \(reminder.planId)"
            content.body = String(format: NSLocalizedString("Take %i at %@", comment: "instructions when to take capsules"), reminder.quantity, reminder.timeOfDay)
            
            let timeOfDay = getTimeOfDay(from: reminder.timeOfDay)
            let hour = timeOfDay.hour
            let minute = timeOfDay.minute
            
            for day in reminder.dayOfWeek
            {
                let adjustedDay = (day + 6) % 7 + 1
                let dateComponents = DateComponents(hour: hour, minute: minute, weekday: adjustedDay)
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                
                let identifier = "\(reminder.id)"
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
            guard components.count == 3, let hour = Int(components[0]), let minute = Int(components[1]) else
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
}
