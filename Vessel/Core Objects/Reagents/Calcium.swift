//
//  Calcium.swift
//  Vessel
//
//  Created by Carson Whitsett on 10/17/22.
//

import Foundation

let Calcium = Reagent(name: NSLocalizedString("Calcium", comment: "Reagent name"),
                      unit: NSLocalizedString("mg/L", comment: "unit of measurement"),
                      consumptionUnit: NSLocalizedString("mG", comment: "consumption unit"),
                      type: .Colorimetric,
                      recommendedDailyAllowance: 0,
                      imageName: "Calcium",
                      buckets: [Bucket(low: 110.0,
                                       high: 160.0,
                                           score: 70.0,
                                           evaluation: .high,
                                       hint: BucketHint(title: NSLocalizedString("Your Calcium level is too high", comment: ""),
                                                        description: NSLocalizedString("Oops, you overshot the goal. Your calcium level is higher than what your body wants right now, and a high concentration of calcium is being dumped out into your urine. If you’re taking calcium supplements, consider stopping them or reducing the dose. You may also want to cut down on Kiwifruit, bell peppers, and citrus. (Note, levels may be artificially high if you’re on a medication called a loop diuretic such as Lasix/furosemide. If so, you unfortunately can't rely on our test to assess your Calcium levels.)", comment: ""))),
                                Bucket(low: 30.0,
                                       high: 110.0,
                                          score: 100.0,
                                          evaluation: .good,
                                       hint: BucketHint(title: NSLocalizedString("Your Calcium level is great!", comment: ""),
                                                        description: NSLocalizedString("Good job! You’ve filled up your body’s calcium tank and a slight excess is spilling out into your urine. This is just what you want. Keep up the good work! Check out the Science section below to see some of the potential benefits you may experience from being in a good range for Calcium.", comment: ""))),
                                Bucket(low: 0.0,
                                                 high: 30.0,
                                                 score: 30.0,
                                                 evaluation: .low,
                                       hint: BucketHint(title: NSLocalizedString("You’re low in Calcium", comment: ""),
                                                        description: NSLocalizedString("Not to worry. You can improve your levels by changing your nutrient intake, whether that’s with food and/or supplements. The TOTAL from Food and Supplements Combined for calcium intake should be no greater than 1000mg. Be patient because it can take 1-2 weeks to see your levels improve. Click below to see your personalized plan. You got this! (Note that levels may also be low if you’re on a blood pressure medication called a thiazide diuretic. If you are, unfortunately, you can’t rely on this test to get an accurate calcium level.).", comment: "")))],
                       goalImpacts: [GoalImpact(goalID: 1, impact: 1),
                                     GoalImpact(goalID: 2, impact: 1),
                                     GoalImpact(goalID: 3, impact: 1),
                                     GoalImpact(goalID: 4, impact: 2),
                                     GoalImpact(goalID: 6, impact: 3),
                                     GoalImpact(goalID: 7, impact: 2),
                                     GoalImpact(goalID: 8, impact: 1),
                                     GoalImpact(goalID: 9, impact: 1),
                                     GoalImpact(goalID: 10, impact: 3)
                                     ],
                   goalSources: [GoalSources(goalID: .CALM, sources: [
                       Source(url: "https://pubmed.ncbi.nlm.nih.gov/35215428/#:~:text=Results%3A%20A%20total%20of%201233,rumination%2C%20and%20 higher%20 resilience%20scores", text: NSLocalizedString("This study found that higher calcium intakes, particularly from dairy products, were associated with lower reported stress levels and anxiety among students.", comment: ""))]),
                  GoalSources(goalID: .SLEEP, sources: [
                       Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/23992533", text: NSLocalizedString("This study found that calcium deficiency was associated with difficulty falling asleep, staying asleep, and a reduction in the overall quality of sleep.", comment: "")),
                       Source(url: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3866235/", text: NSLocalizedString("This paper found that calcium intake was associated with decreased difficulty falling asleep and improving the quality of sleep.", comment: "")),
                       Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/26996081/", text: NSLocalizedString("Calcium helps to regulate sleep duration.", comment: "")),
                       Source(url: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6988692/", text: NSLocalizedString("Nutrient deficiencies including calcium and magnesium are associated with insomnia in elderly patients.", comment: "")),
                       Source(url: "https://pubmed.ncbi.nlm.nih.gov/31581561/", text: NSLocalizedString("This study found an association between short sleep duration and inadequate intake of several micronutrients including calcium, magnesium, and vitamin C.", comment: ""))]),
                 GoalSources(goalID: .MOOD, sources: [
                       Source(url: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5891975/", text: NSLocalizedString("This study found significantly decreased concentrations of calcium and magnesium, iron, manganese, selenium, and zinc in patients with major depressive disorder compared with control subjects.", comment: "")),
                       Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/10682869", text: NSLocalizedString("Reduced symptoms of PMS: Good levels may contribute to reduced symptoms of premenstrual syndrome (a cluster of symptoms including but not limited to fatigue, irritability, moodiness, fluid retention, and breast tenderness).", comment: "")),
                       Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/15956003", text: NSLocalizedString("A high intake of calcium and vitamin D may reduce the risk of PMS", comment: "")),
                       Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/9731851", text: NSLocalizedString("1200 mg/day of calcium carbonate significantly reduced symptoms of PMS, particularly in the luteal phase.", comment: "")),
                       Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/2656936", text: NSLocalizedString("1000 mg/day of calcium carbonate for 3 months significantly alleviated PMS symptoms of pain, water retention and negative effect.", comment: "")),
                       Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/1924661", text: NSLocalizedString("Calcium supplementation reduced negative effect and water retention during the luteal phase and pain during the menstrual phase.", comment: "")),
                       Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/27752483", text: NSLocalizedString("In medical students, a regular practice of yoga or calcium supplementation may reduce PMS symptoms.", comment: ""))]),
                 GoalSources(goalID: .FOCUS, sources: [
                       Source(url: "https://pubmed.ncbi.nlm.nih.gov/17979900/", text: NSLocalizedString("In the general population, high serum calcium levels are associated with faster decline in cognitive function over the age of 75.", comment: "")),
                       Source(url: "https://content.iospress.com/articles/journal-of-alzheimers-disease/jad150538", text: NSLocalizedString("A small study found that men and women with self-reported memory and concentration impairment, anxiety, and difficulty sleeping who received between 1.5 and 2 grams of magnesium-L-threonate daily for three months had an average 10% increase in the speed of performance on an executive function task, while those who took a placebo showed much smaller improvement.", comment: "")),
                       Source(url: "https://pubmed.ncbi.nlm.nih.gov/29991463/", text: NSLocalizedString("This animal study found that magnesium intake was associated with memory enhancement.", comment: "")),
                       Source(url: "https://n.neurology.org/content/89/16/1716", text: NSLocalizedString("This study tracked over 9,500 adults in the Netherlands for about eight years found that those who began the study with the lowest or highest blood levels of magnesium (respectively, 0.79 mmol/L or less and 0.9 mmol/L or greater) were approximately 30% more likely to develop dementia (predominantly Alzheimer's disease) over the course of the study compared to those with mid-range levels (0.84 to 0.85 mmol/L) after adjusting for factors such as age and other diseases.", comment: "")),
                       Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/28952385", text: NSLocalizedString("Among over 6,000 men and women in Taiwan age 50 and older, found that those who were prescribed oral magnesium oxide for the treatment of constipation (average length of usage about 5 months) at the beginning of the study were 48% less likely to develop dementia over a 10 year follow-up period than those who had not taken magnesium oxide, even after adjusting for factors such as age, gender, and other medical conditions. Those who took magnesium oxide for more than one year had an even lower risk — they were 59% less likely to develop dementia.", comment: "")),
                       Source(url: "https://bmjopen.bmj.com/content/9/11/e030052", text: NSLocalizedString("Total Mg intake between the estimated average requirement and the recommended dietary allowances may associate with a lower risk of MCI/PD (mild cognitive impairment/probably dementia)", comment: ""))]),
                                 GoalSources(goalID: .BODY, sources: [
                        Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/21320381", text: NSLocalizedString("Reduced weight: Good levels may contribute to reduction in body fat.", comment: "")),
                        Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/15090625", text: NSLocalizedString("Increasing dietary calcium significantly augmented weight and fat loss, whereas dairy products exerted a substantially greater effect.", comment: "")),
                       Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/10834935", text: NSLocalizedString("increasing dietary calcium suppresses adipocyte intracellular Ca(2+) and thereby modulates energy metabolism and attenuates obesity risk.", comment: ""))]),
                                 GoalSources(goalID: .FITNESS, sources: [
                       Source(url: "https://pubmed.ncbi.nlm.nih.gov/26362226/", text: NSLocalizedString("Calcium supplementation showed improving bone properties for Young male jockeys in weight-restricted sports.", comment: "")),
                       Source(url: "https://pubmed.ncbi.nlm.nih.gov/20455886/", text: NSLocalizedString("Six months of calcium supplementation results in enhanced skeletal muscle strength and physical performance.", comment: ""))]),
                                 GoalSources(goalID: .IMMUNITY, sources: [
                       Source(url: "https://pubmed.ncbi.nlm.nih.gov/28153342/", text: NSLocalizedString("Adequate calcium levels can enhance immune function because calcium is part of the signaling pathway for the activation process of T cells, which are a part of the immune system that help the body fight infection.", comment: "")),
                       Source(url: "https://pubmed.ncbi.nlm.nih.gov/32589841/", text: NSLocalizedString("The calcium ion binds to a protein called human calprotectin (hCP), which is a part of the immune system, to help its function in fighting microbial pathogens in the body.", comment: ""))]),
                                 GoalSources(goalID: .BEAUTY, sources: [
                       Source(url: "https://pubmed.ncbi.nlm.nih.gov/29853739/", text: NSLocalizedString("Impaired keratinocytes (produce keratin) differentiation and poor skin barrier can result in skin issues such as psoriasis and atopic dermatitis. Adequate intracellular calcium stores play an essential role in regulating functions of the skin including keratinocyte differentiation and forming a healthy skin barrier.", comment: "")),
                       Source(url: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC8585361/", text: NSLocalizedString("Calcium-phosphates (CaPs) have been used in various beauty products including hair, skin, oral care and makeup, and show to be a great clean alternative ingredient for other hazardous ones.", comment: ""))]),
                                                     ])
