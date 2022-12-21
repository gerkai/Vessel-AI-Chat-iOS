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
    case detectedLow
    case ketoLow //Ketones uses a special enum value for Low
    case moderate
    case good
    case normal
    case elevated
    case high
    case detectedHigh
    case ketoHigh //Ketones uses a special enum value for High
    case excellent
    
    var title: String
    {
        switch self
        {
            case .notAvailable:
                return NSLocalizedString("N/A", comment: "Abbreviation for Not Available")
            case .notDetected:
                return NSLocalizedString("not detected", comment: "Reagent evaluation label")
            case .veryLow:
                return NSLocalizedString("very low", comment: "Reagent evaluation label")
            case .low:
                return NSLocalizedString("low", comment: "Reagent evaluation label")
            case .ketoLow:
                return Contact.main()!.isOnDiet(.KETO) ? NSLocalizedString("low", comment: "Keto diet evaluation label") : NSLocalizedString("normal", comment: "Non Keto diet evaluation label")
            case .moderate:
                return NSLocalizedString("moderate", comment: "Reagent evaluation label")
            case .good:
                return NSLocalizedString("good", comment: "Reagent evaluation label")
            case .normal:
                return NSLocalizedString("normal", comment: "Reagent evaluation label")
            case .elevated:
                return NSLocalizedString("elevated", comment: "Reagent evaluation label")
            case .ketoHigh:
                return Contact.main()!.isOnDiet(.KETO) ? NSLocalizedString("good", comment: "Keto diet evaluation label") : NSLocalizedString("elevated", comment: "Non Keto diet evaluation label")
            case .high:
                return NSLocalizedString("high", comment: "Reagent evaluation label")
            case .excellent:
                return NSLocalizedString("excellent", comment: "Reagent evaluation label")
            case .detectedLow:
                return NSLocalizedString("detected low", comment: "Reagent evaluation label")
            case .detectedHigh:
            return NSLocalizedString("detected high", comment: "Reagent evaluation label")
        }
    }
    
    var color: UIColor
    {
        switch self
        {
            case .notAvailable:
                return UIColor.gray
            case .notDetected:
                return Constants.vesselGreat
            case .veryLow:
                return Constants.vesselPoor
            case .low:
                return Constants.vesselPoor
            case .ketoLow:
                if Contact.main()!.isOnDiet(.KETO)
                {
                    return Constants.vesselPoor
                }
                else
                {
                    return Constants.vesselGreat
                }
            case .moderate:
                return Constants.vesselGreat
            case .good:
                return Constants.vesselGreat
            case .normal:
                return Constants.vesselGreat
            case .elevated:
                return Constants.vesselPoor
            case .high:
                return Constants.vesselPoor
            case .ketoHigh:
                if Contact.main()!.isOnDiet(.KETO)
                {
                    return Constants.vesselGreat
                }
                else
                {
                    return Constants.vesselPoor
                }
            case .excellent:
                return Constants.vesselGreat
            case .detectedLow:
                return Constants.vesselPoor
            case .detectedHigh:
                return Constants.vesselPoor
        }
    }
    
    func isGood() -> Bool
    {
        if color == Constants.vesselGood || color == Constants.vesselGreat
        {
            return true
        }
        return false
    }
}

struct Bucket
{
    let low: Double
    let high: Double
    let score: Double
    let evaluation: Evaluation
    let hint: TitleDescription
}

struct TitleDescription
{
    let title: String
    let description: String
    let variation: String?
    
    internal init(title: String, description: String, variation: String? = nil)
    {
        self.title = title
        self.description = description
        self.variation = variation
    }
}

struct GoalImpact
{
    let goalID: Int
    let impact: Int
}

struct GoalSources
{
    let goalID: Goal.ID
    let sources: [Source]
}

struct Reagent
{
    enum ID: Int, CaseIterable
    {
        case PH = 1
        case HYDRATION = 2
        case KETONES_A = 3
        case VITAMIN_C = 4
        case MAGNESIUM = 5
        case CORTISOL = 8
        case VITAMIN_B7 = 11
        case CALCIUM = 18
        case NITRITE = 21
        //case LEUKOCYTE = 22
        case SODIUM = 23
    }
    var name: String
    var unit: String // pH, sp gr, mmol/L gm/L, µg/L, etc
    var consumptionUnit: String //mg, µg, etc.
    var type: ReagentType
    var recommendedDailyAllowance: Int?
    var imageName: String
    var buckets: [Bucket]
    var goalImpacts: [GoalImpact]
    var goalSources: [GoalSources]
    var moreInfo: [TitleDescription]
    
    //given a reagentID and a measurement value, this will return the evaluation (low, high, good, normal, elevated, etc)
    //returns .notAvailable if invalid parameter given
    static func evaluation(id: Reagent.ID, value: Double?) -> Evaluation
    {
        var eval = Evaluation.notAvailable
        
        if let value = value
        {
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
        }
        return eval
    }
    
    func getEvaluation(value: Double?) -> Evaluation
    {
        //establish highest and lowest buckets. That way if a value is out of range, we can slam it to highest or lowest.
        if let value = value
        {
            for bucket in buckets
            {
                if (value >= bucket.low) && (value < bucket.high)
                {
                    return bucket.evaluation
                }
            }
        }
        return Evaluation.notAvailable
    }
    
    func getScore(value: Double) -> Double
    {
        for bucket in buckets
        {
            if (value >= bucket.low) && (value < bucket.high)
            {
                return bucket.score
            }
        }
        return 0.0
    }
    
    func rangeFor(value: Double) -> String
    {
        //returns the lower and upper ranges of the bucket this value falls in
        for bucket in buckets
        {
            if (value >= bucket.low) && (value < bucket.high)
            {
                if (Double(Int(bucket.low)) == bucket.low) && (Double(Int(bucket.high)) == bucket.high)
                {
                    return "\(Int(bucket.low)) - \(Int(bucket.high))"
                }
                return "\(bucket.low) - \(bucket.high)"
            }
        }
        return NSLocalizedString("N/A", comment: "Abbreviation for 'not available'")
    }
    
    //returns which bucket this value falls in. If out of range of all buckets, returns nil
    func getBucketIndex(value: Double) -> Int?
    {
        var index: Int?
        var i = 0
        for bucket in buckets
        {
            if (value >= bucket.low) && (value < bucket.high)
            {
                index = i
                break
            }
            i += 1
        }
        return index
    }
    
    //given a goalID, this will return the impact level for that goal. 0 if none, or not found.
    func impactFor(goal: Int) -> Int
    {
        var impact = 0
        for goalImpact in goalImpacts
        {
            if goalImpact.goalID == goal
            {
                impact = goalImpact.impact
                break
            }
        }
        return impact
    }
    
    func sources(for goal: Goal.ID) -> [Source]
    {
        for source in goalSources
        {
            if source.goalID == goal
            {
                return source.sources
            }
        }
        return []
    }
    
    static func reagentsFor(goal: Int, withImpactAtLease: Int) -> [Int]
    {
        var reagentIDs: [Int] = []
        for id in Reagent.ID.allCases
        {
            if let reagent = Reagents[id]
            {
                for goalImpact in reagent.goalImpacts
                {
                    if (goalImpact.goalID == goal) && (goalImpact.impact >= withImpactAtLease)
                    {
                        reagentIDs.append(id.rawValue)
                    }
                }
            }
        }
        return reagentIDs
    }
    
    //given a reagentID (Int), return the associated Reagent
    static func fromID(id: Int) -> Reagent
    {
        let reagentID = Reagent.ID(rawValue: id)!
        return Reagents[reagentID]!
    }
}

//Here are the reagents used by the app.
let Reagents: [Reagent.ID: Reagent] =
[
    Reagent.ID.PH: PH,
    Reagent.ID.HYDRATION: Hydration,
    Reagent.ID.KETONES_A: Ketones,
    Reagent.ID.VITAMIN_C: VitaminC,
    Reagent.ID.MAGNESIUM: Magnesium,
    Reagent.ID.CORTISOL: Cortisol,
    Reagent.ID.VITAMIN_B7: VitaminB7,
    Reagent.ID.CALCIUM: Calcium,
    Reagent.ID.NITRITE: Nitrite,
    //Reagent.ID.LEUKOCYTE: Leukocyte,
    Reagent.ID.SODIUM: Sodium
]

//This array defines the order reagents will appear in the Results tab
let ReagentOrder: [Reagent.ID] =
[
    Reagent.ID.MAGNESIUM,
    Reagent.ID.VITAMIN_C,
    Reagent.ID.HYDRATION,
    Reagent.ID.SODIUM,
    Reagent.ID.CALCIUM,
    Reagent.ID.NITRITE,
    Reagent.ID.PH,
    Reagent.ID.KETONES_A,
    Reagent.ID.CORTISOL,
    Reagent.ID.VITAMIN_B7
    //Reagent.ID.LEUKOCYTE
]
