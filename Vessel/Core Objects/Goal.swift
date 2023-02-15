//
//  Goal.swift
//  Vessel
//
//  Created by Carson Whitsett on 7/10/22.
//

import UIKit

struct Goal
{
    var id: Int //int version of goal ID
    var name: String
    var nameWithArticle: String
    var imageName: String
    var headerText: String
    var backgroundColor: UIColor
    var largeImageName: String
    {
        get
        {
            return imageName + "-lg"
        }
    }
    
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
    Goal.ID.MOOD: Goal(id: Goal.ID.MOOD.rawValue, name: NSLocalizedString("mood", comment: "Type of goal"), nameWithArticle: NSLocalizedString("a mood", comment: "Type of goal"), imageName: "Mood", headerText: NSLocalizedString("Learn all about mood and the impact that metrics such as sodium have on your ability to maintain a positive mood. This page can be used as an educational resource in order to expand your knowledge on how Vessel's metrics impact your mood. ", comment: ""), backgroundColor: Constants.vesselGreat),
    Goal.ID.FOCUS: Goal(id: Goal.ID.FOCUS.rawValue, name: NSLocalizedString("focus", comment: "Type of goal"), nameWithArticle: NSLocalizedString("a focus", comment: "Type of goal"), imageName: "Focus", headerText: NSLocalizedString("Learn all about focus and the impact that metrics such as hydration have on your ability to maintain focus throughout the day. This page can be used as an educational resource in order to expand your knowledge on how Vessel's metrics impact your focus.", comment: ""), backgroundColor: Constants.vesselTope),
    Goal.ID.CALM: Goal(id: Goal.ID.CALM.rawValue, name: NSLocalizedString("calm", comment: "Type of goal"), nameWithArticle: NSLocalizedString("a calm", comment: "Type of goal"), imageName: "Calm", headerText: NSLocalizedString("Learn all about calm and the impact that metrics such as magnesium and sodium have on your nervous system. This page can be used as an educational resource in order to expand your knowledge on how Vessel's metrics impact your calm goal.", comment: ""), backgroundColor: Constants.vesselGreat),
    Goal.ID.SLEEP: Goal(id: Goal.ID.SLEEP.rawValue, name: NSLocalizedString("sleep", comment: "Type of goal"), nameWithArticle: NSLocalizedString("a sleep", comment: "Type of goal"), imageName: "Sleep", headerText: NSLocalizedString("Learn all about sleep and the impact that metrics such as magnesium have on your ability to fall and stay asleep. This page can be used as an educational resource in order to expand your knowledge on how Vessel's metrics impact your sleep. ", comment: ""), backgroundColor: Constants.vesselGreat),
    Goal.ID.ENERGY: Goal(id: Goal.ID.ENERGY.rawValue, name: NSLocalizedString("energy", comment: "Type of goal"), nameWithArticle: NSLocalizedString("an energy", comment: "Type of goal"), imageName: "Energy", headerText: NSLocalizedString("Learn all about energy and the impact that metrics such as magnesium and ketones have on your daily energy levels. This page can be used as an educational resource in order to expand your knowledge on how Vessel's metrics impact your energy.", comment: ""), backgroundColor: Constants.vesselPoor),
    Goal.ID.BODY: Goal(id: Goal.ID.BODY.rawValue, name: NSLocalizedString("body", comment: "Type of goal"), nameWithArticle: NSLocalizedString("a body", comment: "Type of goal"), imageName: "Body", headerText: NSLocalizedString("Learn all about your body health and the impact that metrics such as sodium and magnesium have on your overall health. This page can be used as an educational resource in order to expand your knowledge on how Vessel's metrics impact your body.", comment: ""), backgroundColor: Constants.vesselTope),
    Goal.ID.BEAUTY: Goal(id: Goal.ID.BEAUTY.rawValue, name: NSLocalizedString("beauty", comment: "Type of goal"), nameWithArticle: NSLocalizedString("a beauty", comment: "Type of goal"), imageName: "Beauty", headerText: NSLocalizedString("Learn all about beauty and the impact that metrics such as Vitamin C and hydration have on your inner and outer beauty. This page can be used as an educational resource in order to expand your knowledge on how Vessel's metrics impact your beauty.", comment: ""), backgroundColor: Constants.vesselPoor),
    Goal.ID.IMMUNITY: Goal(id: Goal.ID.IMMUNITY.rawValue, name: NSLocalizedString("immunity", comment: "Type of goal"), nameWithArticle: NSLocalizedString("an immunity", comment: "Type of goal"), imageName: "Immunity", headerText: NSLocalizedString("Learn all about immunity and the impact that metrics such as vitamin C has on your immune system. This page can be used as an educational resource in order to expand your knowledge on how Vessel's metrics impact your immunity.", comment: ""), backgroundColor: Constants.vesselPoor),
    Goal.ID.DIGESTION: Goal(id: Goal.ID.DIGESTION.rawValue, name: NSLocalizedString("digestion", comment: "Type of goal"), nameWithArticle: NSLocalizedString("a digestion", comment: "Type of goal"), imageName: "Digestion", headerText: NSLocalizedString("Learn all about digestion and the impact that metrics such as hydration have on your digestive health. This page can be used as an educational resource in order to expand your knowledge on how Vessel's metrics impact your digestion. ", comment: ""), backgroundColor: Constants.vesselTope),
    Goal.ID.FITNESS: Goal(id: Goal.ID.FITNESS.rawValue, name: NSLocalizedString("fitness", comment: "Type of goal"), nameWithArticle: NSLocalizedString("a fitness", comment: "Type of goal"), imageName: "Fitness", headerText: NSLocalizedString("Learn all about fitness and the impact that metrics such as pH and Calcium have on your exercise performance and recovery. This page can be used as an educational resource in order to expand your knowledge on how Vessel's metrics impact your fitness. ", comment: ""), backgroundColor: Constants.vesselTope),
]
