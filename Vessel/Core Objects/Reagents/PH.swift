//
//  PH.swift
//  Vessel
//
//  Created by Carson Whitsett on 10/17/22.
//

import Foundation

let PH = Reagent(name: NSLocalizedString("pH", comment: "Reagent Name"),
            unit: NSLocalizedString("pH", comment: "unit of measurement"),
            consumptionUnit: NSLocalizedString("pH", comment: "consumption unit"),
            type: .Colorimetric,
            recommendedDailyAllowance: nil,
            imageName: "pH",
            buckets: [Bucket(low: 7.78,
                             high: 8.0,
                             score: 30.0,
                             evaluation: .high,
                             hint: BucketHint(title: NSLocalizedString("Your urine pH is too basic", comment: ""), description: NSLocalizedString("Not to worry. You can improve your ph by changing your nutrient intake, whether that’s with food and/or supplements. Be patient because it can take 1-2 weeks to see your levels improve. Tap below to see your personalized plan. You got this!", comment: ""))),
                      Bucket(low: 6.0,
                             high: 7.75,
                             score: 100.0,
                             evaluation: .good,
                             hint: BucketHint(title: NSLocalizedString("Your pH level is balanced", comment: ""), description: NSLocalizedString("Good job! You’re keeping your body’s acid-base status well balanced. Keep up the good work! Check out the Science section below to see some of the potential benefits you may experience by having a balanced pH.", comment: ""))),
                      Bucket(low: 5.0,
                             high: 6.0,
                             score: 30.0,
                             evaluation: .low,
                             hint: BucketHint(title: NSLocalizedString("You're a bit acidic", comment: ""), description: NSLocalizedString("Not to worry. You can improve your ph by changing your nutrient intake, whether that’s with food and/or supplements. Be patient because it can take 1-2 weeks to see your levels improve. Click below to see your personalized plan. You got this!", comment: "")))],
                       goalImpacts: [GoalImpact(goalID: 5, impact: 1),
                                     GoalImpact(goalID: 6, impact: 1),
                                     GoalImpact(goalID: 10, impact: 2),
                                    ],
                        goalSources: [GoalSources(goalID: .ENERGY, sources: [
                            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/19932372", text: NSLocalizedString("Low pH associated with Fatigue: May be associated with feeling tired and sleepiness", comment: "")),
                            Source(url: "https://pubmed.ncbi.nlm.nih.gov/27755382/", text: NSLocalizedString("This paper reviews the connection between pH and energy levels.", comment: "")),
                            Source(url: "https://pubmed.ncbi.nlm.nih.gov/21923200/", text: NSLocalizedString("This meta-analysis found that low pH was associated with fatigue and using supplements to increase pH led to improved muscular performance.", comment: ""))]),
                                      GoalSources(goalID: .BODY, sources: [
                            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/11842945/", text: NSLocalizedString("This paper reviews how the body compensates for acidic foods by dissolving calcium and phosphorus in our bones, leading to lower bone density.", comment: "")),
                            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/8015587/", text: NSLocalizedString("This paper found that supplements that increase the alkali content of the diet improve bone density.", comment: "")),
                            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/17522265/", text: NSLocalizedString("This paper reviews the connection between dietary sodium and increased acidity in the body.", comment: "")),
                            Source(url: "https://pubmed.ncbi.nlm.nih.gov/11842948/", text: NSLocalizedString("This paper reviews the connection between an alkaline diet and bone health.", comment: ""))]),
                                      GoalSources(goalID: .FITNESS, sources: [
                            Source(url: "https://pubmed.ncbi.nlm.nih.gov/18326605/", text: NSLocalizedString("This study found that high alkaline diets helped to preserve muscle mass in older men and women.", comment: "")),
                            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/8676826/", text: NSLocalizedString("This paper reviews how diseases that cause higher levels of acidity are associated with muscle breakdown.", comment: "")),
                            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/15586003/", text: NSLocalizedString("This paper reviews how normalizing acidity can help to preserve muscle mass.", comment: "")),
                            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/8396707/", text: NSLocalizedString("This study found that supplements that improve alkalinity can help to prevent acidosis in conditions that normally trigger acute acidosis.", comment: "")),
                                      
                            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/11842945/", text: NSLocalizedString("This study reviews the consequences of the higher acidity levels in the western diet.", comment: "")),
                            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/8989270/", text: NSLocalizedString("In this study of postmenopausal women, taking supplements to make the blood more alkaline led to improved growth hormone secretion.", comment: "")),
                            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/621287/", text: NSLocalizedString("This study found that correction of acidosis improved growth hormone secretion in children.", comment: "")),
                            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/18326605", text: NSLocalizedString("Preserve muscle mass: Balanced pH is associated with preserved muscle mass in older men and women.", comment: ""))])])
