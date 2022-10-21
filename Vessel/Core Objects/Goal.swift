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
    var headerText: String
    
    enum ID: Int, CaseIterable
    {
        case BODY = 6
        case SLEEP = 4
        case ENERGY = 5
        case FITNESS = 10
        case CALM = 3
        case IMMUNITY = 8
        case FOCUS = 2
        case MOOD = 1
        case BEAUTY = 7
        case DIGESTION = 9
    }
}

//wellness = focus
//endurance = fitness
let Goals: [Goal.ID: Goal] = [
    Goal.ID.MOOD: Goal(name: NSLocalizedString("mood", comment: "Type of goal"), nameWithArticle: NSLocalizedString("a mood", comment: "Type of goal"), imageName: "Mood", headerText: "Learn all about mood and the impact that metrics such as sodium have on your ability to maintain a positive mood. This page can be used as an educational resource in order to expand your knowledge on how Vessel's metrics impact your mood. "),
    Goal.ID.FOCUS: Goal(name: NSLocalizedString("focus", comment: "Type of goal"), nameWithArticle: NSLocalizedString("a focus", comment: "Type of goal"), imageName: "Focus", headerText: "Learn all about focus and the impact that metrics such as hydration have on your ability to maintain focus throughout the day. This page can be used as an educational resource in order to expand your knowledge on how Vessel's metrics impact your focus. "),
    Goal.ID.CALM: Goal(name: NSLocalizedString("calm", comment: "Type of goal"), nameWithArticle: NSLocalizedString("a calm", comment: "Type of goal"), imageName: "Calm", headerText: "Learn all about beauty and the impact that metrics such as vitamin c and hydration have on your inner and outer beauty. This page can be used as an educational resource in order to expand your knowledge on how Vessel's metrics impact your beauty. "),
    Goal.ID.SLEEP: Goal(name: NSLocalizedString("sleep", comment: "Type of goal"), nameWithArticle: NSLocalizedString("a sleep", comment: "Type of goal"), imageName: "Sleep", headerText: "Learn all about sleep and the impact that metrics such as magnesium have on your ability to fall and stay asleep. This page can be used as an educational resource in order to expand your knowledge on how Vessel's metrics impact your sleep."),
    Goal.ID.ENERGY: Goal(name: NSLocalizedString("energy", comment: "Type of goal"), nameWithArticle: NSLocalizedString("an energy", comment: "Type of goal"), imageName: "Energy", headerText: "Learn all about energy and the impact that metrics such as magnesium and ketones have on your daily energy levels. This page can be used as an educational resource in order to expand your knowledge on how Vessel's metrics impact your energy."),
    Goal.ID.BODY: Goal(name: NSLocalizedString("body", comment: "Type of goal"), nameWithArticle: NSLocalizedString("a body", comment: "Type of goal"), imageName: "Body", headerText: "Learn all about focus and the impact that metrics such as hydration have on your ability to maintain focus throughout the day. This page can be used as an educational resource in order to expand your knowledge on how Vessel's metrics impact your focus. "),
    Goal.ID.BEAUTY: Goal(name: NSLocalizedString("beauty", comment: "Type of goal"), nameWithArticle: NSLocalizedString("a beauty", comment: "Type of goal"), imageName: "Beauty", headerText: "Learn all about beauty and the impact that metrics such as vitamin c and hydration have on your inner and outer beauty. This page can be used as an educational resource in order to expand your knowledge on how Vessel's metrics impact your beauty. "),
    Goal.ID.IMMUNITY: Goal(name: NSLocalizedString("immunity", comment: "Type of goal"), nameWithArticle: NSLocalizedString("an immunity", comment: "Type of goal"), imageName: "Immunity", headerText: "Learn all about focus and the impact that metrics such as hydration have on your ability to maintain focus throughout the day. This page can be used as an educational resource in order to expand your knowledge on how Vessel's metrics impact your focus. "),
    Goal.ID.DIGESTION: Goal(name: NSLocalizedString("digestion", comment: "Type of goal"), nameWithArticle: NSLocalizedString("a digestion", comment: "Type of goal"), imageName: "Digestion", headerText: "Learn all about mood and the impact that metrics such as sodium have on your ability to maintain a positive mood. This page can be used as an educational resource in order to expand your knowledge on how Vessel's metrics impact your mood. "),
    Goal.ID.FITNESS: Goal(name: NSLocalizedString("fitness", comment: "Type of goal"), nameWithArticle: NSLocalizedString("a fitness", comment: "Type of goal"), imageName: "Fitness", headerText: "Learn all about energy and the impact that metrics such as magnesium and ketones have on your daily energy levels. This page can be used as an educational resource in order to expand your knowledge on how Vessel's metrics impact your energy."),
]
