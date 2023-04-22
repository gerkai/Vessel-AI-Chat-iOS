//
//  Ketones.swift
//  Vessel
//
//  Created by Carson Whitsett on 10/17/22.
//  ID: 3

import Foundation

let Ketones = Reagent(
    name: NSLocalizedString("Ketones", comment: "Reagent name"),
    unit: NSLocalizedString("mmol/L", comment: "unit of measurement"),
    consumptionUnit: NSLocalizedString("", comment: "consumption unit"),
    type: .Colorimetric,
    recommendedDailyAllowance: nil,
    imageName: "Ketones",
    buckets: [
        Bucket(low: 2.21, high: 8.81, score: 0, evaluation: .ketoHigh,
               hint: TitleDescription(
                title: NSLocalizedString("Your Ketone levels are elevated.", comment: ""),
                description: NSLocalizedString("Long periods of intermittent fasting, exercising regularly or testing with a Vessel card shortly after exercise may show an elevated reading. High ketones may also be a sign of diabetic ketoacidosis (DKA), a life-threatening condition associated with Type 1 Diabetes or alcoholism. We recommend speaking with your primary care doctor if you continue to receive a high ketone level", comment: ""),
                variation: NSLocalizedString("Good job! The diet is working and your body is switching to ketone bodies as its primary fuel source. If you’re not on a ketogenic diet please check in with your doctor as this could be a sign of an underlying disease. Check out the Science section below to see some of the potential benefits you may experience from being in a good range for Ketones", comment: ""))),
        Bucket(low: 0.0, high: 2.21, score: 0.0, evaluation: .ketoLow,
               hint: TitleDescription(
                title: NSLocalizedString("Your Ketone levels are low.", comment: ""),
                description: NSLocalizedString("Not to worry, this is completely normal for those who are not on a ketogenic diet. Low ketones means your body is efficiently using glucose as its primary source of fuel. Keep up the good work!", comment: ""),
                variation: NSLocalizedString("Ketones can be beneficial for improved focus, healthy weight management, increased energy, and a balanced mood through increasing your metabolic machinery in your cells to more efficiently burn fat for fuel. Achieving a \"good\" or \"high\" ketone reading on your Vessel Wellness card requires increased attention to your diet. Ketones are produced when carbohydrate intake is very low, typically 20-50g/day, healthy fat intake is high, roughly 70% of caloric intake, and protein intake is moderate. Consume food such as avocado, olive oil, salmon, hemp seeds and lean protein. Keep in mind that it can take several weeks to a month to increase ketone levels.", comment: "")))],
    goalImpacts: [
        GoalImpact(goalID: 1, impact: 1),
        GoalImpact(goalID: 2, impact: 1),
        GoalImpact(goalID: 3, impact: 1),
        GoalImpact(goalID: 5, impact: 2),
        GoalImpact(goalID: 6, impact: 3)],
    goalSources: [
        GoalSources(goalID: .ENERGY, sources: [
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
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/28043175/", text: NSLocalizedString("This paper reviews the promising potential role of ketones in treating inflammatory dermatologic diseases.", comment: ""))])],
    moreInfo: [
        TitleDescription(
            title: Constants.HOW_TO_READ_THE_GRAPH,
            description: NSLocalizedString("This graph shows you your test dates and where your urine ketone levels fall in our defined ranges of low, good, and high. If you click on the individual test circles, you can see the actual value of urine ketones in mmol/L.\n\nNutritional ketosis starts at 0.5 mmol/L, called light nutritional ketosis, and is a good starting point for beginners.\n\nFrom there, aim for “optimal nutritional ketosis,” which is when your ketone levels are between 1.0 mmol/L-3.0 mmol/L, which is the goal for most people.\n\nSometimes people choose a ketogenic diet for therapeutic benefits for conditions such as epilepsy, cancer, and metabolic disorders. The goals in these cases are often higher, in the range of 3.0 mmol/L to 5.0 mmol/L called “heavy nutritional ketosis”. Please only attempt this under a doctor’s supervision.\n\nLevels over 5.0mmol/L are higher than what you need to get the benefits of nutritional ketosis, and levels over 10.0 mmol/L can be a sign of something dangerous called ketoacidosis, which is usually seen in people with Type I diabetes or severe alcoholism.", comment: "")),
        TitleDescription(
            title: Constants.WHY_IT_MATTERS,
            description: NSLocalizedString("Typically, your body burns glucose (sugar) for energy. When you cut carbs a LOT and replace the calories with fat and some protein, your body makes a metabolic shift to use Ketones (aka ketone bodies) as the main fuel instead of glucose. There are three types of ketone bodies that the liver makes, acetoacetate, which accounts for about 20% of total ketones, Beta HydroxyButyrate, which accounts for about 78% of total ketones, and Acetone which accounts for about 2% of total ketones. Being in a state of nutritional ketosis often leads to improved brain function, clearer thoughts, more energy, in addition to fat loss and improvements in cholesterol, among other things. Urine ketone measurements can also be an indicator of how well you’re doing with intermittent fasting, also called time-restricted eating, which has many additional health benefits.\n\nCurrently, we measure acetoacetate in the urine and are in the process of finalizing our beta-hydroxybutyrate test.\n\nIn rare cases, severely elevated ketones can lead to diabetic ketoacidosis (DKA), a life-threatening condition associated with Type I Diabetes that can lead to coma or even death.", comment: "")),
        TitleDescription(
            title: Constants.TIPS_TO_IMPROVE,
            description: NSLocalizedString("If you’re not trying to be on a state of ketosis, you don’t need to change anything to improve your urine ketone levels.\n\nHowever, if you want to be in a state of nutritional ketosis, the best way is through changing your diet.\n\nStart by calculating your “macros” which are the amounts of different macronutrients (fats, proteins, carbs) to consume each day based on your goals. The easiest way to do this is to use a free online macro calculator such as https://perfectketo.com/keto-macro-calculator/\n\nIn general, ketogenic diets consist of about 75% fat, 20% protein, and 5% carbs. Most sources recommend having a maximum of 20g net carbs per day. Net carbs are the total carbs minus the fiber (minus sugar alcohols if applicable). For example, 1 cup of chopped bell pepper has 9 grams of carbs and 3 grams of fiber. The net carbs would be 6 grams in this case. Sugar alcohols are sometimes used in keto recipes to add sweetness without carbs. One of the best is erythritol, a sugar alcohol that has no carbs and doesn’t affect sugar levels.\n\nWhen you first transition into ketosis you’re likely to experience what’s called “keto flu” which can have you feeling tired, dizzy, nauseated, and with brain fog. This can last anywhere from a couple of days to a couple of weeks. Hang in there because it doesn’t last forever! After you get through this, you’ll start to experience the benefits that most people report with nutritional ketosis such as more energy, clearer, and sharper mind, the absence of sugar and carb cravings, and fat loss.\n\nWhen you test, it’s important to be consistent about when you test each day. Ideally, you’d test two hours after waking up (while fasted) to get your baseline, and again 2 hours after meals.", comment: ""))])
