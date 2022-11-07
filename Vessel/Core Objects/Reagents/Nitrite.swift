//
//  Nitrite.swift
//  Vessel
//
//  Created by Carson Whitsett on 10/17/22.
//  ID: 21

import Foundation

let Nitrite = Reagent(
    name: NSLocalizedString("Nitrites", comment: "Reagent name"),
    unit: NSLocalizedString("µg/L", comment: "unit of measurement"),
    consumptionUnit: NSLocalizedString("mG", comment: "consumption unit"),
    type: .Colorimetric,
    recommendedDailyAllowance: nil,
    imageName: "UrinaryTract",
    buckets: [
        Bucket(low: 3.0, high: 8.0, score: 0.0, evaluation: .detectedHigh,
            hint: TitleDescription(
                title: NSLocalizedString("Nitrites are detected high in urine", comment: ""),
                description: NSLocalizedString("Vessel is not intended to be used as a tool to screen for or diagnose illness or disease. However, our product has the ability to screen for nitrates, which are a breakdown product of certain bacteria, in the urine. Your results detect high levels of nitrites in the urine. This may indicate a potential urogenital infection. While False positives are always possible, it is recommended you be evaluated by your physician or medical team, especially if you are experiencing any of the following symptoms: discomfort during urination, the urgency to urinate, or more frequent urination, fever, chills, abdomen, or flank pain, and nausea.", comment: ""))),
        Bucket(low: 1.0, high: 3.0, score: 0.0, evaluation: .detectedLow,
            hint: TitleDescription(title: NSLocalizedString("Nitrites are detected low in urine", comment: ""),
            description: NSLocalizedString("Vessel is not intended to be used as a tool to screen for or diagnose illness or disease. However, our product has the ability to screen for nitrates, which are breakdown products of certain bacteria, in the urine. Your results detected low levels of nitrites, which may be a sign of a urogenital infection. Low detection of nitrites are common and can be benign. If you have any symptoms such as discomfort during urination, the urgency to urinate, or more frequent urination, fever, chills, abdomen, or flank pain, and nausea, Please be evaluated by your physician or medical team. As with any screening test, False positives and false negatives are always possible.", comment: ""))),
        Bucket(low: 0.0, high: 1.0, score: 0.0, evaluation: .notDetected,
            hint: TitleDescription(title: NSLocalizedString("Your results are normal", comment: ""),
            description: NSLocalizedString("Vessel is not intended to be used as a tool to screen for or diagnose illness or disease. Our product has the ability to screen for nitrates, a breakdown product of certain bacteria, in the urine. Your test showed no nitrites, but urogenital infections can be present despite a lack of nitrites. Therefore if you have any symptoms such as burning during urination, frequent urination, abdomen/pelvic pain, or fever/chills, we recommend being evaluated by your physician or medical team. As with any test, false negatives are always possible.", comment: "")))],
    goalImpacts: [],
    goalSources: [],
    moreInfo: [
        TitleDescription(
            title: Constants.HOW_TO_READ_THE_GRAPH,
            description: NSLocalizedString("This test measures levels of Nitrites in the urine. Nitrites are often used as a screening tool to diagnose bacterial urinary tract infections. However, more important than the results are whether or not you have SYMPTOMS that are consistent with a urinary tract infection. If your results are abnormal, there may be potential abnormalities, such as a urogenital infection. Nitrite results within the normal range indicate you may not have potential abnormalities. However, if you are experiencing symptoms such as burning during urination, frequent urination, abdomen/pelvic pain, or fever/chills, we still recommend being evaluated by your physician or medical team.\n\nIn general, using dipsticks to evaluate for nitrite should not be performed in patients without any symptoms consistent with a UTI, as a positive dipstick, which would denote the presence of pyuria and/or bacteriuria, does not indicate a UTI in an asymptomatic patient. The rationale for this is similar to the reasons not to screen for asymptomatic bacteriuria, which are discussed in detail elsewhere.", comment: "")),
                                 
        TitleDescription(
            title: Constants.WHY_IT_MATTERS,
            description: NSLocalizedString("Abnormal levels of Nitrites MAY indicate a developing urogenital infection (this includes urinary tract infections and sexually transmitted diseases). Many of these infections have bothersome symptoms (such as discomfort during urination, the urgency to urinate or need to urinate more frequently, or even fever, chills, abdomen or flank pain, and nausea). If you are experiencing any of these symptoms, please seek the advice of a physician regardless of the results on your card. Remember that it is also possible to have abnormal results on your card without infection and have normal results with the presence of an infection. Confused? Just remember, never ignore new symptoms in your body, and when speaking to a doctor, explain your concerns, remembering that the final word will always be their diagnosis. Urogenital infections can happen to even the healthiest of us, but if you are experiencing any symptoms listed above, it is advised to speak with your physician.", comment: "")),
        TitleDescription(
            title: Constants.TIPS_TO_IMPROVE,
            description: NSLocalizedString("Aim to reach your hydration goal on your card if you are a woman who struggles with UTIs, especially during times when you are sexually active. If you are sexually active, have you and your partner shower/bathe before sex. Be sure to do your best to urinate immediately after or within the hour after sexual activity to flush out any bacteria that have made their way into your urethra; these bacteria get “sticky” after time and soon will not be flushed out with normal urine flow!\n\nIf you are a man over 50, a UTI confirmed by your doctor could indicate an enlarged prostate. The prostate enlargement makes it hard to fully or forcefully empty your bladder, and any bacteria that get into the bladder may not get flushed out as they normally would. If you have noted a weaker stream, split stream, prolonged dripping at the end of your stream, or a feeling of incomplete bladder emptying (which often shows the need to empty the bladder all the time, both day and night), talk to your doctor!\n\nIf you are a woman in menopause, talk to your doctor about the appropriateness for a trial of vaginal estrogen which, in menopausal women, can decrease UTI frequency -Oestrogens for preventing recurrent urinary tract infection in postmenopausal women - [PubMed (nih.gov)](https://pubmed.ncbi.nlm.nih.gov/27092529/)\n\nYou can also make it harder for the bacteria to stick to the bladder wall by trying supplements such as:\n\t1. Cranberry extract– 500mg of cranberry with PACs (proanthocyanidins) daily  **do not take cranberry extract if you are taking the medication warfarin. Effect of oral cranberry extract (standardized proanthocyanidin-A) in patients with recurrent UTI by pathogenic E. coli: a randomized placebo-controlled clinical research study - [PubMed (nih.gov)](https://pubmed.ncbi.nlm.nih.gov/27314247/)\n\n\t2.D-mannose powder ½ tsp 3 times a day: D-mannose vs other agents for recurrent urinary tract infection prevention in adult women: a systematic review and meta-analysis - [PubMed (nih.gov)](https://pubmed.ncbi.nlm.nih.gov/32497610/)\n\n\t3. Probiotics: A type containing multiple strains of lactobacilli, especially L. rhamnosus and L reuteri. 10 billion CFUS or more days with a meal Non-Antibiotic Prophylaxis for Urinary Tract Infections - [PubMed (nih.gov)](https://pubmed.ncbi.nlm.nih.gov/27092529/)", comment: ""))])
