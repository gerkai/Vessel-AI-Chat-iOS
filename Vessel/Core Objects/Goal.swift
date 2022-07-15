//
//  Goal.swift
//  Vessel
//
//  Created by Carson Whitsett on 7/10/22.
//

import UIKit

struct Goal
{
    var id: Int
    var name: String
    var nameWithArticle: String
    var imageName: String
}

//wellness = focus
//endurance = fitness
let Goals: [Goal] = [Goal(id: 7, name: NSLocalizedString("beauty", comment: "Type of goal"), nameWithArticle: NSLocalizedString("a beauty", comment: "Type of goal"), imageName: "Beauty"),
                     Goal(id: 6, name: NSLocalizedString("body", comment: "Type of goal"), nameWithArticle: NSLocalizedString("a body", comment: "Type of goal"), imageName: "Body"),
                     Goal(id: 3, name: NSLocalizedString("calm", comment: "Type of goal"), nameWithArticle: NSLocalizedString("a calm", comment: "Type of goal"), imageName: "Calm"),
                        Goal(id: 9, name: NSLocalizedString("digestion", comment: "Type of goal"), nameWithArticle: NSLocalizedString("a digestion", comment: "Type of goal"), imageName: "Digestion"),
                        Goal(id: 10, name: NSLocalizedString("endurance", comment: "Type of goal"), nameWithArticle: NSLocalizedString("an endurance", comment: "Type of goal"), imageName: "Fitness"),
                        Goal(id: 5, name: NSLocalizedString("energy", comment: "Type of goal"), nameWithArticle: NSLocalizedString("an energy", comment: "Type of goal"), imageName: "Energy"),
                        Goal(id: 2, name: NSLocalizedString("focus", comment: "Type of goal"), nameWithArticle: NSLocalizedString("a focus", comment: "Type of goal"), imageName: "Focus"),
                        Goal(id: 8, name: NSLocalizedString("immunity", comment: "Type of goal"), nameWithArticle: NSLocalizedString("an immunity", comment: "Type of goal"), imageName: "Immunity"),
                        Goal(id: 1, name: NSLocalizedString("mood", comment: "Type of goal"), nameWithArticle: NSLocalizedString("a mood", comment: "Type of goal"), imageName: "Mood"),
                        Goal(id: 4, name: NSLocalizedString("sleep", comment: "Type of goal"), nameWithArticle: NSLocalizedString("a sleep", comment: "Type of goal"), imageName: "Sleep"),
                        Goal(id: 11, name: NSLocalizedString("wellness", comment: "Type of goal"), nameWithArticle: NSLocalizedString("a wellness", comment: "Type of goal"), imageName: "Focus")
]
