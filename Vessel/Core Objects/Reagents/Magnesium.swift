//
//  Magnesium.swift
//  Vessel
//
//  Created by Carson Whitsett on 10/17/22.
//

import Foundation

let Magnesium = Reagent(name: NSLocalizedString("Magnesium", comment: "Reagent name"),
                        unit: NSLocalizedString("mg/L", comment: "unit of measurement"),
                        consumptionUnit: NSLocalizedString("mg", comment: "consumption unit"),
                        type: .Colorimetric,
                        recommendedDailyAllowance: 400,
                        imageName: "Magnesium",
                        buckets: [Bucket(low: 300.0,
                                         high: 1000.0,
                                         score: 100.0,
                                        evaluation: .excellent,
                                         hint: BucketHint(title: NSLocalizedString("Your Magnesium level is great!", comment: ""),
                                                          description: NSLocalizedString("Good job! You’ve filled up your magnesium tank, and a slight excess is spilling out into your urine. This is just what you want.  Keep up the good work! Check out the Science section below to see some of the potential benefits you may experience from being in a good range for Magnesium.", comment: ""))),
                                  Bucket(low: 100.0,
                                        high: 300.0,
                                         score: 80.0,
                                        evaluation: .good,
                                         hint: BucketHint(title: NSLocalizedString("Your Magnesium level is good!", comment: ""),
                                                          description: NSLocalizedString("Good job! You’ve filled up your magnesium tank, and a slight excess is spilling out into your urine. This is just what you want.  Keep up the good work! Check out the Science section below to see some of the potential benefits you may experience from being in a good range for Magnesium.", comment: ""))),
                                  Bucket(low: 0.0,
                                   high: 100.0,
                                   score: 20.0,
                                   evaluation: .low,
                                         hint: BucketHint(title: NSLocalizedString("You’re low in Magnesium", comment: ""),
                                                          description: NSLocalizedString("Not to worry. You can improve your levels by changing your nutrient intake, whether that’s with food and/or supplements. Be patient because it can take 1-2 weeks to see your levels improve. Click below to see your personalized plan. You got this!", comment: "")))],
                        goalImpacts: [GoalImpact(goalID: 1, impact: 3),
                                    GoalImpact(goalID: 2, impact: 1),
                                    GoalImpact(goalID: 3, impact: 2),
                                    GoalImpact(goalID: 4, impact: 3),
                                    GoalImpact(goalID: 5, impact: 3),
                                    GoalImpact(goalID: 6, impact: 3),
                                    GoalImpact(goalID: 7, impact: 1),
                                    GoalImpact(goalID: 8, impact: 1),
                                    GoalImpact(goalID: 9, impact: 2),
                                    GoalImpact(goalID: 10, impact: 3)
                                    ],
                       goalSources: [GoalSources(goalID: .ENERGY, sources: [
                           Source(url: "https://health.clevelandclinic.org/feeling-fatigued-could-it-be-magnesium-deficiency-and-if-so-what-to-do-about-it/", text: NSLocalizedString("One of the first signs of magnesium deficiency is often fatigue.", comment: "")),
                           Source(url: "https://pubmed.ncbi.nlm.nih.gov/30551349/", text: NSLocalizedString("Magnesium deficiency has been associated with development of chronic fatigue syndrome.", comment: "")),
                           Source(url: "https://pubmed.ncbi.nlm.nih.gov/23247672/", text: NSLocalizedString("Magnesium deficiency is a common cause of fatigue and may contribute to OTS (overtraining syndrome)", comment: "")),
                           Source(url: "https://pubmed.ncbi.nlm.nih.gov/30248967/", text: NSLocalizedString("Magnesium may have long-term benefits in reducing daytime sleepiness in women.", comment: "")),
                           Source(url: "https://pubmed.ncbi.nlm.nih.gov/28757913/", text: NSLocalizedString("Magnesium plays a role in many different mitochondrial biochemical reactions involved in turning food into energy (ATP).", comment: "")),
                           Source(url: "https://pubmed.ncbi.nlm.nih.gov/27458051/", text: NSLocalizedString("Magnesium plays a critical role in cellular energy metabolism and reducing the vulnerability to stress.", comment: "")),
                           Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/21271347/", text: NSLocalizedString("Magnesium supplementation has been shown to improve energy levels and combat fatigue.", comment: "")),
                           Source(url: "https://pubmed.ncbi.nlm.nih.gov/27074515/", text: NSLocalizedString("This article discusses the importance of magnesium intake in regulating human energy balance.", comment: "")),
                           Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/28846654/", text: NSLocalizedString("Good magnesium levels help to reduce lactate accumulation in muscles, thus reducing muscle fatigue during and after exercise.", comment: ""))]),
                     GoalSources(goalID: .CALM, sources: [
                         Source(url: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5452159/", text: NSLocalizedString("This paper found evidence that magnesium improved anxiety levels.", comment: "")),
                         Source(url: "https://pubmed.ncbi.nlm.nih.gov/27869100/", text: NSLocalizedString("This paper explores magnesium as a novel treatment option for anxiety disorders.", comment: "")),
                         Source(url: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5487054/", text: NSLocalizedString("This study found that subjects reported lower levels of depression and anxiety when taking magnesium compared to subjects who did not.", comment: "")),
                         Source(url: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3198864/", text: NSLocalizedString("This animal study demonstrated the robustness and validity of magnesium deficiency in exacerbating anxiety.", comment: "")),
                         Source(url: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3198864/", text: NSLocalizedString("This paper found strong data on the role of magnesium to protect against anxiety among other diseases.", comment: ""))]),
                     GoalSources(goalID: .SLEEP, sources: [
                         Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/9703590", text: NSLocalizedString("Magnesium supplementation significantly relieved symptoms in patients suffering from 2 different sleep disorders.", comment: "")),
                         Source(url: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3703169/", text: NSLocalizedString("This double­blind randomized placebo controlled clinical trial found that magnesium was associated with improved sleep efficiency, sleep time, and sleep onset latency, early morning awakening, and likewise, insomnia objective measures such as concentration of serum renin, melatonin, and serum cortisol, in elderly people.", comment: "")),
                         Source(url: "https://pubmed.ncbi.nlm.nih.gov/1296767/", text: NSLocalizedString("This study found lower magnesium concentration in the brain results in a range of neurological symptoms including insomnia and anxiety.", comment: "")),
                         Source(url: "https://pubmed.ncbi.nlm.nih.gov/1844561/", text: NSLocalizedString("This article reviews the benefits of magnesium in stress-related disorders including insomnia and anxiety.", comment: "")),
                         Source(url: "https://pubmed.ncbi.nlm.nih.gov/21226679/", text: NSLocalizedString("This double-blind, placebo-controlled clinical trial found that the administration of magnesium, melatonin, and zinc improved the sleep quality and quality of life in patients with insomnia.", comment: "")),
                         Source(url: "https://pubmed.ncbi.nlm.nih.gov/31850132/", text: NSLocalizedString("This study found that 3 months of magnesium, melatonin, and vitamin B complex supplementation had a beneficial effect on the treatment of insomnia regardless of the cause.", comment: "")),
                         Source(url: "https://pubmed.ncbi.nlm.nih.gov/11080083/", text: NSLocalizedString("This animal study found that magnesium concentration was associated with improved sleep quality, particularly the improvement of slow-wave (deep) sleep.", comment: "")),
                         Source(url: "https://pubmed.ncbi.nlm.nih.gov/11777170/", text: NSLocalizedString("This animal study found that optimal magnesium concentrations were needed for normal sleep regulation, including achieving the required amount of slow-wave (deep) sleep.", comment: "")),
                         Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/28445426/", text: NSLocalizedString("Magnesium supplementation has been shown to improve symptoms of stress and anxiety including insomnia.", comment: "")),
                         Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/27074515/", text: NSLocalizedString("Magnesium is very important in maintaining normal circadian rhythms and sleep-wake cycles.", comment: "")),
                         Source(url: "https://pubmed.ncbi.nlm.nih.gov/12163983/", text: NSLocalizedString("This study found that magnesium supplementation reverses age-related neuroendocrine and sleep EEG changes in humans.", comment: "")),
                         Source(url: "https://pubmed.ncbi.nlm.nih.gov/9683002/", text: NSLocalizedString("This study found that magnesium supplementation was associated with a significant increase in deep sleep.", comment: "")),
                         Source(url: "https://pubmed.ncbi.nlm.nih.gov/7428773/", text: NSLocalizedString("This study in newborn infants found magnesium supplementation was associated with an increase in deep sleep.", comment: "")),
                         Source(url: "https://pubmed.ncbi.nlm.nih.gov/12635882/", text: NSLocalizedString("This article discusses how magnesium deficiency is associated with dysregulation of biorhythms that are important for sleep.", comment: "")),
                         Source(url: "https://pubmed.ncbi.nlm.nih.gov/17172005/", text: NSLocalizedString("This animal study found that magnesium deficiency decreased melatonin levels, and melatonin is known to be a key regulator of sleep.", comment: "")),
                         Source(url: "https://pubmed.ncbi.nlm.nih.gov/23853635/", text: NSLocalizedString("Supplementation of magnesium appears to improve subjective measures of insomnia such as ISI score, sleep efficiency, sleep time and sleep onset latency, early morning awakening.", comment: "")),
                         Source(url: "https://pubmed.ncbi.nlm.nih.gov/31581561/", text: NSLocalizedString("This study found an association between short sleep duration and inadequate intake of several micronutrients including calcium, magnesium, and vitamin C.", comment: ""))]),
                     GoalSources(goalID: .MOOD, sources: [
                           Source(url: "https://pubmed.ncbi.nlm.nih.gov/28654669/", text: NSLocalizedString("This randomized clinical trial found that magnesium supplementation was safe and effective for mild to moderate depression in adults with effects observed within 2 weeks.", comment: "")),
                           Source(url: "https://pubmed.ncbi.nlm.nih.gov/29897029/", text: NSLocalizedString("This systematic review and meta analysis discusses the benefits of magnesium in treating mood disorders such as depression and bipolar disorder.", comment: "")),
                           Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/25748766/", text: NSLocalizedString("This paper discusses how low dietary magnesium intake was found to be significantly associated with depression.", comment: "")),
                           Source(url: "https://pubmed.ncbi.nlm.nih.gov/19271419/", text: NSLocalizedString("This randomized trial found that magnesium supplementation was safe and effective in the treatment of depression in elderly patients.", comment: "")),
                           Source(url: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3198864/", text: NSLocalizedString("This paper found strong data on the role of magnesium to protect against depression among other diseases.", comment: "")),
                           Source(url: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5487054/", text: NSLocalizedString("This study found that subjects reported lower levels of depression and anxiety when taking magnesium compared to subjects who did not.", comment: "")),
                           Source(url: "https://pubmed.ncbi.nlm.nih.gov/12509067/", text: NSLocalizedString("This study discusses the mechanisms by which magnesium may be helpful in the prevention and treatment of depression.", comment: "")),
                           Source(url: "https://pubmed.ncbi.nlm.nih.gov/16358591/", text: NSLocalizedString("This paper reviews the connection between magnesium levels and symptoms of depression and anxiety.", comment: "")),
                           Source(url: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5891975/", text: NSLocalizedString("This study found significantly decreased concentrations of calcium and magnesium, iron, manganese, selenium, and zinc in patients with major depressive disorder compared with control subjects.", comment: "")),
                           Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/25827510", text: NSLocalizedString("This paper found an association between low magnesium levels and clinical depression.", comment: "")),
                           Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/23238611", text: NSLocalizedString("The results of the study demonstrated an inverse relationship between magnesium intake and depressive symptoms, which persisted even after adjustments for sex, age, body mass index, monthly expenses, close friends, living on campus, smoking (current and former), education, physical activity, and marital status.", comment: "")),
                           Source(url: "https://www.ncbi.nlm.nih.gov/books/NBK507265/", text: NSLocalizedString("This paper suggests that magnesium supplementation is indicated for prevention and treatment of clinical depression and anxiety.", comment: "")),
                           Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/28241991", text: NSLocalizedString("A study in Iran among 60 young men and women (average age 20) with moderate depression and magnesium blood levels at the lower end of normal found that 250 mg of magnesium (from magnesium oxide) taken twice daily for two months modestly reduced symptoms of depression compared to placebo (an average reduction of 16 points vs. 10 points on a scale of 0 - 63). In those who took magnesium, blood levels increased from an average of 1.77 mg/dL to 2.08 mg/dL, while there was no change in magnesium levels in those who took the placebo.", comment: ""))]),
                                     GoalSources(goalID: .FOCUS, sources: [
                           Source(url: "https://bmjopen.bmj.com/content/9/11/e030052", text: NSLocalizedString("A study in the U.S. that followed 6,473 women beginning around 70 years of age for an average of 20 years found that those who consumed between 257 mg and 317 mg of magnesium per day from foods and supplements had a 37% lower risk of developing mild cognitive impairment compared to those who consumed less than 197 mg per day.", comment: "")),
                           Source(url: "https://content.iospress.com/articles/journal-of-alzheimers-disease/jad150538", text: NSLocalizedString("A small study found that men and women with self-reported memory and concentration impairment, anxiety, and difficulty sleeping who received between 1.5 and 2 grams of magnesium-L-threonate daily for three months had an average 10% increase in the speed of performance on an executive function task, while those who took a placebo showed much smaller improvement.", comment: "")),
                           Source(url: "https://pubmed.ncbi.nlm.nih.gov/29991463/", text: NSLocalizedString("This animal study found that magnesium intake was associated with memory enhancement.", comment: "")),
                           Source(url: "https://n.neurology.org/content/89/16/1716", text: NSLocalizedString("This study tracked over 9,500 adults in the Netherlands for about eight years found that those who began the study with the lowest or highest blood levels of magnesium (respectively, 0.79 mmol/L or less and 0.9 mmol/L or greater) were approximately 30% more likely to develop dementia (predominantly Alzheimer's disease) over the course of the study compared to those with mid-range levels (0.84 to 0.85 mmol/L) after adjusting for factors such as age and other diseases.", comment: "")),
                           Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/28952385", text: NSLocalizedString("Among over 6,000 men and women in Taiwan age 50 and older, found that those who were prescribed oral magnesium oxide for the treatment of constipation (average length of usage about 5 months) at the beginning of the study were 48% less likely to develop dementia over a 10 year follow-up period than those who had not taken magnesium oxide, even after adjusting for factors such as age, gender, and other medical conditions. Those who took magnesium oxide for more than one year had an even lower risk — they were 59% less likely to develop dementia.", comment: "")),
                           Source(url: "https://bmjopen.bmj.com/content/9/11/e030052", text: NSLocalizedString("Total Mg intake between the estimated average requirement and the recommended dietary allowances may associate with a lower risk of MCI/PD (mild cognitive impairment/probably dementia)", comment: ""))]),
                                     GoalSources(goalID: .BODY, sources: [
                            Source(url: "https://pubmed.ncbi.nlm.nih.gov/9595544/", text: NSLocalizedString("Zinc, magnesium, vitamins C  and E deficiency were risk factors of higher body per cent and central obesity. It is possible that some Indian men can benefit by increased intake of zinc, magnesium, vitamin C and vitamin E in conjunction with lifestyle changes.", comment: "")),
                            Source(url: "https://pubmed.ncbi.nlm.nih.gov/30518394/", text: NSLocalizedString("The results suggest that magnesium intake is associated with lower BMI, WC (waist circumference) and serum glucose in Mexican population.", comment: "")),
                            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/29793665", text: NSLocalizedString("This study found that giving the same dose and form of magnesium to people with low magnesium levels (below 1.8 mg/dL) and metabolic syndrome, which is a combination of high blood pressure and blood sugar, excess body fat around the waist, and low HDL-c. After four months, only 48% of those given magnesium had metabolic syndrome compared to 77.5% of those given placebo. The treated group experienced significantly greater improvements in blood pressure, fasting glucose, and triglycerides", comment: "")),
                            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/26259506", text: NSLocalizedString("A 2015 analysis of data from the US National Health and Nutrition Examination Survey (NHANES 2001-2010) in 9,148 adults (mean age, 50 years) found a 32% lower risk of metabolic syndrome in those in the highest versus lowest quantile of magnesium intake (≥355 mg/day versus <197 mg/day)", comment: "")),
                            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/24975384", text: NSLocalizedString("Findings from the present meta-analysis suggest that dietary magnesium intake is inversely associated with the prevalence of metabolic syndrome", comment: "")),
                            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/25533010", text: NSLocalizedString("This dose-response meta-analysis indicates that dietary magnesium intake is significantly and inversely associated with the risk of metabolic syndrome.", comment: "")),
                            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/26919891", text: NSLocalizedString("The present systematic review and meta-analysis found an inverse association between Mg intake and MetS (metabolic syndrome).", comment: "")),
                            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/26208810", text: NSLocalizedString("Moreover, lower serum magnesium concentrations have been reported in individuals with metabolic syndrome compared to controls", comment: "")),
                            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/16274367", text: NSLocalizedString("In a study of elderly men and women aged 70-79 years, magnesium intake from food and supplements was associated with a significant increase in bone mineral density (BMD) in white men and women, but not in black men and women. Most people in this study did not have adequate magnesium intake. In white women, getting the recommended amount of 320 mg daily of magnesium was associated with a 2% higher BMD compared to intakes 220 mg or lower. Similarly, in men, intake meeting the recommended amount of 420 mg daily were associated with a 1% higher BMD compared intakes of 320 mg or lower", comment: "")),
                            Source(url: "https://pubmed.ncbi.nlm.nih.gov/25540137/", text: NSLocalizedString("This review provides an extensive and comprehensive overview of Mg(2+) research over the last few decades, focusing on the regulation of Mg(2+) homeostasis in the intestine, kidney, and bone and disturbances which may result in hypomagnesemia.", comment: "")),
                            Source(url: "https://pubmed.ncbi.nlm.nih.gov/31175968/", text: NSLocalizedString("Here, we summarize how optimal magnesium and vitamin D balance improve health outcomes in the elderly, the role of magnesium and vitamin D on bone formation, and the implications of widespread deficiency of these factors in the United States and worldwide, particularly in the elderly population.", comment: "")),
                            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/28631583", text: NSLocalizedString("Higher intake of magnesium (from a combination of food and, if used, supplements) was shown to reduce the risk of bone fracture among older men and women (average age 61) in a study in the U.S. Participants recorded their magnesium intakes and their outcomes were followed for 8 years. Those who reported the highest intakes of magnesium (averaging 491 mg/day for men and 454 mg/day for women) also reported the fewest fractures over the follow-up period. The risk of fracture was 53% and 62% lower, respectively, among men and women with the highest intakes compared to those with the lowest intakes (205 mg/day for men and 190 mg/day for women). It was found that women meeting the RDA for magnesium (350 mg) had a 27% lower risk of fracture than those not meeting the RDA, although no such association was found for men (RDA of 420 mg).", comment: "")),
                            Source(url: "https://pubmed.ncbi.nlm.nih.gov/26135346/", text: NSLocalizedString("This study found an association between higher dietary magnesium intake and bone density.", comment: "")),
                            Source(url: "https://pubmed.ncbi.nlm.nih.gov/29191960/", text: NSLocalizedString("This study found that high-normal magnesium levels were associated with a lower risk of hip fracture in a subgroup of patients with kidney disease.", comment: "")),
                           Source(url: "https://pubmed.ncbi.nlm.nih.gov/29084183/", text: NSLocalizedString("Our study suggests that dietary magnesium may play a role in musculoskeletal health and has relevance for population prevention strategies for sarcopenia, osteoporosis, and fractures.", comment: ""))]),
                                     GoalSources(goalID: .FITNESS, sources: [
                            Source(url: "https://academic.oup.com/ajcn/article/100/3/974/4576609", text: NSLocalizedString("A study in healthy women older than 65 involved in a mild, weekly exercise program found that physical performance improved for those who were given a daily magnesium supplement (300 mg from magnesium oxide) for 12 weeks, compared to those given placebo. Improvements were seen with activities such as the speed of walking and rising from a chair. Although all the women had normal blood levels of magnesium, improvements in physical performance were more evident in participants with magnesium dietary intake lower than the RDA (320 mg for women 31 years and older), which is common among older women, suggesting that some women may still be\"deficient\" despite normal blood levels.", comment: "")),
                            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/31624951", text: NSLocalizedString("A small study among healthy male recreational endurance runners (average age 27) who consumed a diet low in magnesium (< 260 mg per day) found that supplementing with magnesium (166.6 mg taken 3 times a day [500 mg total] from magnesium oxide) for 7 days prior to a timed 10 kilometer downhill treadmill run reduced muscle soreness by 32% in the first 24 hours after the run and by 53% three days after the run in comparison to placebo. In addition, blood levels of a marker of inflammation (IL-6) were lower 24 hours after running when magnesium had been taken versus placebo.", comment: "")),
                            Source(url: "https://onlinelibrary.wiley.com/doi/abs/10.1111/j.1740-8709.2012.00440.x", text: NSLocalizedString("Among pregnant women with leg cramps, a study using 300 mg of magnesium (as magnesium bisglycinate chelate) daily showed significant reductions in the intensity and frequency of leg cramps compared to placebo", comment: "")),
                            Source(url: "https://pubmed.ncbi.nlm.nih.gov/26166051/", text: NSLocalizedString("Because of magnesium's role in energy production and storage, normal muscle function, and maintenance of blood glucose levels, it has been studied as an ergogenic aid for athletes. This article will cover the general roles of magnesium, magnesium requirements, and assessment of magnesium status as well as the dietary intake of magnesium and its effects on exercise performance.", comment: "")),
                            Source(url: "https://pubmed.ncbi.nlm.nih.gov/31996219/", text: NSLocalizedString("Physical training produced a decrease in blood levels of iron, and athletes likely have a higher demand for this nutrient.", comment: "")),
                            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/28846654/", text: NSLocalizedString("This paper suggests that the impact of magnesium on exercise-related fatigue may be related to a reduction/delay in lactate accumulation in muscles.", comment: "")),
                            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/1619184/", text: NSLocalizedString("Magnesium supplementation (8 mg/kg/day) for 7 weeks was shown to improve muscle strength (quadriceps torque) significantly in 26 untrained young adults submitted to a strength training programme, as compared with placebo.", comment: "")),
                            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/25945079/", text: NSLocalizedString("1 week supplementation with 300 mg magnesium/day was reported to significantly increase muscle strength (+ 8% in bench press scores) as compared with baseline measurements, while no significant changes were observed with placebo, in 13 recreational sportspeople.", comment: "")),
                            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/28846654/", text: NSLocalizedString("Data from animal studies suggest that magnesium might improve exercise performance via enhancing glucose availability in the brain, muscle and blood, and reducing/delaying lactate accumulation in muscles, which may delay exhaustion", comment: "")),
                           Source(url: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7019700/#B139-nutrients-12-00228", text: NSLocalizedString("A controlled clinical study where magnesium supplementation (10 mg/kg body weight/day) for 4 weeks attenuated the exercise-induced increase in plasma lactate levels of 30 young Tae-Kwan-do sportsmen.", comment: ""))]),
                                     GoalSources(goalID: .IMMUNITY, sources: [
                           Source(url: "https://pubmed.ncbi.nlm.nih.gov/31196981/", text: NSLocalizedString("Thus, Mg2+ directly regulates the active site of specific kinases during T cell responses, and maintaining a high serum Mg2+ concentration is important for antiviral immunity in otherwise healthy animals.", comment: "")),
                           Source(url: "https://pubmed.ncbi.nlm.nih.gov/18705536/", text: NSLocalizedString("Magnesium deficiency leads to immunopathological changes that are related to the initiation of a sequential inflammatory response. Although in athletes magnesium deficiency has not been investigated regarding alterations in the immune system, the possibility exists that magnesium deficiency could contribute to the immunological changes observed after strenuous exercise.", comment: "")),
                           Source(url: "https://pubmed.ncbi.nlm.nih.gov/16712775/", text: NSLocalizedString("Magnesium deficiency contributes to an exaggerated response to immune stress and oxidative stress is the consequence of the inflammatory response.", comment: "")),
                           Source(url: "https://pubmed.ncbi.nlm.nih.gov/17928798/", text: NSLocalizedString("Clinical observations show the beneficial effect of topical and oral administration of magnesium salts in patients with skin allergy. All the presented data point to an important role of magnesium in allergy reactions.", comment: ""))]),
                                     GoalSources(goalID: .BEAUTY, sources: [
                           Source(url: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4828511/", text: NSLocalizedString("Magnesium, taking part in protein transformation, is responsible for division, growth and ripening processes of cells, taking into consideration its part in immunological reactions, protecting and alleviating inflammation states which causes its deficiency have direct or indirect contribution to hair fall.", comment: "")),
                           Source(url: "https://pubmed.ncbi.nlm.nih.gov/20620759/", text: NSLocalizedString("The chemical profile of the normal nail plate is reviewed with a discussion of its keratin content (hair type keratin vs epithelial type keratin), sulfur content, and mineral composition, including magnesium, calcium, iron, zinc, sodium, and copper. Virtually every nutritional deficiency can affect the growth of the nail in some manner.", comment: "")),
                           Source(url: "https://pubmed.ncbi.nlm.nih.gov/11295157/", text: NSLocalizedString("As evident from animal experiments and epidemiological studies, magnesium deficiency may decrease membrane integrity and membrane function and increase the susceptibility to oxidative stress, cardiovascular heart diseases as well as accelerated aging.", comment: ""))]),
                                     GoalSources(goalID: .DIGESTION, sources: [
                           Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/31587548", text: NSLocalizedString("Our placebo-controlled study demonstrated that MgO was effective treatment for improving defecation status and shortened CTT in Japanese CC patients with mild to moderate symptoms.", comment: "")),
                           Source(url: "https://pubmed.ncbi.nlm.nih.gov/28417897/", text: NSLocalizedString("Patients who received magnesium supplementation experienced less atrial fibrillation, nausea, vomiting, and constipation. Our data showed that oral magnesium supplementation could reduce the postoperative complications", comment: ""))])])
