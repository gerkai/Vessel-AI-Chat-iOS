//
//  Curriculum.swift
//  Vessel
//
//  Created by Nicolas Medina on 11/16/22.
//

import Foundation

class Curriculum: CoreObjectProtocol
{
    let id: Int
    var last_updated: Int
    let storage: StorageType = .disk
    
    var goalId: Int
    var lessonIds: [Int]
    var lessonRanks: [LessonRank]
    
    init(id: Int, last_updated: Int, goalId: Int, lessonIds: [Int], lessonRanks: [LessonRank])
    {
        self.id = id
        self.last_updated = last_updated
        self.goalId = goalId
        self.lessonIds = lessonIds
        self.lessonRanks = lessonRanks
    }
    
    enum CodingKeys: String, CodingKey
    {
        case id
        case last_updated
        case goalId = "goal_id"
        case lessonIds = "lesson_ids"
        case lessonRanks = "lesson_ranks"
    }
}

struct LessonRank: Codable, Hashable
{
    let id: Int
    let rank: Int
    let completed: Bool
    
    init(id: Int, rank: Int, completed: Bool)
    {
        self.id = id
        self.rank = rank
        self.completed = completed
    }
    
    enum CodingKeys: CodingKey
    {
        case id
        case rank
        case completed
    }
}
