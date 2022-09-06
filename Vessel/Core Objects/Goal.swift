//
//  Goal.swift
//  Vessel
//
//  Created by Carson Whitsett on 7/10/22.
//

import UIKit

struct Goal
{
    var name: String
    var nameWithArticle: String
    var imageName: String
    
    enum ID: Int, CaseIterable
    {
        case MOOD
        case FOCUS
        case CALM
        case SLEEP
        case ENERGY
        case BODY
        case BEAUTY
        case IMMUNITY
        case DIGESTION
        case FITNESS
    }
}

//wellness = focus
//endurance = fitness
let Goals: [Goal.ID: Goal] = [Goal.ID.MOOD: Goal(name: NSLocalizedString("mood", comment: "Type of goal"), nameWithArticle: NSLocalizedString("a mood", comment: "Type of goal"), imageName: "Mood"),
    Goal.ID.FOCUS: Goal(name: NSLocalizedString("focus", comment: "Type of goal"), nameWithArticle: NSLocalizedString("a focus", comment: "Type of goal"), imageName: "Focus"),
    Goal.ID.CALM: Goal(name: NSLocalizedString("calm", comment: "Type of goal"), nameWithArticle: NSLocalizedString("a calm", comment: "Type of goal"), imageName: "Calm"),
    Goal.ID.SLEEP: Goal(name: NSLocalizedString("sleep", comment: "Type of goal"), nameWithArticle: NSLocalizedString("a sleep", comment: "Type of goal"), imageName: "Sleep"),
    Goal.ID.ENERGY: Goal(name: NSLocalizedString("energy", comment: "Type of goal"), nameWithArticle: NSLocalizedString("an energy", comment: "Type of goal"), imageName: "Energy"),
    Goal.ID.BODY: Goal(name: NSLocalizedString("body", comment: "Type of goal"), nameWithArticle: NSLocalizedString("a body", comment: "Type of goal"), imageName: "Body"),
    Goal.ID.BEAUTY: Goal(name: NSLocalizedString("beauty", comment: "Type of goal"), nameWithArticle: NSLocalizedString("a beauty", comment: "Type of goal"), imageName: "Beauty"),
    Goal.ID.IMMUNITY: Goal(name: NSLocalizedString("immunity", comment: "Type of goal"), nameWithArticle: NSLocalizedString("an immunity", comment: "Type of goal"), imageName: "Immunity"),
    Goal.ID.DIGESTION: Goal(name: NSLocalizedString("digestion", comment: "Type of goal"), nameWithArticle: NSLocalizedString("a digestion", comment: "Type of goal"), imageName: "Digestion"),
    Goal.ID.FITNESS: Goal(name: NSLocalizedString("fitness", comment: "Type of goal"), nameWithArticle: NSLocalizedString("a fitness", comment: "Type of goal"), imageName: "Fitness"),
]
