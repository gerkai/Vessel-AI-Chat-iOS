//
//  Cortisol.swift
//  Vessel
//
//  Created by Carson Whitsett on 10/17/22.
//  ID: 8

import Foundation

let Cortisol = Reagent(
    name: NSLocalizedString("Cortisol", comment: "Reagent name"),
    unit: NSLocalizedString("µg/L", comment: "unit of measurement"),
    consumptionUnit: NSLocalizedString("sp gr", comment: "consumption unit"),
    type: .LFA,
    recommendedDailyAllowance: nil,
    imageName: "Cortisol",
    buckets: [
        Bucket(low: 150.0, high: 405.0, score: 40.0, evaluation: .high,
           hint: TitleDescription(
                title: NSLocalizedString("Your Cortisol levels are high", comment: ""),
                description: NSLocalizedString("This is usually a sign that your body has mounted a stress response to protect you. This can (and should) happen if you’re sick, have an an injury that is healing, or just did a strenuous workout. However levels should normalize shortly after, so keep checking. Levels are often high due to acute stress, so be sure to check out the lifestyle recommendations below to reduce stress and increase your natural relaxation response.", comment: ""))),
        Bucket(low: 50.0, high: 150.0, score: 100.0, evaluation: .good,
           hint: TitleDescription(
                title: NSLocalizedString("Your Cortisol level is great!", comment: ""),
                description: NSLocalizedString("Good job! Your cortisol levels are in the sweet spot. This is just what you want.  Keep up the good work! Check out the Science section below to see some of the potential benefits you may experience from being in a good range for Cortisol.", comment: ""))),
        Bucket(low: 0.0, high: 50.0, score: 80.0, evaluation: .low,
           hint: TitleDescription(
                title: NSLocalizedString("Your Cortisol level is low.", comment: ""),
                description: NSLocalizedString("This might be a sign that your body has experienced a high amount of stress for a long period of time, and your adrenal glands may have difficulty creating enough cortisol.  Take a look at your personalized lifestyle recommendations to find out some ways to get your cortisol back in the normal range.  Be patient because it can take several months to see your levels improve. Click below to see your personalized plan. You got this!", comment: "")))],
    goalImpacts: [GoalImpact(goalID: 1, impact: 3),
                   GoalImpact(goalID: 2, impact: 2),
                   GoalImpact(goalID: 3, impact: 3),
                   GoalImpact(goalID: 4, impact: 3),
                   GoalImpact(goalID: 5, impact: 3),
                   GoalImpact(goalID: 6, impact: 3),
                   GoalImpact(goalID: 7, impact: 1),
                   GoalImpact(goalID: 8, impact: 2),
                   GoalImpact(goalID: 9, impact: 1),
                   GoalImpact(goalID: 10, impact: 1)],
    goalSources: [
        GoalSources(goalID: .ENERGY, sources: [
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/19497676/", text: NSLocalizedString("This paper reviews the association between fatigue and cortisol secretion.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed?term=6369931", text: NSLocalizedString("This paper reviews the psychiatric implications of abnormal cortisol levels including its role in energy levels.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/15950390/", text: NSLocalizedString("This paper reviews the signs and symptoms of stress-induced cortisol dysfunction including fatigue, depression, and memory impairment.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/20403505/", text: NSLocalizedString("In this study of 121 middle-aged adults, a blunted cortisol awakening response was predictive of fatigue later that day.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/19120092/", text: NSLocalizedString("This paper reviews some of the connections between cortisol levels and energy.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/15950390/", text: NSLocalizedString("This paper reviews how chronic stress can eventually lead to low cortisol levels, which are associated with fatigue and stress-related disorders.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/21315796/", text: NSLocalizedString("This meta-analysis reviews the association between cortisol levels and chronic fatigue syndrome.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/29719288", text: NSLocalizedString("This study reviews how good cortisol levels may help provide your body and brain with additional energy when you need it most.", comment: "")),
            Source(url: "https://www.physiology.org/doi/abs/10.1152/ajpendo.1989.257.1.e35", text: NSLocalizedString("This article reviews how cortisol leads to increased energy availability during times of stress.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed?term=25098712", text: NSLocalizedString("This paper reviews some of the connections between chronic low cortisol levels and anemia, a common cause of fatigue.", comment: ""))]),
        GoalSources(goalID: .CALM, sources: [
            Source(url: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4263906/", text: NSLocalizedString("This paper reviews how chronic stress leads to dysfunction in cortisol secretion.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/11454437/", text: NSLocalizedString("This paper reviews how abnormal cortisol levels contribute to the development of stress-related disorders.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/10633533/", text: NSLocalizedString("This paper reviews the potential role of cortisol in stress management and stress related disorders.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/12377295/", text: NSLocalizedString("This paper reviews the connections between stress and cortisol levels.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/15950390/", text: NSLocalizedString("This paper reviews how chronic stress can eventually lead to low cortisol levels, which are associated with fatigue and stress-related disorders.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2474765/", text: NSLocalizedString("This paper reviews the effects of stress hormones such as cortisol in human health and disease.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/8552738/", text: NSLocalizedString("This study found that repeated exposure to stressful experiences lowered cortisol levels.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/2831028/", text: NSLocalizedString("This paper describes how the body turns off the stress response when the perceived stress is resolved.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/16423710/", text: NSLocalizedString("This paper reviews the role of stress and stress hormones in chronic anxiety.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed?term=2994590", text: NSLocalizedString("This paper reviews the connection between abnormal cortisol secretion and anxiety and depression.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/19822172/", text: NSLocalizedString("This article reviews the role of chronic stress biomarkers such as cortisol and chronic disease.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/27995346/", text: NSLocalizedString("In this randomized controlled trial, deep breathing led to a reduction in self-reported stress as well as a reduction in cortisol levels.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5455070/", text: NSLocalizedString("In this study diaphragmatic breathing participants had significantly lower cortisol levels than the control group.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/20617660/", text: NSLocalizedString("In this randomized controlled trial, deep breathing therapy reduced stress and cortisol levels.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/11218923/", text: NSLocalizedString("In this clinical trial, 2 different yoga relaxation techniques reduced stress and anxiety levels in participants.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/16838123/", text: NSLocalizedString("In this study of healthy volunteers, yin yoga led to a greater depth of relaxation when compared to resting alone.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/19735239/", text: NSLocalizedString("This paper reviews the benefits of yin yoga in the treatment of stress related illness such as depression, anxiety, and PTSD.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/20634635/", text: NSLocalizedString("In this controlled clinical trial, a deep breathing intervention lowered stress and anxiety levels in pregnant women in preterm labor.", comment: ""))]),
        GoalSources(goalID: .SLEEP, sources: [
            Source(url: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7039028/", text: NSLocalizedString("This study found that having good sleep hygiene, including a nighttime routine, led to lower cortisol levels.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/1334495", text: NSLocalizedString("This study reviews the impact of long term poor sleep on cortisol levels.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/9720852/", text: NSLocalizedString("In this controlled clinical trial urine cortisol levels were significantly increased when subjects didn’t get enough sleep.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/11502812/", text: NSLocalizedString("In this controlled clinical trial insomnia was associated with significantly higher urinary cortisol levels.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/10468992/", text: NSLocalizedString("Higher amounts of deep (slow wave) sleep was associated with reduced urinary cortisol levels.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/6822642/", text: NSLocalizedString("This paper reviews how getting enough sleep inhibits cortisol secretion in healthy young men.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/9415946/", text: NSLocalizedString("This paper reviews how sleep loss results in an elevation in cortisol levels the following day.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4914363/", text: NSLocalizedString("This study found that sleep quality is more important in reducing cortisol levels than sleep quantity.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6988893/", text: NSLocalizedString("This paper reviews the evidence of sleep hygiene in improving sleep quality in athletes.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/28674597/", text: NSLocalizedString("This study found that educating elite female athletes in good sleep hygiene, including a bedtime routine, improved sleep quality.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/10543671", text: NSLocalizedString("Sleep deprivation led to increased cortisol levels in the afternoon and evening in healthy young men.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/26679739/", text: NSLocalizedString("This study found that sleep problems predict cortisol reactivity to stress.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/27147608/", text: NSLocalizedString("This study found that workers with habitual changes in their shift rotations, and thus in their sleep patterns, have physical inactivity, overweight, sleep deprivation, increased cortisol secretion, and higher inflammation.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/21350389/", text: NSLocalizedString("This study found that nighttime shift workers had higher cortisol levels, fatigue, and worse sleep quality and attention.", comment: ""))]),
        GoalSources(goalID: .MOOD, sources: [
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/15950390/", text: NSLocalizedString("This paper reviews the signs and symptoms of stress-induced cortisol dysfunction including fatigue, depression, and memory impairment.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/11454437/", text: NSLocalizedString("This paper reviews the connections between stress, cortisol secretion, and  development of depression, PTSD, and stress-related physical disorders.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/29086069/", text: NSLocalizedString("This observational study found an association between depressive symptoms and higher cortisol levels.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/15840727/", text: NSLocalizedString("This study found that having positive emotions was associated with lower cortisol production.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/6257194/", text: NSLocalizedString("In this study of patients with Cushing’s disease (a disease of high cortisol levels), depressive symptoms were relieved by surgical correction of the high cortisol levels.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/3843450/", text: NSLocalizedString("This article reviews the role of cortisol in the development of clinical depression.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed?term=2994590", text: NSLocalizedString("This paper reviews the connection between abnormal cortisol secretion and anxiety and depression.", comment: "")),
            Source(url: "https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0213513", text: NSLocalizedString("This paper determined that waking cortisol levels correlated with measurements of wellbeing.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/2994764/", text: NSLocalizedString("This paper discusses the differences in cortisol levels in depressed and non-depressed individuals.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5334212/", text: NSLocalizedString("This paper reviews the connection between problems in cortisol secretion and depression.", comment: ""))]),
        GoalSources(goalID: .FOCUS, sources: [
            Source(url: "https://www.nature.com/articles/mp2013190", text: NSLocalizedString("This paper reviews the role of stress and cortisol in reduced functioning of the hippocampus, the part of the brain in charge of learning and memory.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/15950390/", text: NSLocalizedString("This paper reviews the signs and symptoms of stress-induced cortisol dysfunction including fatigue, depression, and memory impairment.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/16023372/", text: NSLocalizedString("This paper reviews how long-term exposure of the brain to high cortisol is associated with memory problems and reduced hippocampal size.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/3527687/", text: NSLocalizedString("This paper reviews the connection between stress, cortisol, and premature aging of the brain.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/11719638/", text: NSLocalizedString("This paper reviews the association between cognitive impairment and chronically high cortisol levels.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/15576060/", text: NSLocalizedString("This paper reviews how high cortisol levels seem to impair learning and memory.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/19175976/", text: NSLocalizedString("This paper reviews some of the mechanisms by which stress and cortisol impact human memory.", comment: ""))]),
        GoalSources(goalID: .BODY, sources: [
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/23404865/", text: NSLocalizedString("This study found how abnormal cortisol secretion is associated with increased body mass index and waist circumference.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5373497/", text: NSLocalizedString("This study found that higher cortisol levels were predictive of increased weight gain.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5334212/", text: NSLocalizedString("This paper reviews the connection between cortisol dysregulation and diabetes, a condition known to increase the risk of obesity.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/25437119", text: NSLocalizedString("This study found that maternal salivary cortisol levels during pregnancy were positively associated with overweight children.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5573220/", text: NSLocalizedString("This paper reviews the connection between an activated stress response, cortisol levels, insulin resistance, and weight gain.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/32778654/", text: NSLocalizedString("In this study of patients with anorexia nervosa, cortisol levels normalized with healthy weight gain.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/6690287", text: NSLocalizedString("This study reviews how cortisol decreases formation of new bone.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/2155107/", text: NSLocalizedString("This animal study explored how cortisol levels affect bone density.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed?term=25098712", text: NSLocalizedString("Diseases that cause chronically low cortisol levels are associated with weight loss.", comment: ""))]),
        GoalSources(goalID: .FITNESS, sources: [
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/6365973", text: NSLocalizedString("High cortisol levels may contribute to decrease in muscle strength due to proteolysis, a breakdown in muscle tissue.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/18248637", text: NSLocalizedString("High cortisol levels were associated with reduced muscle strength.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4315033/", text: NSLocalizedString("This paper reviews how cortisol levels regulate muscle mass.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/1905485", text: NSLocalizedString("This paper reviews how low cortisol levels may be associated with low blood sugar which can impair athletic performance.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed?term=25098712", text: NSLocalizedString("This paper reviews how diseases that cause persistently low cortisol levels may be associated with electrolyte abnormalities such as low sodium and high potassium levels.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6689951/", text: NSLocalizedString("In this controlled clinical trial, cardiovascular exercise led to improvement in the cortisol awakening response, a measure of stress resilience.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/7825879/", text: NSLocalizedString("Regular cardiovascular exercise modulates the release of cortisol over time, which is associated with improved stress resilience.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/2724196/", text: NSLocalizedString("This clinical trial found that participation in Tai Chi exercise was associated with reduced salivary cortisol levels.", comment: "")),
            Source(url: "https://www.jstage.jst.go.jp/article/jpts/25/4/25_2012-364/_article/-char/ja/", text: NSLocalizedString("Regular vigorous cardiovascular exercise was associated with lower stress and cortisol levels.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/30721838/", text: NSLocalizedString("Aerobic exercise improved cortisol awakening response in older adults, a marker of stress resilience.", comment: ""))]),
        GoalSources(goalID: .IMMUNITY, sources: [
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/15041083/", text: NSLocalizedString("This paper reviews the connection between abnormal cortisol levels and impaired immune function.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/8003772/", text: NSLocalizedString("This paper reviews how the normal morning rise of cortisol helps to activate adaptive immune function.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/9512816/", text: NSLocalizedString("This paper reviews how chronic stress and elevated cortisol are associated with impairment in immune function.", comment: "")),
            Source(url: "https://jamanetwork.com/journals/jama/article-abstract/2712536", text: NSLocalizedString("This paper reviews the connection between high cortisol levels and autoimmune diseases.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/12498103", text: NSLocalizedString("This article reviews how abnormal cortisol levels are associated with the severity of autoimmune disease.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/12481925", text: NSLocalizedString("This paper reviews how chronic stress and it’s associated changes in cortisol levels impair the immune system.", comment: ""))]),
        GoalSources(goalID: .BEAUTY, sources: [
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/3062759", text: NSLocalizedString("This paper reviews how high cortisol levels may downregulate collagen production leading to fragile skin and hair loss.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/27538002", text: NSLocalizedString("This paper reviews how cortisol can cause hair growth disruption..", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/15110929", text: NSLocalizedString("This paper reviews how perceived stress and elevated cortisol levels impair the skin's ability to heal from a wound.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/9625226", text: NSLocalizedString("This paper reviews the connection between high stress and impaired mucosal wound healing.", comment: ""))]),
        GoalSources(goalID: .DIGESTION, sources: [
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/15740474", text: NSLocalizedString("This paper reviews the connection between stress, stress hormones, and digestive diseases.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6833069/", text: NSLocalizedString("This paper reviews  link between chronic stress, inflammation, and colon cancer.", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/20410248", text: NSLocalizedString("This paper reviews the connection between stress, food, and inflammation.", comment: ""))])],
    moreInfo: [
        TitleDescription(
            title: Constants.HOW_TO_READ_THE_GRAPH,
            description: NSLocalizedString("Cortisol production starts to ramp up around 3 AM and peaks around 8 AM. If you’re an early bird and up before 6 AM, cortisol levels will likely be very low. A level of 0 mcg/L can be normal. However, if you’re a night owl and wake up later, then don’t be surprised if your morning cortisol levels are much higher. The later you wake up, the higher your cortisol will tend to be, so keep this in mind when you test.", comment: "")),
        TitleDescription(
            title: Constants.WHY_IT_MATTERS,
            description: NSLocalizedString("Cortisol is a critical hormone produced primarily in our adrenal glands. It is part of the hypothalamic-pituitary-adrenal axis. In response to stressors, the hypothalamus releases Corticotropin Releasing Hormone (CRH), triggering the pituitary to secrete adrenocorticotropic hormone (ACTH), triggering our adrenal glands to make cortisol and other steroid hormones from cholesterol.\n\nCortisol is most often released in response to stress (physical, physiological, and emotional/mental), and prepares the body to respond to that stressor. For example, cortisol increases blood sugar and blood pressure, which can be life-saving in times of stress. However, if your cortisol level is elevated longer than it should be, it can suppress your immune system, thin your bones, and put you at greater risk for things like diabetes, depression, and heart disease.\n\nCortisol is released on a daily cycle and is typically highest in the morning with gradually declining levels throughout the day. Because of this, the timing of your urine collection is very important, and it should be closely watched. We recommend testing immediately after waking up, which reflects your overnight cortisol production. Usually, overnight free cortisol should be very low in the urine. High levels may suggest problems with sleep quantity and/or quality, chronic stress, and chronic illness, among other things.", comment: "")),
        TitleDescription(
            title: Constants.TIPS_TO_IMPROVE,
            description: NSLocalizedString("The best way to improve your cortisol levels is with lifestyle changes to improve your stress resilience. Some specific nutrients can also support the health of your adrenal glands.", comment: ""))])
