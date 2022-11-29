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

    var type: StepType?
    {
        // There are steps with type null so I added this for dev testing
        return StepType(rawValue: typeString ?? "")
    }
    private let typeString: String?
    var title: String?
    var text: String?
    let successText: String?
//    var placeholderText: String?
    let imageUrl: String?
    let isSkippable: Bool
    var answers: [LessonStepAnswer]
    var answerId: Int?
    var activityIds: [Int]?
    var correctAnswerId: Int?
    {
        answers.first(where: { $0.correct })?.id
    }
    var answerText: String?
    var questionRead: Bool?
    var lessonId: Int?
    
    init(id: Int,
         last_updated: Int,
         typeString: String?,
         title: String? = nil,
         text: String? = nil,
         successText: String?,
//         placeholderText: String?,
         imageUrl: String,
         isSkippable: Bool,
         answers: [LessonStepAnswer],
         answerId: Int? = nil,
         answerText: String? = nil,
         questionRead: Bool? = nil,
         lessonId: Int? = nil,
         activityIds: [Int]? = nil)
    {
        self.id = id
        self.last_updated = last_updated
        self.typeString = typeString
        self.title = title
        self.text = text
        self.successText = successText
//        self.placeholderText = placeholderText
        self.imageUrl = imageUrl
        self.isSkippable = isSkippable
        self.answers = answers
        self.answerId = answerId
        self.answerText = answerText
        self.questionRead = questionRead
        self.lessonId = lessonId
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
//        case placeholderText = "placeholder_text"
        case imageUrl = "image_url"
        case isSkippable = "is_skippable"
        case answers
        case answerId = "answer_id"
        case questionRead = "question_read"
        case answerText = "answer_text"
        case lessonId = "lesson_id"
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
    private let isCorrect: Bool?
    var correct: Bool
    {
        isCorrect ?? true
    }
    
    init(id: Int, last_updated: Int, primaryText: String, secondaryText: String?, isCorrect: Bool? = nil)
    {
        self.id = id
        self.last_updated = last_updated
        self.primaryText = primaryText
        self.secondaryText = secondaryText
        self.isCorrect = isCorrect
    }
    
    enum CodingKeys: String, CodingKey
    {
        case id
        case last_updated
        case primaryText = "primary_text"
        case secondaryText = "secondary_text"
        case isCorrect = "is_correct"
    }
}
