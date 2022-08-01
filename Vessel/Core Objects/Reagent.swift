//
//  Reagent.swift
//  Vessel
//
//  Created by Carson Whitsett on 7/27/22.
//

import UIKit

enum ReagentType
{
    case Colorimetric
    case LFA
}

enum Evaluation: String
{
    case notAvailable
    case notDetected
    case veryLow
    case low
    case moderate
    case good
    case normal
    case elevated
    case high
    case excellent
    case detected
    
    var title: String
    {
        switch self
        {
            case .notAvailable:
                return NSLocalizedString("N/A", comment: "Abbreviation for Not Available")
            case .notDetected:
                return "not detected"
            case .veryLow:
                return "very low"
            case .low:
                return "low"
            case .moderate:
                return "moderate"
            case .good:
                return "good"
            case .normal:
                return "normal"
            case .elevated:
                return "elevated"
            case .high:
                return "high"
            case .excellent:
                return "excellent"
            case .detected:
                return "detected"
        }
    }
    
    var color: UIColor
    {
        switch self
        {
            case .notAvailable:
                return UIColor.gray
        case .notDetected:
            return UIColor.gray
        case .veryLow:
            return Constants.vesselPoor
        case .low:
            return Constants.vesselFair
        case .moderate:
            return Constants.vesselGood
        case .good:
            return Constants.vesselGood
        case .normal:
            return Constants.vesselGreat
        case .elevated:
            return Constants.vesselFair
        case .high:
            return Constants.vesselPoor
        case .excellent:
            return Constants.vesselGreat
        case .detected:
            return Constants.vesselFair
        }
    }
}

struct Bucket
{
    let low: Double
    let high: Double
    let score: Float
    let evaluation: Evaluation
}

struct Reagent
{
    enum ID: Int
    {
        case PH = 1
        case HYDRATION = 2
        case KETONES_A = 3
        case VITAMIN_C = 4
        case MAGNESIUM = 5
        case CORTISOL = 8
        case VITAMIN_B7 = 11
        case CREATININE = 12
        case CALCIUM = 18
        case NITRITE = 21
        case LEUKOCYTE = 22
        case SODIUM = 23
    }
    var name: String
    var unit: String // pH, sp gr, mmol/L gm/L, µg/L, etc
    var consumptionUnit: String //mg, µg, etc.
    var type: ReagentType
    var recommendedDailyAllowance: Int?
    var imageName: String
    var buckets: [Bucket]
    
    //given a reagentID and a measurement value, this will return the evaluation (low, high, good, normal, elevated, etc)
    //returns .notAvailable if invalid parameter given
    static func evaluation(id: Reagent.ID, value: Double) -> Evaluation
    {
        var eval = Evaluation.notAvailable
        
        if let reagent = Reagents[id]
        {
            for bucket in reagent.buckets
            {
                if (value >= bucket.low) && (value < bucket.high)
                {
                    eval = bucket.evaluation
                }
            }
        }
        return eval
    }
    
    func getEvaluation(score: Double) -> Evaluation
    {
        var highestBucket: Bucket?
        var lowestBucket: Bucket?
        
        //establish highest and lowest buckets. That way if a value is out of range, we can slam it to highest or lowest.
        for bucket in buckets
        {
            if highestBucket != nil
            {
                if bucket.high > highestBucket!.high
                {
                    highestBucket = bucket
                }
            }
            else
            {
                highestBucket = bucket
            }
            if lowestBucket != nil
            {
                if bucket.low < lowestBucket!.low
                {
                    lowestBucket = bucket
                }
            }
            else
            {
                lowestBucket = bucket
            }
            
            if (score >= bucket.low) && (score <= bucket.high)
            {
                return bucket.evaluation
            }
        }
        if let highBucket = highestBucket
        {
            if score > highBucket.high
            {
                return highBucket.evaluation
            }
        }
        if let lowBucket = lowestBucket
        {
            if score < lowBucket.low
            {
                return lowBucket.evaluation
            }
        }
        return Evaluation.notAvailable
    }
}

//Here are the reagents used by the app
let Reagents: [Reagent.ID: Reagent] =
//PH
[Reagent.ID.PH: Reagent(name: NSLocalizedString("pH", comment: "Reagent Name"),
            unit: NSLocalizedString("pH", comment: "unit of measurement"),
            consumptionUnit: NSLocalizedString("pH", comment: "consumption unit"),
            type: .Colorimetric,
            recommendedDailyAllowance: nil,
            imageName: "pH",
            buckets: [Bucket(low: 5.0,
                             high: 6.0,
                             score: 30.0,
                             evaluation: .low),
                      Bucket(low: 6.0,
                             high: 7.75,
                             score: 100.0,
                             evaluation: .good),
                      Bucket(low: 7.78,
                             high: 8.0,
                             score: 30.0,
                             evaluation: .high)]),

 //HYDRATION
 Reagent.ID.HYDRATION: Reagent(name: NSLocalizedString("Hydration", comment: "Reagent name"),
            unit: NSLocalizedString("sp gr", comment: "unit of measurement"),
            consumptionUnit: NSLocalizedString("sp gr", comment: "consumption unit"),
            type: .Colorimetric,
            recommendedDailyAllowance: nil,
            imageName: "Hydration",
            buckets: [Bucket(low: 1.0,
                             high: 1.0015,
                             score: 80.0,
                             evaluation: .high),
                        Bucket(low: 1.0015,
                                high: 1.006,
                                score: 100.0,
                                evaluation: .good),
                        Bucket(low: 1.006,
                                 high: 1.015,
                                 score: 80.0,
                                 evaluation: .low),
                        Bucket(low: 1.015,
                                 high: 1.03,
                                 score: 20.0,
                                 evaluation: .veryLow)]),

 //KETONES
 Reagent.ID.KETONES_A: Reagent(name: NSLocalizedString("Ketones", comment: "Reagent name"),
            unit: NSLocalizedString("mmol/L", comment: "unit of measurement"),
            consumptionUnit: NSLocalizedString("", comment: "consumption unit"),
            type: .Colorimetric,
            recommendedDailyAllowance: nil,
            imageName: "Ketones",
            buckets: [Bucket(low: 0.0,
                             high: 2.21,
                             score: 0.0,
                             evaluation: .low),
                      Bucket(low: 2.21,
                             high: 8.81,
                              score: 0,
                              evaluation: .high)]),

 //VITAMIN C
 Reagent.ID.VITAMIN_C: Reagent(name: NSLocalizedString("Vitamin C", comment: "Reagent name"),
            unit: NSLocalizedString("mg/L", comment: "unit of measurement"),
            consumptionUnit: NSLocalizedString("mg", comment: "consumption unit"),
            type: .Colorimetric,
            recommendedDailyAllowance: 90,
            imageName: "Vitamin C",
            buckets: [Bucket(low: 0.0,
                             high: 350.0,
                             score: 20.0,
                             evaluation: .low),
                      Bucket(low: 350,
                             high: 1000,
                             score: 100.0,
                              evaluation: .good)]),

 //MAGNESIUM
 Reagent.ID.MAGNESIUM: Reagent(name: NSLocalizedString("Magnesium", comment: "Reagent name"),
            unit: NSLocalizedString("mg/L", comment: "unit of measurement"),
            consumptionUnit: NSLocalizedString("mg", comment: "consumption unit"),
            type: .Colorimetric,
            recommendedDailyAllowance: 400,
            imageName: "Magnesium",
            buckets: [Bucket(low: 0.0,
                             high: 100.0,
                             score: 20.0,
                             evaluation: .low),
                      Bucket(low: 100.0,
                            high: 300.0,
                             score: 80.0,
                            evaluation: .good),
                      Bucket(low: 300.0,
                             high: 1000.0,
                             score: 100.0,
                            evaluation: .excellent)]),

 //CORTISOL
 Reagent.ID.CORTISOL: Reagent(name: NSLocalizedString("Cortisol", comment: "Reagent name"),
            unit: NSLocalizedString("µg/L", comment: "unit of measurement"),
            consumptionUnit: NSLocalizedString("sp gr", comment: "consumption unit"),
            type: .LFA,
            recommendedDailyAllowance: nil,
            imageName: "Cortisol",
            buckets: [Bucket(low: 0.0,
                             high: 50.0,
                             score: 80.0,
                             evaluation: .low),
                      Bucket(low: 50.0,
                             high: 150.0,
                                score: 100.0,
                                evaluation: .good),
                      Bucket(low: 150.0,
                             high: 405.0,
                                 score: 50.0,
                                 evaluation: .high)]),

 //VITAMIN B7
 Reagent.ID.VITAMIN_B7: Reagent(name: NSLocalizedString("B7 (Biotin)", comment: "Reagent name"),
            unit: NSLocalizedString("µg/L", comment: "unit of measurement"),
            consumptionUnit: NSLocalizedString("µG", comment: "consumption unit"),
            type: .LFA,
            recommendedDailyAllowance: 30,
            imageName: "B7",
            buckets: [Bucket(low: 0.0,
                             high: 10.0,
                             score: 50.0,
                             evaluation: .low),
                      Bucket(low: 10.0,
                             high: 20.0,
                             score: 100.0,
                              evaluation: .good)]),

 //CALCIUM
 Reagent.ID.CALCIUM: Reagent(name: NSLocalizedString("Calcium", comment: "Reagent name"),
            unit: NSLocalizedString("mg/L", comment: "unit of measurement"),
            consumptionUnit: NSLocalizedString("mG", comment: "consumption unit"),
            type: .Colorimetric,
            recommendedDailyAllowance: 0,
            imageName: "Calcium",
            buckets: [Bucket(low: 0.0,
                             high: 30.0,
                             score: 30.0,
                             evaluation: .low),
                      Bucket(low: 30.0,
                             high: 110.0,
                                score: 100.0,
                                evaluation: .good),
                      Bucket(low: 110.0,
                             high: 160.0,
                                 score: 70.0,
                                 evaluation: .high)]),

 //NITRITES
 Reagent.ID.NITRITE: Reagent(name: NSLocalizedString("Nitrites", comment: "Reagent name"),
            unit: NSLocalizedString("µg/L", comment: "unit of measurement"),
            consumptionUnit: NSLocalizedString("mG", comment: "consumption unit"),
            type: .Colorimetric,
            recommendedDailyAllowance: nil,
            imageName: "UrinaryTract",
            buckets: [Bucket(low: 0.0,
                             high: 1.0,
                             score: 0.0,
                             evaluation: .good),
                      Bucket(low: 1.0,
                             high: 3.0,
                                score: 0.0,
                                evaluation: .low),
                      Bucket(low: 3.0,
                             high: 8.0,
                                 score: 0.0,
                                 evaluation: .high)]),

 //LEUKOCYTE
 Reagent.ID.LEUKOCYTE: Reagent(name: NSLocalizedString("Leukocyte", comment: "Reagent name"),
            unit: NSLocalizedString("µg/L", comment: "unit of measurement"),
            consumptionUnit: NSLocalizedString("µG", comment: "consumption unit"),
            type: .Colorimetric,
            recommendedDailyAllowance: nil,
            imageName: "UrinaryTract",
            buckets: [Bucket(low: 0.0,
                             high: 60.0,
                             score: 0.0,
                             evaluation: .notDetected),
                      Bucket(low: 60.0,
                             high: 120.0,
                             score: 0.0,
                              evaluation: .detected)]),

 //SODIUM CHLORIDE
 Reagent.ID.SODIUM: Reagent(name: NSLocalizedString("Sodium", comment: "Reagent name"),
            unit: NSLocalizedString("mEq/L", comment: "unit of measurement"),
            consumptionUnit: NSLocalizedString("mEq", comment: "consumption unit"),
            type: .Colorimetric,
            recommendedDailyAllowance: 0,
            imageName: "Sodium",
            buckets: [Bucket(low: 0.0,
                             high: 50.0,
                             score: 100.0,
                             evaluation: .good),
                      Bucket(low: 50.0,
                             high: 120.0,
                             score: 50.0,
                              evaluation: .high)]),
]
