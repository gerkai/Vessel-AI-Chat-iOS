//
//  Lesson.swift
//  Vessel
//
//  Created by Nicolas Medina on 11/16/22.
//

import Foundation

class Lesson: CoreObjectProtocol, Equatable
{
    let id: Int
    var last_updated: Int = 0
    let storage: StorageType = .disk
    
    let title: String
    let description: String
    let imageUrl: String?
    var completedDate: String?
    var rank: Int
    let stepIds: [Int]
    var steps: [Step] = []
    var goalIds: [Int]
    var duration: Int = 2
    
    var isComplete: Bool
    {
        completedDate != nil
    }

    var completedToday: Bool
    {
        guard let completedDate = completedDate else { return false }
        let todayDateString = Date.serverDateFormatter.string(from: Date())
        return todayDateString == completedDate
    }
    
    init(id: Int,
         last_updated: Int,
         title: String,
         description: String,
         imageUrl: String?,
         completedDate: String? = nil,
         rank: Int,
         stepIds: [Int],
         goalIds: [Int],
         duration: Int)
    {
        self.id = id
        self.last_updated = last_updated
        self.title = title
        self.description = description
        self.imageUrl = imageUrl
        self.completedDate = completedDate
        self.rank = rank
        self.stepIds = stepIds
        self.goalIds = goalIds
        self.duration = duration
    }
    
    enum CodingKeys: String, CodingKey
    {
        case id
        case last_updated
        case title
        case description
        case imageUrl = "image_url"
        case completedDate = "completed_date"
        case rank
        case stepIds = "step_ids"
        case goalIds = "goal_ids"
        case duration
    }
    
    static func == (lhs: Lesson, rhs: Lesson) -> Bool
    {
        return lhs.id == rhs.id
        && lhs.last_updated == rhs.last_updated
        && lhs.title == rhs.title
        && lhs.description == rhs.description
        && lhs.imageUrl == rhs.imageUrl
        && lhs.completedDate == rhs.completedDate
        && lhs.rank == rhs.rank
        && lhs.stepIds == rhs.stepIds
        && lhs.goalIds == rhs.goalIds
        && lhs.duration == rhs.duration
    }
    
    func subtitleString() -> String
    {
        var goalsString = ""
        goalIds.forEach { goalID in
            if let key = Goal.ID(rawValue: goalID), let goalName = Goals[key]?.name
            {
                goalsString += goalID == goalIds.first ? "" : goalID == goalIds.last ? " and " : ", "
                goalsString += goalName.capitalized
            }
        }
        return goalsString + " (\(durationString()))"
    }
    
    func durationString() -> String
    {
        if duration == 1
        {
            return NSLocalizedString("1 min", comment: "")
        }
        else
        {
            return "\(duration) \(NSLocalizedString("mins", comment: ""))"
        }
    }
}
