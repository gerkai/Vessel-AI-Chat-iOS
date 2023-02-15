//
//  VitaminC.swift
//  Vessel
//
//  Created by Carson Whitsett on 10/17/22.
//  ID: 4

import Foundation

let VitaminC = Reagent(
    name: NSLocalizedString("Vitamin C", comment: "Reagent name"),
    unit: NSLocalizedString("mg/L", comment: "unit of measurement"),
    consumptionUnit: NSLocalizedString("mg", comment: "consumption unit"),
    type: .Colorimetric,
    recommendedDailyAllowance: 90,
    imageName: "VitaminC",
    buckets: [
        Bucket(low: 350, high: 1000, score: 100.0, evaluation: .good,
            hint: TitleDescription(title: NSLocalizedString("Your Vitamin C level is great!", comment: ""),
            description: NSLocalizedString("Good job! You’ve filled up your Vitamin C tank, and a slight excess is spilling out into your urine. This is just what you want. Check out the Science section below to see some of the potential benefits you may experience from being in a good range of Vitamin C.", comment: ""))),
        Bucket(low: 0.0, high: 350.0, score: 20.0, evaluation: .low,
            hint: TitleDescription(title: NSLocalizedString("You’re low in Vitamin C", comment: ""),
            description: NSLocalizedString("Not to worry. You can improve your levels by changing your nutrient intake, whether that’s with food and/or supplements. Be patient because it can take 1-3 weeks to see your levels improve. You got this!", comment: "")))],
    goalImpacts: [
        GoalImpact(goalID: 1, impact: 3),
        GoalImpact(goalID: 2, impact: 2),
        GoalImpact(goalID: 3, impact: 1),
        GoalImpact(goalID: 4, impact: 1),
        GoalImpact(goalID: 5, impact: 2),
        GoalImpact(goalID: 6, impact: 1),
        GoalImpact(goalID: 7, impact: 1),
        GoalImpact(goalID: 8, impact: 3),
        GoalImpact(goalID: 10, impact: 1)],
    goalSources: [
        GoalSources(goalID: .ENERGY, sources: [
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/765389", text: NSLocalizedString("Those with low daily Vitamin C intake showed double the amount of fatigue symptoms compared with those with higher daily Vitamin C intake.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3273429/", text: NSLocalizedString("A double blind randomized control trial showing that IV Vitamin C reduced fatigue in office workers.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7019700/", text: NSLocalizedString("Vitamin C is needed for several enzymes involved in energy-yielding metabolism.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC80729/", text: NSLocalizedString("This study found that the first symptom of low vitamin C deficiency is fatigue.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/8623000/", text: NSLocalizedString("In a study where people were deprived of vitamin C in the diet, fatigue was invariably present.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/22677357/", text: NSLocalizedString("This study showed that vitamin C status may influence fatigue, heart rate, and perceptions of exertion during moderate exercise in obese individuals.", comment: ""))]),
        GoalSources(goalID: .CALM, sources: [
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/26353411/", text: NSLocalizedString("This double-blind, randomized, placebo-controlled trial found that a diet rich in vitamin C may be an effective adjunct to medical and psychological treatment of anxiety and improve academic performance.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/24511708/", text: NSLocalizedString("In this randomized single-blind study, vitamin C supplementation at 1,000mg/day led to a significant decrease in anxiety level compared to the control group.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/30074145/", text: NSLocalizedString("Vitamin C has a potential preventative and therapeutic effect on anxiety disorders.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/23885048/", text: NSLocalizedString("This study found that vitamin C administration improved mood and reduced psychological distress in hospitalized patients.", comment: ""))]),
        GoalSources(goalID: .SLEEP, sources: [
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/23992533/", text: NSLocalizedString("This study found that low intake of vitamin C was associated with nonrestorative poor quality sleep.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/31581561/", text: NSLocalizedString("This study found an association between short sleep duration and inadequate intake of several micronutrients including calcium, magnesium, and vitamin C.", comment: ""))]),
        GoalSources(goalID: .MOOD, sources: [
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/25835231/", text: NSLocalizedString("This study found that a high proportion of older patients had suboptimal vitamin C status and this was associated with increased symptoms of depression.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/30074145/", text: NSLocalizedString("Vitamin C has a potential preventative and therapeutic effect on depressive disorders.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/765389/", text: NSLocalizedString("Lower vitamin C consumption was associated with more depressive symptoms such as fatigue.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/24524538/", text: NSLocalizedString("This study of healthy male college students found that lower vitamin C levels were found in people with depression.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/20688474/", text: NSLocalizedString("Study showing an improvement in the emotional state of acutely hospitalized patients after treatment with Vitamin C.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/3015170/", text: NSLocalizedString("Vitamin C is required for the synthesis of the monoamine neurotransmitters dopamine, noradrenaline, and possibly serotonin.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6071228/", text: NSLocalizedString("A cross-sectional study performed in young adult male students in New Zealand shows a potential positive effect of vitamin C supplementation on mood.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/25191573/", text: NSLocalizedString("This study showed a mood improvement in young adult males following supplementation with gold kiwifruit, a high-vitamin C food.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/1106295/", text: NSLocalizedString("Vitamin C is found highly concentrated in the human brain, and the brain is the last organ that is deprived of vitamin C in diets low in vitamin C.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/30012945/", text: NSLocalizedString("This study found that higher vitamin C intake was associated with elevated mood in young adult males.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/23885048/", text: NSLocalizedString("This study found that vitamin C administration improved mood and reduced psychological distress in hospitalized patients.", comment: ""))]),
        GoalSources(goalID: .FOCUS, sources: [
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/6842805/", text: NSLocalizedString("260 noninstitutionalized men and women older than 60 years who had no known physical illnesses and were receiving no medications, were tested for cognitive function . Those low in Vitamin C and B12 scored low for memory and abstract thinking.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/8595334/", text: NSLocalizedString("In a 20 year follow up study of 921 randomly selected elderly people, cognitive function was poorest in those with the lowest vitamin C status, whether measured by dietary intake or plasma ascorbic acid concentration. A high vitamin C intake may protect against both cognitive impairment and cerebrovascular disease.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/9663403/", text: NSLocalizedString("A cohort study performed at a retirement community in Sydney, found that vitamin C supplementation was associated with a lower prevalence of more severe cognitive impairment.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/17508099/", text: NSLocalizedString("3831 residents 65 years of age or older completed a baseline survey that included a food frequency questionnaire and cognitive assessment. Higher vitamin C intake alone and combined with vitamin E were associated with higher scores on the cognitive test.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/14732624/", text: NSLocalizedString("Use of vitamin E and vitamin C supplements in combination is associated with reduced prevalence and incidence of Alzheimer's disease.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/30074145/", text: NSLocalizedString("Vitamin C has a potential preventative and therapeutic effect on Alzheimer’s dementia.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/30012945/", text: NSLocalizedString("This study found that higher vitamin C intake was associated with improved mental clarity in young adult males.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/17508099/", text: NSLocalizedString("This study showed how vitamin C’s antioxidant properties delayed cognitive decline in the elderly.", comment: ""))]),
        GoalSources(goalID: .BODY, sources: [
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/22677357/", text: NSLocalizedString("This study showed that vitamin C status may influence fatigue, heart rate, and perceptions of exertion during moderate exercise in obese individuals.", comment: ""))]),
        GoalSources(goalID: .FITNESS, sources: [
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/22677357/", text: NSLocalizedString("This study showed that vitamin C status may influence fatigue, heart rate, and perceptions of exertion during moderate exercise in obese individuals.", comment: ""))]),
        GoalSources(goalID: .IMMUNITY, sources: [
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/12134712?dopt=Abstract", text: NSLocalizedString("A healthy immune system requires protection against oxidative stress produced by activation of the immune response. Evidence suggests that Vitamin C acts as a potent antioxidant doing just that.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/28353648/", text: NSLocalizedString("Good levels of Vitamin C may help to reduce the duration and severity of the common cold", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/28353648/", text: NSLocalizedString("This review of the scientific literature found evidence for Vitamin C in reducing the duration of the common cold, and for preventing and treating pneumonia.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC80729/", text: NSLocalizedString("Vitamin C levels in neutrophils (an infection-fighting white blood cell) are over 10 times the concentration in plasma, and play a role in protecting these cells from the toxic effects of the compounds they use to destroy infectious pathogens.", comment: ""))]),
        GoalSources(goalID: .BEAUTY, sources: [
            Source(url: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC80729/", text: NSLocalizedString("Vitamin C is a cofactor for multiple enzymes involved in collagen hydroxylation.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/28805671", text: NSLocalizedString("Strong skin: Good levels of Vitamin C may support healthy skin (through increased collagen production). Vitamin C may also afford protection against UV irradiation.", comment: ""))])],
    moreInfo: [
        TitleDescription(
            title: Constants.HOW_TO_READ_THE_GRAPH,
            description: NSLocalizedString("Here are the reference ranges we use for Vitamin C:\nLow: 0 - 240 mg/L\nGood: 240 - 800 mg/L\nHigh: >800 mg/L\n\nVitamin C is absorbed via a sodium-dependent transport mechanism in the small intestine. Body stores are largely intracellular and saturate in adults at a level of approximately 3 grams. Most studies have found that the maximum amount of vitamin C that can be absorbed orally is about 500mg/day.  Vitamin C is stored throughout the body and in very high concentrations in white blood cells that fight infection.\n\nVitamin C has a half-life of 16-20 days in tissue. Assuming a tissue level of 5000 mg, a lack of vitamin C in the diet for 16 days would reduce the tissue stores to about 2500 mg; in 32 days it would be about 1250 mg; in 44 days it would be 625 mg and in 64 days it would be about 313 mg and clinical signs of scurvy should start to develop.\n\nIf people consume more Vitamin C than they need, plasma (blood) levels rise and when they reach 80 - 170 mg/L further intake leads to rapid clearance of vitamin C in the urine. On the other hand, if people are vitamin C deficient, very little vitamin C appears in the urine after a test dose. Studies found that people on a regular diet without illness or severe stress excrete about 200 - 300mg/L each day in their urine. Some experts recommend that with optimal vitamin C intake, urine vitamin C concentration should be 400mg/L or higher.\n\nWhen you’re in the good zone (darker purple), your body is getting sufficient vitamin c to support your wellness.\n\nToo high means you may be getting more than you need. Although there isn’t much evidence of danger from high levels of vitamin c, it could cause diarrhea.\n\nToo low means your kidneys are holding on to vitamin C, and little is excreted in your urine. In this case, you might want to up your intake. Check out the recommendations in the app for how to do that.", comment: "")),
        TitleDescription(
            title: Constants.WHY_IT_MATTERS,
            description: NSLocalizedString("Vitamin C is an essential vitamin that we cannot make on our own and must get from our diet. It is involved in the biosynthesis of collagen, L-carnitine, and even neurotransmitters. Healthy collagen is important for healthy skin and wound healing. Vitamin C is also a powerful antioxidant and can even regenerate other antioxidants in the body like vitamin E. As an antioxidant, it fights off free radicals, which are a common pathway of cellular aging and chronic disease.\n\nSeveral studies have shown surprisingly high rates of vitamin C deficiency in healthy individuals. Many studies have recommended that the recommended dietary allowance of vitamin C be significantly increased to around 200mg/day because of the multiple health benefits of this essential vitamin.", comment: "")),
        TitleDescription(
            title: Constants.TIPS_TO_IMPROVE,
            description: NSLocalizedString("The best way to improve your vitamin C levels is with fresh whole foods. Some people may benefit from additional vitamin c in the form of supplementation.\n\nHere’s how we make your food and supplement suggestions. Every 5 years the US government has a team of scientific experts reviewing the literature on nutrition and health to determine the recommended daily intake (RDI) of many different micronutrients and publish this information for free to the public. We start here as the foundation for our recommendations. We then build upon this to customize recommendations for each user based on their Vessel test results. To determine this formula we take into account the expert opinion of our medical and scientific board of doctors, scientists, and registered dietitians looking at the medical evidence for the risks and benefits of being high vs low in a certain nutrient. For example, if a nutrient could be dangerous at high levels (such as potassium), we would never suggest higher than the US recommended daily intake (RDI).", comment: ""))])
