//
//  Step.swift
//  Vessel
//
//  Created by Nicolas Medina on 11/16/22.
//

import Foundation

enum StepType: String
{
    case survey = "SURVEY"
    case quiz = "QUIZ"
    case readonly = "READONLY"
    case input = "INPUT"
}

class Step: CoreObjectProtocol
{
    let id: Int
    var last_updated: Int
    let storage: StorageType = .cacheAndDisk

    var type: StepType
    {
        return StepType(rawValue: typeString)!
    }
    private let typeString: String
    var title: String?
    var text: String?
    let successText: String?
    let imageUrl: String?
    let isSkippable: Bool
    var answers: [LessonStepAnswer]
    var answerId: Int?
    var activityIds: [Int]?
    
    init(id: Int, last_updated: Int, typeString: String, title: String? = nil, text: String? = nil, successText: String, imageUrl: String, isSkippable: Bool, answers: [LessonStepAnswer], answerId: Int? = nil, activityIds: [Int]? = nil)
    {
        self.id = id
        self.last_updated = last_updated
        self.typeString = typeString
        self.title = title
        self.text = text
        self.successText = successText
        self.imageUrl = imageUrl
        self.isSkippable = isSkippable
        self.answers = answers
        self.answerId = answerId
        self.activityIds = activityIds
    }
    
    enum CodingKeys: String, CodingKey
    {
        case id
        case last_updated
        case typeString = "type"
        case title
        case text
        case successText = "success_text"
        case imageUrl = "image_url"
        case isSkippable = "is_skippable"
        case answers
        case answerId
        case activityIds = "activity_ids"
    }
}

class LessonStepAnswer: CoreObjectProtocol
{
    let id: Int
    var last_updated: Int
    let storage: StorageType = .cacheAndDisk

    let primaryText: String
    var secondaryText: String?
    
    init(id: Int, last_updated: Int, primaryText: String, secondaryText: String?)
    {
        self.id = id
        self.last_updated = last_updated
        self.primaryText = primaryText
        self.secondaryText = secondaryText
    }
    
    enum CodingKeys: String, CodingKey
    {
        case id
        case last_updated
        case primaryText = "primary_text"
        case secondaryText = "secondary_text"
    }
}
