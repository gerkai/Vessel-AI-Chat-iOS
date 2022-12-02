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
    let storage: StorageType = .cacheAndDisk
    
    let title: String
    // TODO: Remove optional once backend send this every time
    let description: String?
    let imageUrl: String?
    var completedDate: String?
    var rank: Int
    // TODO: Remove hardcoded activity ids once the backend starts returning those
    var activityIds: [Int] = [15, 18, 20]
    var activities = [Tip]()
    let stepIds: [Int]
    var steps: [Step] = []
    // TODO: Remove harcoded values once backend send this every time
    var goalIds: [Int] = [2, 3, 4]
    var duration: Int = 2
    
    var isComplete: Bool
    {
        completedDate != nil
    }
    
    var completedToday: Bool
    {
        guard let completedDate = completedDate,
              let date = completedDate.split(separator: "T")[safe: 0] else { return false }
        let todayDateString = Date.serverDateFormatter.string(from: Date())
        return todayDateString == date
    }
    
    init(id: Int,
         last_updated: Int,
         title: String,
         description: String,
         imageUrl: String?,
         completedDate: String? = nil,
         rank: Int,
         activityIds: [Int],
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
        self.activityIds = activityIds
        self.stepIds = stepIds
        self.goalIds = goalIds
        self.duration = duration
    }
    
    enum CodingKeys: String, CodingKey
    {
        case id
        case title
        case description
        case imageUrl = "image_url"
        case completedDate = "completed_date"
        case rank
        // TODO: Uncomment once the backend starts returning those
//        case activityIds = "activity_ids"
        case stepIds = "step_ids"
        // TODO: Uncomment once backend send this every time
//        case goalIds = "goal_id"
//        case duration
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
        && lhs.activityIds == rhs.activityIds
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
