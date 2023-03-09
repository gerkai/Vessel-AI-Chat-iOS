//
//  Reminder.swift
//  Vessel
//
//  Created by Nicolas Medina on 2/2/23.
//

import Foundation

class Reminder: CoreObjectProtocol
{
    var id: Int
    var last_updated: Int
    let storage: StorageType = .disk
    
    var dayOfWeek: [Int]
    let planId: Int
    let contactId: Int
    var timeOfDay: String
    var quantity: Int
    
    init(id: Int = 0, last_updated: Int = 0, dayOfWeek: [Int] = [], planId: Int, contactId: Int = Contact.main()?.id ?? 0, timeOfDay: String = "", quantity: Int = 1)
    {
        self.id = id
        self.last_updated = last_updated
        self.dayOfWeek = dayOfWeek
        self.planId = planId
        self.contactId = contactId
        self.timeOfDay = timeOfDay
        self.quantity = quantity
    }
    
    enum CodingKeys: String, CodingKey
    {
        case id
        case last_updated
        case dayOfWeek = "day_of_week"
        case planId = "plan_id"
        case contactId = "contact_id"
        case timeOfDay = "time_of_day"
        case quantity = "quantity"
    }
}
