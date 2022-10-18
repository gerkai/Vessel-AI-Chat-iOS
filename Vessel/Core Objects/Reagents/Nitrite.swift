//
//  Nitrite.swift
//  Vessel
//
//  Created by Carson Whitsett on 10/17/22.
//

import Foundation

let Nitrite = Reagent(name: NSLocalizedString("Nitrites", comment: "Reagent name"),
                      unit: NSLocalizedString("µg/L", comment: "unit of measurement"),
                      consumptionUnit: NSLocalizedString("mG", comment: "consumption unit"),
                      type: .Colorimetric,
                      recommendedDailyAllowance: nil,
                      imageName: "UrinaryTract",
                      buckets: [Bucket(low: 3.0,
                                       high: 8.0,
                                           score: 0.0,
                                           evaluation: .high,
                                       hint: BucketHint(title: NSLocalizedString("Nitrites are detected high in urine", comment: ""),
                                                        description: NSLocalizedString("Vessel is not intended to be used as a tool to screen for or diagnose illness or disease. However, our product has the ability to screen for nitrates, which are a breakdown product of certain bacteria, in the urine. Your results detect high levels of nitrites in the urine. This may indicate a potential urogenital infection. While False positives are always possible, it is recommended you be evaluated by your physician or medical team, especially if you are experiencing any of the following symptoms: discomfort during urination, the urgency to urinate, or more frequent urination, fever, chills, abdomen, or flank pain, and nausea.", comment: ""))),
                                Bucket(low: 1.0,
                                       high: 3.0,
                                          score: 0.0,
                                          evaluation: .low,
                                       hint: BucketHint(title: NSLocalizedString("Nitrites are detected low in urine", comment: ""),
                                                        description: NSLocalizedString("Vessel is not intended to be used as a tool to screen for or diagnose illness or disease. However, our product has the ability to screen for nitrates, which are breakdown products of certain bacteria, in the urine. Your results detected low levels of nitrites, which may be a sign of a urogenital infection. Low detection of nitrites are common and can be benign. If you have any symptoms such as discomfort during urination, the urgency to urinate, or more frequent urination, fever, chills, abdomen, or flank pain, and nausea, Please be evaluated by your physician or medical team. As with any screening test, False positives and false negatives are always possible.", comment: ""))),
                                Bucket(low: 0.0,
                                                 high: 1.0,
                                                 score: 0.0,
                                                 evaluation: .good,
                                       hint: BucketHint(title: NSLocalizedString("Your results are normal", comment: ""),
                                                        description: NSLocalizedString("Vessel is not intended to be used as a tool to screen for or diagnose illness or disease. Our product has the ability to screen for nitrates, a breakdown product of certain bacteria, in the urine. Your test showed no nitrites, but urogenital infections can be present despite a lack of nitrites. Therefore if you have any symptoms such as burning during urination, frequent urination, abdomen/pelvic pain, or fever/chills, we recommend being evaluated by your physician or medical team. As with any test, false negatives are always possible.", comment: "")))],
                       goalImpacts: [],
                                       goalSources: [])
