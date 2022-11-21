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
    let description: String
    let imageUrl: String
    var completedDate: String?
    var rank: Int
    // TODO: Remove optional once backend send this every time
    let activityIds: [Int]?
    let stepIds: [Int]
    var steps: [Step] = []
    
    init(id: Int,
         last_updated: Int,
         title: String,
         description: String,
         imageUrl: String,
         completedDate: String? = nil,
         rank: Int,
         activityIds: [Int]?,
         stepIds: [Int])
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
    }
    
    enum CodingKeys: String, CodingKey
    {
        case id
        case title
        case description
        case imageUrl = "image_url"
        case completedDate = "completed_date"
        case rank
        case activityIds = "activity_ids"
        case stepIds = "step_ids"
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
    }
}
