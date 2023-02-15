//
//  VitaminB7.swift
//  Vessel
//
//  Created by Carson Whitsett on 10/17/22.
//  ID: 11

import Foundation

let VitaminB7 = Reagent(
    name: NSLocalizedString("B7 (Biotin)", comment: "Reagent name"),
    unit: NSLocalizedString("µg/L", comment: "unit of measurement"),
    consumptionUnit: NSLocalizedString("µG", comment: "consumption unit"),
    type: .LFA,
    recommendedDailyAllowance: 30,
    imageName: "B7",
    buckets: [
        Bucket(low: 10.0, high: 30.0, score: 100.0, evaluation: .good,
            hint: TitleDescription(title: NSLocalizedString("Your Biotin level is great!", comment: ""),
            description: NSLocalizedString("Good job! You’ve filled up your body’s Biotin tank, and a slight excess is spilling out into your urine. This is just what you want.  Keep up the good work! Check out the Science section below to see some of the potential benefits you may experience from being in a good range for Biotin.", comment: ""))),
        Bucket(low: 0.0, high: 10.0, score: 50.0, evaluation: .low,
            hint: TitleDescription(title: NSLocalizedString("You’re low in Biotin", comment: ""),
                                   description: NSLocalizedString("Not to worry. You can improve your levels by changing your nutrient intake, whether that’s with food and/or supplements. Be patient because it can take 1-4 weeks to see your levels improve. You got this!", comment: "")))],
    goalImpacts: [
        GoalImpact(goalID: 1, impact: 2),
        GoalImpact(goalID: 5, impact: 2),
        GoalImpact(goalID: 6, impact: 3),
        GoalImpact(goalID: 7, impact: 3),
        GoalImpact(goalID: 8, impact: 1)],
    goalSources: [
        GoalSources(goalID: .ENERGY, sources: [
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/15628671/", text: NSLocalizedString("Biotin deficiency is associated with depression and fatigue.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/23010431/", text: NSLocalizedString("Biotin is important for generation of energy on a cellular level.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/15992683", text: NSLocalizedString("Biotin likely helps to develop glycogen, a form of energy the body uses in between meals and during exercise.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/16765926/", text: NSLocalizedString("Biotin is important for turning food into energy, and for providing fuel for the body during times of fasting.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/24801390/", text: NSLocalizedString("Biotin deficiency led to a substantial reduction in ATP, the main energy source for the body and mind in this animal study.", comment: ""))]),
        GoalSources(goalID: .MOOD, sources: [
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/15628671/", text: NSLocalizedString("Biotin deficiency is associated with depression and fatigue.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/27011198/", text: NSLocalizedString("Biotin deficiency is associated with depressive symptoms in children.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/6406708/", text: NSLocalizedString("Biotin deficiency was associated with severe depression and delirium in this case report.", comment: "")),
            Source(url: "http://www.sciencedirect.com/science/article/pii/S2211034815000061", text: NSLocalizedString("Biotin activates enzymes that improve nerve conduction which is essential for a healthy brain.", comment: ""))]),
        GoalSources(goalID: .BODY, sources: [
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/17506119", text: NSLocalizedString("Good biotin levels are associated with improved glycemic control in obese people, and blood sugar control is critically important for fat loss.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/26168302/", text: NSLocalizedString("Good biotin levels help with burning fat", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/26158509/", text: NSLocalizedString("Biotin deficiency is associated with slower metabolism", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/12055344/", text: NSLocalizedString("Good biotin levels are important for healthy metabolism", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/15992683", text: NSLocalizedString("Biotin likely helps to develop glycogen, a form of energy the body uses in between meals and during exercise.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/25997216/", text: NSLocalizedString("Biotin likely helps to develop glycogen, a form of energy the body uses in between meals and during exercise.", comment: ""))]),
        GoalSources(goalID: .IMMUNITY, sources: [
            Source(url: "https://www.ncbi.nlm.nih.gov/books/NBK547751/#:~:text=These%20include%20hair%20loss%20(alopecia,develop%20conjunctivitis%20and%20skin%20infections.", text: NSLocalizedString("Biotin deficiency may be associated with defects in B-cell and T-cell immunity, and natural killer cell function.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5129763/", text: NSLocalizedString("Biotin deficiency is associated with potentially dangerous over-activation of the inflammatory response of our immune system.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/26168302/", text: NSLocalizedString("Good biotin levels may be associated with maintaining a healthy functioning immune system.", comment: ""))]),
        GoalSources(goalID: .BEAUTY, sources: [
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/2273113?dopt=Abstract", text: NSLocalizedString("Biotin treatment led to a 25% increase in nail thickness in people with brittle nails.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/2648686?dopt=Abstract", text: NSLocalizedString("Biotin is an effective treatment for thin nails", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/3923177?dopt=Abstract", text: NSLocalizedString("Biotin deficiency is associated with hair loss and skin rashes on the lips, cheeks, and scalp.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/6406708/", text: NSLocalizedString("Biotin deficiency is associated with hair loss and skin rashes on the lips, cheeks, and scalp.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/15863846?dopt=Abstract", text: NSLocalizedString("Biotin deficiency is characterized by hair loss and a red scaly rash around body orifices.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/31638351/", text: NSLocalizedString("Biotin is helpful in the treatment of acne and dandruff (seborrheic dermatitis)", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/31022908/", text: NSLocalizedString("Biotin deficiency can also lead to zinc deficiency which is another cause of a severe type of skin rash.", comment: "")),
            Source(url: "https://jhu.pure.elsevier.com/en/publications/modern-nutrition-in-health-and-disease-eleventh-edition", text: NSLocalizedString("Low biotin levels are associated with bloodshot eyes.", comment: ""))])],
    moreInfo: [
        TitleDescription(
            title: Constants.HOW_TO_READ_THE_GRAPH,
            description: NSLocalizedString("When you’re in the good zone, your body is likely getting enough biotin to support your wellness.\n\nToo high means you may be getting more than you need. Although there isn’t much evidence of danger from high levels of biotin, you may be wasting money if you’re taking a supplement.\n\nToo low means you likely are not getting enough biotin, and you might want to up your intake. Check out the recommendations in the app for how to do that.", comment: "")),
        TitleDescription(
            title: Constants.WHY_IT_MATTERS,
            description: NSLocalizedString("Biotin, also called vitamin B7, is an essential vitamin that helps your body turn the carbohydrates, fats, and proteins in the food you eat into the energy you need. It also helps to regulate gene expression.", comment: "")),
        TitleDescription(
            title: Constants.TIPS_TO_IMPROVE,
            description: NSLocalizedString("The best way to improve your biotin stores is with whole fresh foods. Some people may need additional biotin in the form of supplementation.", comment: ""))])
