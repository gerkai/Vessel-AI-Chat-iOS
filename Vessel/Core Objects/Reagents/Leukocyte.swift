//
//  Leukocyte.swift
//  Vessel
//
//  Created by Carson Whitsett on 10/17/22.
//  ID: 22

import Foundation

let Leukocyte = Reagent(
    name: NSLocalizedString("Leukocyte", comment: "Reagent name"),
    unit: NSLocalizedString("µg/L", comment: "unit of measurement"),
    consumptionUnit: NSLocalizedString("µG", comment: "consumption unit"),
    type: .Colorimetric,
    recommendedDailyAllowance: nil,
    imageName: "UrinaryTract",
    buckets: [
        Bucket(low: 60.0, high: 120.0, score: 0.0, evaluation: .detectedLow,
            hint: TitleDescription(
                title: NSLocalizedString("PLACEHOLDER TEXT - POSITIVE LEUKOCYTE", comment: ""),
                description: NSLocalizedString("PLACEHOLDER DESCRIPTION - POSITIVE LEUKOCYTE", comment: ""))),
        Bucket(low: 0.0, high: 60.0, score: 0.0, evaluation: .notDetected,
            hint: TitleDescription(title: NSLocalizedString("PLACEHOLDER TEXT - NEGATIVE LEUKOCYTE", comment: ""),
            description: NSLocalizedString("PLACEHOLDER DESCRIPTION FOR NEGATIVE LEUKOCYTE", comment: "")))],
    goalImpacts: [],
    goalSources: [],
    moreInfo: [
        TitleDescription(
            title: Constants.HOW_TO_READ_THE_GRAPH,
            description: NSLocalizedString("", comment: "")),
        TitleDescription(
            title: Constants.WHY_IT_MATTERS,
            description: NSLocalizedString("", comment: "")),
        TitleDescription(
            title: Constants.TIPS_TO_IMPROVE,
            description: NSLocalizedString("", comment: ""))])
