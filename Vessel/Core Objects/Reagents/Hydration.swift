//
//  Hydration.swift
//  Vessel
//
//  Created by Carson Whitsett on 10/17/22.
//  ID: 2

import Foundation

let Hydration = Reagent(
    name: NSLocalizedString("Hydration", comment: "Reagent name"),
    unit: NSLocalizedString("sp gr", comment: "unit of measurement"),
    consumptionUnit: NSLocalizedString("sp gr", comment: "consumption unit"),
    type: .Colorimetric,
    recommendedDailyAllowance: nil,
    imageName: "Hydration",
    buckets: [
        Bucket(low: 1.0, high: 1.0015, score: 80.0, evaluation: .high,
            hint: TitleDescription(title: NSLocalizedString("You’re over-hydrated", comment: ""),
            description: NSLocalizedString("Oops, you overshot your goal. Your urine is very diluted with water. Try consuming more electrolytes. The best way to do this is by eating more balanced meals that include plenty of fresh fruits and vegetables. Check out your Vessel food recommendations for personalized food recommendations.", comment: ""))),
        Bucket(low: 1.0015, high: 1.006, score: 100.0, evaluation: .good,
            hint: TitleDescription(title: NSLocalizedString("Your body is well hydrated", comment: ""),
            description: NSLocalizedString("Good job! You’re getting enough water to help your body function at its best. Keep up the good work! Check out the Science section below to see some of the potential benefits you may experience from being well hydrated.", comment: ""))),
        Bucket(low: 1.006, high: 1.015, score: 80.0, evaluation: .low,
            hint: TitleDescription(title: NSLocalizedString("You're under hydrated", comment: ""),
            description: NSLocalizedString("You can improve your hydration level by changing your daily water intake. You should start to see results in 1-2 days so you may want to re-test to make sure you’re hitting your target. You got this!", comment: ""))),
        Bucket(low: 1.015, high: 1.031, score: 20.0, evaluation: .veryLow,
            hint: TitleDescription(title: NSLocalizedString("You’re dehydrated", comment: ""),
            description: NSLocalizedString("Not to worry. You can improve your hydration level by changing your daily water intake. You should start to see results in 1-2 days so you may want to re-test to make sure you’re hitting your target. You got this!", comment: "")))],
    goalImpacts: [
        GoalImpact(goalID: 1, impact: 1),
        GoalImpact(goalID: 2, impact: 3),
        GoalImpact(goalID: 3, impact: 1),
        GoalImpact(goalID: 4, impact: 1),
        GoalImpact(goalID: 5, impact: 3),
        GoalImpact(goalID: 6, impact: 2),
        GoalImpact(goalID: 7, impact: 1),
        GoalImpact(goalID: 9, impact: 3),
        GoalImpact(goalID: 10, impact: 3)],
    goalSources: [
        GoalSources(goalID: .ENERGY, sources: [
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/26290294", text: NSLocalizedString("This review suggests that even slight dehydration has a negative impact on mood, fatigue, and alertness.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/20336685", text: NSLocalizedString("This study found that inadequate hydration was associated with mental and physical sedation.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/24728141", text: NSLocalizedString("This study found that restricting water intake led to a significant decrease in energy levels, contentedness, calmness, and positive emotions.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/22716932", text: NSLocalizedString("This study found significantly greater fatigue and lower vigor ratings as fluid intake was decreased.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/22190027", text: NSLocalizedString("In this study, dehydrated subjects reported increased fatigue, decreased vigor-activity, and increased anger and hostility.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/21736786", text: NSLocalizedString("This study found that dehydration resulted in increased fatigue, tension, and anxiety.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/17167858", text: NSLocalizedString("This study found more fatigue after 15 hours of fluid deprivation.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/15182398", text: NSLocalizedString("In this study, dehydrated subjects reported decreased alertness, reduced ability to concentrate, and more headaches.", comment: "")),
            Source(url: "https://www.health.harvard.edu/healthbeat/fight-fatigue-with-fluids", text: NSLocalizedString("Water is essential for carrying nutrients to your body's cells and taking away waste products. Roughly 50% to 60% of your body weight is water, yet you constantly lose water through urine, sweat, and breathing. When you are low on fluids, your body may feel tired and weaker than usual.", comment: ""))]),
        GoalSources(goalID: .CALM, sources: [
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/27510536", text: NSLocalizedString("This study found that subjects who consumed more water performed better on tests of episodic memory and focused attention, and had decreased anxiety ratings compared to those who drank less water.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/24728141", text: NSLocalizedString("This study found that restricting water intake led to a significant decrease in contentedness, calmness, and positive emotions.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/15725492/", text: NSLocalizedString("Hydration has an impact on vital signs including heart rate, blood pressure, and cardiac output which are vital to a sense of calm.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/22190027", text: NSLocalizedString("In this study, dehydrated subjects reported increased fatigue, decreased vigor-activity, and increased anger and hostility.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/21736786", text: NSLocalizedString("This study found that dehydration resulted in increased tension and anxiety.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/11895329", text: NSLocalizedString("This study found lower levels of calmness in subjects who were denied access to water for a short amount of time.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/25379428/", text: NSLocalizedString("Brain volume and its impact on mood are extremely variable with comparison of hydrated and dehydrated individuals.  Multiple disease states and the course of these diseases are impacted by levels of hydration. Water restriction is associated with an inflammatory response throughout the body.", comment: ""))]),
        GoalSources(goalID: .SLEEP, sources: [
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/30395316/", text: NSLocalizedString("In adults, inadequate hydration was associated with shorter sleep duration. Consider improving hydration status to improve sleep duration.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/28255913/", text: NSLocalizedString("Sleep apnea is a growing issue amongst adults. Much of this is due to the epidemic of obesity. Adequate hydration status plays a role in muscle tone and body composition which has an impact on sleep apnea severity.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/29411452/", text: NSLocalizedString("Dehydration is associated with several alterations in body homeostasis involving both physiological and mental aspects. Dehydration has a negative impact on subjective sleep quality. Many studies have shown that dehydration worsens both sleep quality and duration in young healthy adults.", comment: ""))]),
        GoalSources(goalID: .MOOD, sources: [
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/26290294", text: NSLocalizedString("This review suggests that even slight dehydration has a negative impact on mood, fatigue, and alertness.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/24480458", text: NSLocalizedString("This review found that adequate hydration is important for improving mood especially in children and the elderly.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/31146326/", text: NSLocalizedString("This study showed how people who were dehydrated had worsened mood, memory, attention span, and reaction time. All of these are critical to both mood and daily performance.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6356561/#B38-nutrients-11-00070", text: NSLocalizedString("This study found a dose-response effect of additional water intake on cognitive performance and mood in children and adults.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/19835921", text: NSLocalizedString("This study found significant positive changes in happiness ratings with children consuming more water.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/24728141", text: NSLocalizedString("This study found that restricting water intake led to a significant decrease in contentedness, calmness, and positive emotions.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/31146326/", text: NSLocalizedString("Drinking enough water is known to benefit cognitive functioning.  Being well hydrated improves memory and focused attention.  Well hydrated individuals are more likely to have more energy and experience less anxiety and depression.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/26950346/", text: NSLocalizedString("In athletes, hydration is CRITICAL.  Inadequate hydration is associated with problematic attitudes and behaviors, and even serious health consequences such as death during activity.  , including potential fatalities, could occur during activity.  Overall attitude and behavior is  impacted by levels of hydration.  It is expected that hydration demands on athletes is likely much higher than average non-athletic individuals, but the same outcomes are experienced in terms of mood, behavior, and performance.", comment: ""))]),
        GoalSources(goalID: .FOCUS, sources: [
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/28828079/", text: NSLocalizedString("This paper discusses how hydration may be linked to improving cognitive performance in athletes.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/26290294", text: NSLocalizedString("This review suggests that even slight dehydration has a negative impact on mood, fatigue, and alertness.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/24480458", text: NSLocalizedString("This review found that adequate hydration is important for improving cognition especially in children and the elderly.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6356561/#B38-nutrients-11-00070", text: NSLocalizedString("This study found a dose-response effect of additional water intake on cognitive performance and mood in children and adults.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/29277553", text: NSLocalizedString("This study found that water deprivation in adults increased errors for tests for visual memory, working memory, executive functioning, and spatial problem-solving tasks.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/27825957", text: NSLocalizedString("This study found that visual attention and working memory improved in a dose-dependent manner as subjects drank more water.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/27510536", text: NSLocalizedString("This study found that subjects who consumed more water performed better on tests of episodic memory and focused attention, and had decreased anxiety ratings compared to those who drank less water.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/15182398", text: NSLocalizedString("In this study, dehydrated subjects reported decreased alertness, reduced ability to concentrate, and more headaches.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/26271221", text: NSLocalizedString("This study found that improving hydration in children improved measures of verbal memory and sustained attention.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6356561/#B41-nutrients-11-00070", text: NSLocalizedString("This study found that children performed better on tasks testing visual attention and fine motor skills when given more water to drink.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6356561/#B42-nutrients-11-00070", text: NSLocalizedString("This study found that 84% of children were dehydrated at the start of the school day based on urine testing and that drinking water improved short-term memory and verbal reasoning.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/19501780", text: NSLocalizedString("This study found that children who drank additional water performed better on tasks of visual attention and memory.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/19445987", text: NSLocalizedString("This study found that immediate memory was significantly better in children after the consumption of more water.", comment: ""))]),
        GoalSources(goalID: .BODY, sources: [
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/26729162", text: NSLocalizedString("This paper found that drinking water increases energy expenditure (more calories burned) and fat oxidation in obese individuals.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/26237305/", text: NSLocalizedString("This study found that obese subjects who drank 500mL more water 30 minutes before meals  lost 1.3 kg more than the control group at 12 weeks.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/32224908/", text: NSLocalizedString("This paper found that underhydration is associated with obesity, chronic disease, and death within 3-6 years in the U.S. population aged 51 - 70 years.", comment: "")),
            Source(url: "http://www.sciencedaily.com/releases/2010/07/100706150639.htm", text: NSLocalizedString("Good hydration levels may be associated with healthy weight loss.", comment: ""))]),
        GoalSources(goalID: .FITNESS, sources: [
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/17921473/", text: NSLocalizedString("This paper reviews how dehydration can lead to reduced mental and physical performance.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/30450056/", text: NSLocalizedString("This paper reviews how acute dehydration impairs endurance in athletes.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/32059577/", text: NSLocalizedString("This study found that dehydration led to impaired neuromuscular functioning in cycling exercise.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/31728846/", text: NSLocalizedString("Inadequate hydration prior to exercise impairs aerobic exercise performance.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/22692532/", text: NSLocalizedString("Adequate hydration may be associated with improved exercise tolerance, endurance, and performance.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/24692140/", text: NSLocalizedString("Adequate hydration may be associated with improved exercise tolerance, endurance and performance", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/26553489/", text: NSLocalizedString("Adequate hydration may be associated with improved exercise tolerance, endurance and performance.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6407543/", text: NSLocalizedString("Water intake after dehydration makes muscles more susceptible to electrical simulation-induced muscle cramp, probably due to dilution of electrolytes", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3445088/", text: NSLocalizedString("Dehydration/electrolyte and neuromuscular causes are the most widely discussed theories for the cause of exercise associated muscle cramps.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC1150229/", text: NSLocalizedString("Consumption of a carbohydrate-electrolyte beverage before and during exercise in a hot environment may delay the onset of Exercise associated muscle cramps, thereby allowing participants to exercise longer.", comment: ""))]),
        GoalSources(goalID: .BEAUTY, sources: [
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/29392767", text: NSLocalizedString("This study found that additional water intake is associated with increased skin hydration and reduced skin dryness.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/26345226/", text: NSLocalizedString("This paper discusses how dietary water affects human skin hydration and biomechanics.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/26058417/", text: NSLocalizedString("This paper discusses how water intake is associated with healthy skin.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/16827695/", text: NSLocalizedString("This study found that adding 2L/water each day led to an improvement in skin hydration and function.", comment: ""))]),
        GoalSources(goalID: .DIGESTION, sources: [
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/28450053", text: NSLocalizedString("This review found that a lower intake of fluids was associated with constipation.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/14681719#", text: NSLocalizedString("Inadequate hydration is associated with constipation.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/9684123", text: NSLocalizedString("This study found that fluid intake was associated with more bowel movements and less laxative use in adults with chronic constipation.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/2288138", text: NSLocalizedString("This study found that stool weight and frequency decreased with fluid restriction.", comment: ""))])],
    moreInfo: [
        TitleDescription(
            title: Constants.HOW_TO_READ_THE_GRAPH,
            description: NSLocalizedString("We use a urine marker called specific gravity (SG) to track your hydration.\n\nThe lower your specific gravity, the more hydrated you are, and the higher your specific gravity, the more dehydrated you are.\n\nWhen you look at the graph, a low level suggests dehydration, and a high level suggests overhydration.\n\nIf you’re over hydrated (low zone on the graph), we might suggest that you cut back on your H20 intake and add in more electrolytes.\n\nIf you’re dehydrated (high zone on the graph), we will suggest how many more 8oz glasses of water you need each day to get into the sweet spot.", comment: "")),
        TitleDescription(
            title: Constants.WHY_IT_MATTERS,
            description: NSLocalizedString("Maintaining optimal hydration throughout the day is important for many bodily functions, including mood, brain function, gastrointestinal function, energy levels, and even weight loss!\n\nSpecific gravity, in combination with other urinary findings, is a way to get important information about your organ function and general hydration levels.\n\nYour urine contains water, minerals, and toxins or waste products that have been filtered by the kidneys. The specific gravity gives you a measure of how much stuff vs. water is in your urine.\n\nPure water has a specific gravity of 1.000. It is normal and healthy to have some minerals and waste in your urine, so the normal range is above 1.000 at 1.010 - 1.035. Values higher than 1.035 indicate there is a lot of dissolved minerals and waste in your urine and you are dehydrated. If you have been drinking too much water, your specific gravity will be close to 1.000.\n\nReferences:\nKleiner SM1. Water: an essential but overlooked nutrient. J Am Diet Assoc. 1999 Feb;99(2):200-6. PMID 9972188", comment: "")),
        TitleDescription(
            title: Constants.TIPS_TO_IMPROVE,
            description: NSLocalizedString("Water is the most abundant molecule in our body, making up 70% of each cell. This is why hydrating with mineral water is the best way to truly hydrate. Beverages that contain other molecules like sugar, caffeine, proteins, flavorings, or dyes do not count toward your daily goal.\n\nTo find out how much water to add or subtract to your normal daily H20 intake.\n\nIf you find yourself forgetting to drink throughout the day, here are a few tips for staying hydrated.\n\nGet your water in first thing when you wake up, aim to drink 16-20 ounces of water before you head out for the day.\n\nUse your phone to set timers and reminders.\n\nUse a water bottle that you love - get one that is convenient to carry, attractive to look at, and easy to drink from. Keep this next to your working space, staying in sight.\n\nAdd something special to spruce it up - some cucumber slices, fresh mint, a squeeze of lime.\n\nAvoid artificial flavorings that add chemicals and sweeteners.\n\nCheck out your recommendations in our lifestyle section to see how much more water you should be drinking based on your specific gravity and other lab findings.", comment: ""))])
