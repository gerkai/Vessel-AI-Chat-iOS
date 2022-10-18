//
//  Ketones.swift
//  Vessel
//
//  Created by Carson Whitsett on 10/17/22.
//

import Foundation

let Ketones = Reagent(name: NSLocalizedString("Ketones", comment: "Reagent name"),
                      unit: NSLocalizedString("mmol/L", comment: "unit of measurement"),
                      consumptionUnit: NSLocalizedString("", comment: "consumption unit"),
                      type: .Colorimetric,
                      recommendedDailyAllowance: nil,
                      imageName: "Ketones",
                      buckets: [Bucket(low: 2.21,
                                       high: 8.81,
                                        score: 0,
                                        evaluation: .ketoHigh,
                                       hint: BucketHint(title: NSLocalizedString("Your Ketone levels are elevated.", comment: ""),
                                                        description: NSLocalizedString("Good job! The diet is working and your body is switching to ketone bodies as its primary fuel source. If you’re not on a ketogenic diet please check in with your doctor as this could be a sign of an underlying disease. Check out the Science section below to see some of the potential benefits you may experience from being in a good range for Ketones.", comment: ""))),
                                Bucket(low: 0.0,
                                                 high: 2.21,
                                                 score: 0.0,
                                                 evaluation: .ketoLow,
                                       hint: BucketHint(title: NSLocalizedString("Your Ketone levels are normal.", comment: ""),
                                                        description: NSLocalizedString("This is totally normal in people not trying to do a ketogenic diet. If you are, you might want to re-visit the calculations of your target fat, protein, and carbs each day. We’re here to help. Tap below to see your personalized plan. You got this!", comment: "")))],
                      goalImpacts: [GoalImpact(goalID: 1, impact: 1),
                                    GoalImpact(goalID: 2, impact: 1),
                                    GoalImpact(goalID: 3, impact: 1),
                                    GoalImpact(goalID: 5, impact: 2),
                                    GoalImpact(goalID: 6, impact: 3)
                                   ],
                      goalSources: [GoalSources(goalID: .ENERGY, sources: [
                          Source(url: "https://pubmed.ncbi.nlm.nih.gov/30781824/", text: NSLocalizedString("This paper reviews how keto-adaptation can be a strategy to mitigate exercise-induced fatigue.", comment: "")),
                          Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/12776843", text: NSLocalizedString("This study discusses how short term carbohydrate restriction was associated with fatigue and low mood.", comment: "")),
                          Source(url: "https://pubmed.ncbi.nlm.nih.gov/30241310/", text: NSLocalizedString("This paper suggests that a ketogenic diet has the potential to be used as a fatigue-preventing and/or recovery-promoting diet approach in endurance athletes.", comment: ""))]),
                                    GoalSources(goalID: .CALM, sources: [
                                        Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/27999529", text: NSLocalizedString("This paper found that exogenous ketone supplementation was associated with reductions in anxiety behavior in animals.", comment: "")),
                                        Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/26547882", text: NSLocalizedString("This animal study found that a ketogenic diet normalized pathological behaviors including psychomotor hyperactivity, stereotyped behavior, social withdrawal, and working memory deficits.", comment: ""))]),
                                    GoalSources(goalID: .SLEEP, sources: [
                                        Source(url: "https://pubmed.ncbi.nlm.nih.gov/18681982/", text: NSLocalizedString("A ketogenic diet was associated with increased deep (slow-wave) sleep.", comment: "")),
                                        Source(url: "https://pubmed.ncbi.nlm.nih.gov/30241426/", text: NSLocalizedString("In this study, a ketogenic diet was associated with improved sleep quality and quality of life.", comment: ""))]),
                                    GoalSources(goalID: .MOOD, sources: [
                          Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/12776843", text: NSLocalizedString("This study discusses how short term carbohydrate restriction was associated with fatigue and low mood.", comment: "")),
                          Source(url: "https://pubmed.ncbi.nlm.nih.gov/2017017/", text: NSLocalizedString("In this study of female athletes, depressed mood was seen initially when switched to a low carbohydrate diet.", comment: "")),
                          Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/15601609", text: NSLocalizedString("This animal study found potential antidepressant properties of a ketogenic diet.", comment: "")),
                          Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/23030231", text: NSLocalizedString("This study found that a ketogenic diet helped to stabilize mood in patients with bipolar disorder.", comment: "")),
                          Source(url: "https://pubmed.ncbi.nlm.nih.gov/30241426/", text: NSLocalizedString("This study found that a ketogenic diet was associated with improvements in psychological wellbeing in obese subjects.", comment: "")),
                          Source(url: "https://pubmed.ncbi.nlm.nih.gov/17228046/", text: NSLocalizedString("This study found that subjects on a ketogenic diet had an improved mood from baseline.", comment: "")),
                          Source(url: "https://pubmed.ncbi.nlm.nih.gov/30075165/", text: NSLocalizedString("This paper found that the ketogenic diet has profound effects on multiple targets implicated in the pathophysiology of mood disorders, including but not limited to, glutamate/GABA transmission, monoamine levels, mitochondrial function and biogenesis, neurotrophism, oxidative stress, insulin dysfunction, and inflammation.", comment: "")),
                          Source(url: "https://pubmed.ncbi.nlm.nih.gov/31568812/", text: NSLocalizedString("This paper reviews the mechanism of action of the ketogenic diet in improving depression.", comment: "")),
                          Source(url: "https://pubmed.ncbi.nlm.nih.gov/11918434/", text: NSLocalizedString("This paper reviews the mood-stabilizing properties of the ketogenic diet.", comment: "")),
                          Source(url: "https://pubmed.ncbi.nlm.nih.gov/32406387/", text: NSLocalizedString("This paper supports the role of a ketogenic diet in treating depression.", comment: ""))]),
                                    GoalSources(goalID: .FOCUS, sources: [
                          Source(url: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6286979/", text: NSLocalizedString("This paper reviews evidence of ketogenic diets in improving cognition.", comment: "")),
                          Source(url: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4112040/", text: NSLocalizedString("This paper discusses how a ketogenic diet is associated with improved cognitive performance.", comment: "")),
                          Source(url: "https://pubmed.ncbi.nlm.nih.gov/29703936/", text: NSLocalizedString("This animal study found that a ketogenic diet improved blood flow to the brain.", comment: "")),
                          Source(url: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5981249/", text: NSLocalizedString("This paper reviews the potential benefits of a ketogenic diet in protecting neurons and preventing neurodegenerative diseases such as Alzheimer’s dementia.", comment: "")),
                          Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/19664276/", text: NSLocalizedString("This study found that higher ketone b levels were associated with improvement in tests of cognitive function.", comment: "")),
                          Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/26547882", text: NSLocalizedString("This animal study found that a ketogenic diet normalized pathological behaviors including psychomotor hyperactivity, stereotyped behavior, social withdrawal, and working memory deficits.", comment: "")),
                          Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/26773515/", text: NSLocalizedString("This animal study found that a ketogenic diet was associated with a significant reduction in ADHD-related behaviors.", comment: ""))]),
                                    GoalSources(goalID: .BODY, sources: [
                          Source(url: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6038311/", text: NSLocalizedString("This paper suggests that a ketogenic diet might be an alternative dietary approach to decrease fat mass and visceral adipose tissue without decreasing lean body mass.", comment: "")),
                          Source(url: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2716748/", text: NSLocalizedString("This study found that a long term ketogenic diet significantly reduced body weight and body mass index.", comment: "")),
                          Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/31705259", text: NSLocalizedString("This systematic review and meta-analysis found that a ketogenic diet is an effective strategy for the management of overweight and obese patients.", comment: "")),
                          Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/24557522", text: NSLocalizedString("This review discusses the physiological basis of ketogenic diets and the rationale for their use in obesity, discussing the strengths and the weaknesses of these diets together with cautions that should be used in obese patients.", comment: "")),
                          Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/25402637", text: NSLocalizedString("This paper reviews the benefits of a ketogenic diet in suppressing appetite to support weight loss.", comment: "")),
                          Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/29340675", text: NSLocalizedString("This paper reviews the evidence in support of a ketogenic diet for weight loss in patients with diabetes.", comment: "")),
                          Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/31705259", text: NSLocalizedString("This meta-analysis found that a long-term ketogenic diet was associated with reductions in body mass index, waist circumference, total cholesterol, triglycerides, markers of liver inflammation, and blood pressure.", comment: "")),
                          Source(url: "https://pubmed.ncbi.nlm.nih.gov/30241426/", text: NSLocalizedString("This study found that a ketogenic diet was associated with visceral fat loss, and reduced food cravings.", comment: ""))]),
                                    GoalSources(goalID: .FITNESS, sources: [
                          Source(url: "https://pubmed.ncbi.nlm.nih.gov/30781824/", text: NSLocalizedString("This paper reviews how keto-adaptation can be a strategy to mitigate exercise-induced fatigue.", comment: "")),
                          Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/29607218", text: NSLocalizedString("This paper reviews the benefits of nutritional ketosis in supporting mitochondrial health, which is associated with improved exercise capacity.", comment: "")),
                          Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/29799502", text: NSLocalizedString("This animal study found that a ketogenic diet enhanced exercise capacity.", comment: "")),
                          Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/30241310", text: NSLocalizedString("This paper reviews how a ketogenic diet can be used to prevent exercise-induced fatigue.", comment: ""))]),
                                    GoalSources(goalID: .IMMUNITY, sources: [
                          Source(url: "https://www.nature.com/articles/s41574-020-0328-x", text: NSLocalizedString("This animal study discusses how a ketogenic diet affects immune function.", comment: "")),
                          Source(url: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7051856/", text: NSLocalizedString("This animal study found that a ketogenic diet improved immune response to exposure to the influenza virus.", comment: "")),
                          Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/23814544/", text: NSLocalizedString("This paper suggests that the efficacy of the ketogenic diet on the treatment of this immune-mediated status epilepticus may be mediated by the systemic and metabolic effects of the ketogenic diet on the immune system.", comment: "")),
                          Source(url: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7189564/", text: NSLocalizedString("This paper found that a ketogenic diet improved immune response to the influenza virus.", comment: "")),
                          Source(url: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4866042/", text: NSLocalizedString("This animal study suggests that the ketogenic diet increases tumor-reactive immune responses, and may have implications in combinational treatment approaches to a form of brain cancer.", comment: "")),
                          Source(url: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6678592/", text: NSLocalizedString("This paper dissects the complex interactions between ketogenic diet and gut microbiota and how this large network may influence human health.", comment: ""))]),
                                    GoalSources(goalID: .BEAUTY, sources: [
                          Source(url: "https://pubmed.ncbi.nlm.nih.gov/22327146/", text: NSLocalizedString("This paper reviews how a ketogenic diet can improve acne.", comment: "")),
                          Source(url: "https://pubmed.ncbi.nlm.nih.gov/28043175/", text: NSLocalizedString("This paper reviews the promising potential role of ketones in treating inflammatory dermatologic diseases.", comment: ""))])])
