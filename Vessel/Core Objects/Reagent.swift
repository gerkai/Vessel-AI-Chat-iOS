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
    //let reportedValue: Float?
    let score: Float
    let evaluation: Evaluation
    let title: String
    let description: String
    //let hint: Hint?
    //let recommendations: RecommendationPlans?
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
    //var supplementID: Int?
    
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
                             evaluation: .low,
                             title: NSLocalizedString("You're a bit acidic", comment: ""),
                             description: NSLocalizedString("Not to worry. You can improve your ph by changing your nutrient intake, whether that’s with food and/or supplements. Be patient because it can take 1-2 weeks to see your levels improve. Click below to see your personalized plan. You got this!", comment: "")),
                      Bucket(low: 6.0,
                             high: 7.75,
                             score: 100.0,
                             evaluation: .good,
                             title: NSLocalizedString("Your pH level is balanced", comment: ""),
                             description: NSLocalizedString("Good job! You’re keeping your body’s acid-base status well balanced. Keep up the good work! Check out the Science section below to see some of the potential benefits you may experience by having a balanced pH.", comment: "")),
                      Bucket(low: 7.78,
                             high: 8.0,
                             score: 30.0,
                             evaluation: .high,
                             title: NSLocalizedString("Your urine pH is too basic", comment: ""),
                             description: NSLocalizedString("Not to worry. You can improve your ph by changing your nutrient intake, whether that’s with food and/or supplements. Be patient because it can take 1-2 weeks to see your levels improve. Click below to see your personalized plan. You got this!", comment: ""))]),
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
                             evaluation: .high,
                             title: NSLocalizedString("You’re over-hydrated", comment: ""),
                             description: NSLocalizedString("Oops, you overshot your goal. Your urine is very diluted with water. Try consuming more electrolytes. The best way to do this is by eating more balanced meals that include plenty of fresh fruits and vegetables. Check out your Vessel food recommendations for personalized food recommendations.", comment: "")),
                        Bucket(low: 1.0015,
                                high: 1.006,
                                score: 100.0,
                                evaluation: .good,
                                title: NSLocalizedString("Your body is well hydrated", comment: ""),
                                description: NSLocalizedString("Good job! You’re getting enough water to help your body function at its best. Keep up the good work! Check out the Science section below to see some of the potential benefits you may experience from being well hydrated.", comment: "")),
                        Bucket(low: 1.006,
                                 high: 1.015,
                                 score: 80.0,
                                 evaluation: .low,
                                 title: NSLocalizedString("You're under hydrated", comment: ""),
                                 description: NSLocalizedString("You can improve your hydration level by changing your daily water intake. You should start to see results in 1-2 days so you may want to re-test to make sure you’re hitting your target. Tap below to see your personalized plan. You got this!", comment: "")),
                        Bucket(low: 1.015,
                                 high: 1.03,
                                 score: 20.0,
                                 evaluation: .veryLow,
                                 title: NSLocalizedString("You’re dehydrated", comment: ""),
                                 description: NSLocalizedString("Not to worry. You can improve your hydration level by changing your daily water intake. You should start to see results in 1-2 days so you may want to re-test to make sure you’re hitting your target. Tap below to see your personalized plan. You got this!", comment: ""))]),
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
                             evaluation: .low,
                             title: NSLocalizedString("Your Ketone levels are normal.", comment: ""),
                             description: NSLocalizedString("This is totally normal in people not trying to do a ketogenic diet. If you are, you might want to re-visit the calculations of your target fat, protein, and carbs each day. We’re here to help. Tap below to see your personalized plan. You got this!", comment: "")),
                      Bucket(low: 2.21,
                             high: 8.81,
                              score: 0,
                              evaluation: .high,
                              title: NSLocalizedString("Your Ketone levels are elevated.", comment: ""),
                              description: NSLocalizedString("Good job! The diet is working and your body is switching to ketone bodies as its primary fuel source. If you’re not on a ketogenic diet please check in with your doctor as this could be a sign of an underlying disease. Check out the Science section below to see some of the potential benefits you may experience from being in a good range for Ketones.", comment: ""))]),
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
                             evaluation: .low,
                             title: NSLocalizedString("You’re low in Vitamin C", comment: ""),
                             description: NSLocalizedString("Not to worry. You can improve your levels by changing your nutrient intake, whether that’s with food and/or supplements. Be patient because it can take 1-3 weeks to see your levels improve. Click below to see your personalized plan. You got this!", comment: "")),
                      Bucket(low: 350,
                             high: 1000,
                             score: 100.0,
                              evaluation: .good,
                              title: NSLocalizedString("Your Vitamin C level is great!", comment: ""),
                              description: NSLocalizedString("Good job! You’ve filled up your Vitamin C tank, and a slight excess is spilling out into your urine. This is just what you want. Check out the Science section below to see some of the potential benefits you may experience from being in a good range of Vitamin C.", comment: ""))]),
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
                             evaluation: .low,
                             title: NSLocalizedString("You’re low in Magnesium", comment: ""),
                             description: NSLocalizedString("Not to worry. You can improve your levels by changing your nutrient intake, whether that’s with food and/or supplements. Be patient because it can take 1-2 weeks to see your levels improve. Click below to see your personalized plan. You got this!", comment: "")),
                      Bucket(low: 100.0,
                            high: 300.0,
                             score: 80.0,
                            evaluation: .good,
                            title: NSLocalizedString("Your Magnesium level is good!", comment: ""),
                            description: NSLocalizedString("Good job! You’ve filled up your magnesium tank, and a slight excess is spilling out into your urine. This is just what you want.  Keep up the good work! Check out the Science section below to see some of the potential benefits you may experience from being in a good range for Magnesium.", comment: "")),
                      Bucket(low: 300.0,
                             high: 1000.0,
                             score: 100.0,
                            evaluation: .high,
                            title: NSLocalizedString("Your Magnesium level is great!", comment: ""),
                            description: NSLocalizedString("Good job! You’ve filled up your magnesium tank, and a slight excess is spilling out into your urine. This is just what you want.  Keep up the good work! Check out the Science section below to see some of the potential benefits you may experience from being in a good range for Magnesium.", comment: ""))]),
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
                             evaluation: .low,
                             title: NSLocalizedString("Your Cortisol level is low.", comment: ""),
                             description: NSLocalizedString("This might be a sign that your body has experienced a high amount of stress for a long period of time, and your adrenal glands may have difficulty creating enough cortisol.  Take a look at your personalized lifestyle recommendations to find out some ways to get your cortisol back in the normal range.  Be patient because it can take several months to see your levels improve. Click below to see your personalized plan. You got this!", comment: "")),
                      Bucket(low: 50.0,
                             high: 150.0,
                                score: 100.0,
                                evaluation: .good,
                                title: NSLocalizedString("Your Cortisol level is great!", comment: ""),
                                description: NSLocalizedString("Good job! Your cortisol levels are in the sweet spot. This is just what you want.  Keep up the good work! Check out the Science section below to see some of the potential benefits you may experience from being in a good range for Cortisol.", comment: "")),
                      Bucket(low: 150.0,
                             high: 405.0,
                                 score: 50.0,
                                 evaluation: .high,
                                 title: NSLocalizedString("Your Cortisol levels are high", comment: ""),
                                 description: NSLocalizedString("This is usually a sign that your body has mounted a stress response to protect you. This can (and should) happen if you’re sick, have an an injury that is healing, or just did a strenuous workout. However levels should normalize shortly after, so keep checking. Levels are often high due to acute stress, so be sure to check out the lifestyle recommendations below to reduce stress and increase your natural relaxation response.", comment: ""))]),
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
                             evaluation: .low,
                             title: NSLocalizedString("You’re low in Biotin", comment: ""),
                             description: NSLocalizedString("Not to worry. You can improve your levels by changing your nutrient intake, whether that’s with food and/or supplements. Be patient because it can take 1-4 weeks to see your levels improve. Click below to see your personalized plan. You got this!", comment: "")),
                      Bucket(low: 10.0,
                             high: 20.0,
                             score: 100.0,
                              evaluation: .good,
                              title: NSLocalizedString("Your Biotin level is great!", comment: ""),
                              description: NSLocalizedString("Good job! You’ve filled up your body’s Biotin tank, and a slight excess is spilling out into your urine. This is just what you want.  Keep up the good work! Check out the Science section below to see some of the potential benefits you may experience from being in a good range for Biotin.", comment: ""))]),
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
                             evaluation: .low,
                             title: NSLocalizedString("You’re low in Calcium", comment: ""),
                             description: NSLocalizedString("Not to worry. You can improve your levels by changing your nutrient intake, whether that’s with food and/or supplements. The TOTAL from Food and Supplements Combined for calcium intake should be no greater than 1000mg. Be patient because it can take 1-2 weeks to see your levels improve. Click below to see your personalized plan. You got this! (Note that levels may also be low if you’re on a blood pressure medication called a thiazide diuretic. If you are, unfortunately, you can’t rely on this test to get an accurate calcium level.).", comment: "")),
                      Bucket(low: 30.0,
                             high: 110.0,
                                score: 100.0,
                                evaluation: .good,
                                title: NSLocalizedString("Your Calcium level is great!", comment: ""),
                                description: NSLocalizedString("Good job! You’ve filled up your body’s calcium tank and a slight excess is spilling out into your urine. This is just what you want. Keep up the good work! Check out the Science section below to see some of the potential benefits you may experience from being in a good range for Calcium.", comment: "")),
                      Bucket(low: 110.0,
                             high: 160.0,
                                 score: 70.0,
                                 evaluation: .high,
                                 title: NSLocalizedString("Your Calcium level is too high", comment: ""),
                                 description: NSLocalizedString("Oops, you overshot the goal. Your calcium level is higher than what your body wants right now, and a high concentration of calcium is being dumped out into your urine. If you’re taking calcium supplements, consider stopping them or reducing the dose. You may also want to cut down on Kiwifruit, bell peppers, and citrus. (Note, levels may be artificially high if you’re on a medication called a loop diuretic such as Lasix/furosemide. If so, you unfortunately can't rely on our test to assess your Calcium levels.)", comment: ""))]),
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
                             evaluation: .good,
                             title: NSLocalizedString("Nitrites are not detected in urine", comment: ""),
                             description: NSLocalizedString("Vessel is not intended to be used as a tool to screen for or diagnose illness or disease. Our product has the ability to screen for nitrates, a breakdown product of certain bacteria, in the urine. Your test showed no nitrites, but urogenital infections can be present despite a lack of nitrites. Therefore if you have any symptoms such as burning during urination, frequent urination, abdomen/pelvic pain, or fever/chills, we recommend being evaluated by your physician or medical team. As with any test, false negatives are always possible.", comment: "")),
                      Bucket(low: 1.0,
                             high: 3.0,
                                score: 0.0,
                                evaluation: .low,
                                title: NSLocalizedString("A low level of nitrites is detected in your urine", comment: ""),
                                description: NSLocalizedString("Vessel is not intended to be used as a tool to screen for or diagnose illness or disease. However, our product has the ability to screen for nitrates, which are breakdown products of certain bacteria, in the urine. Your results detected low levels of nitrites, which may be a sign of a urogenital infection. Low detection of nitrites are common and can be benign. If you have any symptoms such as discomfort during urination, the urgency to urinate, or more frequent urination, fever, chills, abdomen, or flank pain, and nausea, Please be evaluated by your physician or medical team. As with any screening test, False positives and false negatives are always possible.", comment: "")),
                      Bucket(low: 3.0,
                             high: 8.0,
                                 score: 0.0,
                                 evaluation: .high,
                                 title: NSLocalizedString("Nitrites are detected high in urine", comment: ""),
                                 description: NSLocalizedString("Vessel is not intended to be used as a tool to screen for or diagnose illness or disease. However, our product has the ability to screen for nitrates, which are a breakdown product of certain bacteria, in the urine. Your results detect high levels of nitrites in the urine. This may indicate a potential urogenital infection. While False positives are always possible, it is recommended you be evaluated by your physician or medical team, especially if you are experiencing any of the following symptoms: discomfort during urination, the urgency to urinate, or more frequent urination, fever, chills, abdomen, or flank pain, and nausea.", comment: ""))]),
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
                             evaluation: .notDetected,
                             title: NSLocalizedString("PLACEHOLDER TEXT - NEGATIVE LEUKOCYTE", comment: ""),
                             description: NSLocalizedString("PLACEHOLDER DESCRIPTION FOR NEGATIVE LEUKOCYTE", comment: "")),
                      Bucket(low: 60.0,
                             high: 120.0,
                             score: 0.0,
                              evaluation: .detected,
                              title: NSLocalizedString("PLACEHOLDER TEXT - POSITIVE LEUKOCYTE", comment: ""),
                              description: NSLocalizedString("PLACEHOLDER DESCRIPTION - POSITIVE LEUKOCYTE", comment: ""))]),
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
                             evaluation: .good,
                             title: NSLocalizedString("Your Sodium results are good", comment: ""),
                             description: NSLocalizedString("Good job! Your body is excreting healthy amounts of sodium in your urine. This is just what you want. Sodium in urine can be caused by the natural filtration of your kidneys, dietary sodium and hydration intake. Make sure you keep your sodium intake to about 2300mg, 1 teaspoon daily. To keep a healthy sodium intake, you can do dietary inventory of your sodium intake for a few days, reading every food label, determining how many serving sizes you ingest, doing the math and adding up your intake. If your food does not have a label (whole fruits and veggies) then assume your sodium intake from that food is zero. Check out the Science section below to see some of the potential benefits you may experience from being in a good range for sodium. Be sure to chat in with one of our health coaches to better understand food labels and sodium intake.", comment: "")),
                      Bucket(low: 50.0,
                             high: 120.0,
                             score: 50.0,
                              evaluation: .high,
                              title: NSLocalizedString("Your Sodium results are too high", comment: ""),
                              description: NSLocalizedString("Oops, you overshot the goal. Your sodium level is higher than what your body ideally needs at the moment, and a high concentration of sodium is being excreted out into your urine. We recommend that you do a dietary inventory of your sodium intake for a few days, reading every food label, determining how many serving sizes you ingest, doing the math and adding up your intake. If your food does not have a label (whole grains, vegetables, fruits, legumes, and unsalted nuts) then assume your sodium intake from that food is zero. We also recommend that you do not restrict or increase your sodium solely as a result of your Vessel test results. This is because too little or too much sodium seems to be connected to adverse cardiac events (that’s right—too little salt is bad for you too, but very few Americans are in danger of having this issue due to the large amount of sodium already added to the foods we eat). Keep track of any table salt you use to season your food and sodium in any beverages too! Ideally, you want to limit your sodium to no more than 2300mg of sodium each day, approximately 1 teaspoon.", comment: ""))]),
]
