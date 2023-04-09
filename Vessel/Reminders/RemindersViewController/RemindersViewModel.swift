//
//  RemindersViewModel.swift
//  Vessel
//
//  Created by Nicolas Medina on 2/3/23.
//

import Foundation

class RemindersViewModel
{
    var planId: Int
    let food: Food?
    let activity: Tip?
    let lifestyleRecommendation: LifestyleRecommendation?
    var reminders: [Reminder]
    var reminderToRemove: Int?
    
    var imageUrl: String?
    {
        return food?.imageUrl ?? activity?.imageUrl
    }
    
    var title: String?
    {
        return food?.title ?? activity?.title
    }
    
    var subtitle: String?
    {
        return food?.servingUnit ?? activity?.frequency
    }
    
    var isFood: Bool
    {
        return food != nil
    }
    
    var typeId: Int?
    {
        return food?.id ?? activity?.id ?? lifestyleRecommendation?.id
    }
    
    var type: PlanType?
    {
        return food != nil ? .food : activity != nil ? .activity : lifestyleRecommendation != nil ? .reagentLifestyleRecommendation : nil
    }
    
    init(planId: Int, reminders: [Reminder], food: Food? = nil, activity: Tip? = nil, lifestyleRecommendation: LifestyleRecommendation? = nil)
    {
        self.planId = planId
        self.food = food
        self.activity = activity
        self.reminders = reminders
        self.lifestyleRecommendation = lifestyleRecommendation
    }
    
    func increaseQuantity(to reminderId: Int)
    {
        guard let reminder = reminders.first(where: { $0.id == reminderId }) else { return }
        reminder.quantity += 1
        ObjectStore.shared.clientSave(reminder)
    }
    
    func decreaseQuantity(to reminderId: Int)
    {
        guard let reminder = reminders.first(where: { $0.id == reminderId }) else { return }
        reminder.quantity = max(0, reminder.quantity - 1)
        ObjectStore.shared.clientSave(reminder)
    }
    
    func toggleSelectedDay(to reminderId: Int, day: Int)
    {
        guard let reminder = reminders.first(where: { $0.id == reminderId }) else { return }
        if let index = reminder.dayOfWeek.firstIndex(of: day)
        {
            reminder.dayOfWeek.remove(at: index)
        }
        else
        {
            reminder.dayOfWeek.append(day)
        }
        ObjectStore.shared.clientSave(reminder)
    }
    
    func removeReminder(with reminderId: Int)
    {
        guard let reminder = reminders.first(where: { $0.id == reminderToRemove }),
              let index = reminders.firstIndex(where: { $0.id == reminderToRemove }) else { return }
        reminders.remove(at: index)
        Storage.remove(reminderId, objectType: Reminder.self)
        ObjectStore.shared.removeFromCache(reminder)
        RemindersManager.shared.reloadReminders()
        NotificationCenter.default.post(name: .newDataArrived, object: nil, userInfo: ["objectType": String(describing: Reminder.self)])
    }
}
