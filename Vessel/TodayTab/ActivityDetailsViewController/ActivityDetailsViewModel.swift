//
//  ActivityDetailsViewModel.swift
//  Vessel
//
//  Created by Nicolas Medina on 10/5/22.
//

import Foundation

struct ActivityDetailsModel
{
    let id: Int
    let imageUrl: String
    let title: String
    let subtitle: String
    let description: String
    let reagents: String?
    let quantities: String?
    let type: PlanType
}

class ActivityDetailsViewModel
{
    // MARK: - Private vars
    private var object: ActivityDetailsModel
    var reminders: [Reminder] {
        return RemindersManager.shared.getRemindersForPlan(planId: id)
    }
    var remindersSchedules: [(day: String, time: String)] {
        return RemindersManager.shared.getReminderSchedules(forPlanId: id)
    }
    
    private var isMetric: Bool
    {
        //determine if we are using imperial or metric units
        Locale.current.usesMetricSystem
    }
    
    // MARK: - Public properties
    var id: Int
    {
        object.id
    }
    
    var type: PlanType
    {
        object.type
    }
    
    var imageURL: URL?
    {
        URL(string: object.imageUrl)
    }
    
    var title: String
    {
        object.title
    }
    
    var subtitle: String
    {
        object.subtitle
    }
    
    var description: String
    {
        object.description
    }
    
    var reagents: String?
    {
        object.reagents
    }
    
    var quantities: String?
    {
        object.quantities
    }
    
    var remindersAreEmpty: Bool
    {
        reminders.count == 0
    }
    
    init(model: ActivityDetailsModel)
    {
        object = model
    }
}
