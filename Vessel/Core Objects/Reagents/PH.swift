//
//  PH.swift
//  Vessel
//
//  Created by Carson Whitsett on 10/17/22.
//  ID: 1

import Foundation

let PH = Reagent(
    name: NSLocalizedString("pH", comment: "Reagent Name"),
    unit: NSLocalizedString("pH", comment: "unit of measurement"),
    consumptionUnit: NSLocalizedString("pH", comment: "consumption unit"),
    type: .Colorimetric,
    recommendedDailyAllowance: nil,
    imageName: "pH",
    buckets: [
        Bucket(low: 7.78, high: 8.0, score: 30.0, evaluation: .high,
            hint: TitleDescription(title: NSLocalizedString("Your urine pH is too basic", comment: ""), description: NSLocalizedString("Not to worry. You can improve your ph by changing your nutrient intake, whether that’s with food and/or supplements. Be patient because it can take 1-2 weeks to see your levels improve. Tap below to see your personalized plan. You got this!", comment: ""))),
        Bucket(low: 6.0, high: 7.75, score: 100.0, evaluation: .good,
            hint: TitleDescription(title: NSLocalizedString("Your pH level is balanced", comment: ""), description: NSLocalizedString("Good job! You’re keeping your body’s acid-base status well balanced. Keep up the good work! Check out the Science section below to see some of the potential benefits you may experience by having a balanced pH.", comment: ""))),
        Bucket(low: 5.0, high: 6.0, score: 30.0, evaluation: .low,
            hint: TitleDescription(title: NSLocalizedString("You're a bit acidic", comment: ""), description: NSLocalizedString("Not to worry. You can improve your ph by changing your nutrient intake, whether that’s with food and/or supplements. Be patient because it can take 1-2 weeks to see your levels improve. Click below to see your personalized plan. You got this!", comment: "")))],
    goalImpacts: [
        GoalImpact(goalID: 5, impact: 1),
        GoalImpact(goalID: 6, impact: 1),
        GoalImpact(goalID: 10, impact: 2)],
    goalSources: [
        GoalSources(goalID: .ENERGY, sources: [
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
            Source(url: "https://www.ncbi.nlm.nih.gov/pubmed/18326605", text: NSLocalizedString("Preserve muscle mass: Balanced pH is associated with preserved muscle mass in older men and women.", comment: ""))])],
    moreInfo: [
        TitleDescription(
            title: Constants.HOW_TO_READ_THE_GRAPH,
            description: NSLocalizedString("First of all, let’s talk about what a pH scale is in the first place…\n\npH measures how acidic or basic a substance is (in this case, urine). The lower your pH, the more acidic your urine. The higher your pH, the more alkaline your urine.\n\nA pH scale is logarithmic; that is, a difference of 1 pH is a 10x difference. For example, a pH of 3 is 10x more acidic than a pH of 4 and 100x (10 x 10) more acidic than a pH of 5.\n\npH paper contains several indicators that change color at different pH levels. When you dip the paper into a solution, the paper’s color indicates the pH of that solution.When you look at your graph in the app, you’ll see a low zone (acidic urine), good zone (balanced pH), and high zone (alkaline urine).\n\nThe sweet spot for urine pH is between 6.5 and 7.5. If you’re there, you’re golden.\n\nLess than 5.5 means your urine is very acidic and may need some additional mineral support to increase alkalinity.\n\npH of 5.5-6.5 means your urine is slightly acidic, and you may need a small amount of mineral support to increase alkalinity.\n\npH over 7.5 is very alkaline and can be caused by mineral imbalance, infection, or high alkalinity foods and water. Avoid exclusively drinking alkaline water with a pH of >9.0.", comment: "")),
        TitleDescription(
            title: Constants.WHY_IT_MATTERS,
            description: NSLocalizedString("Healthy urinary pH is slightly acidic, hovering around 6. However, it can range between 4.5-8, depending on the acid/ base balance in the body. The kidneys, along with the lungs, are involved in managing the body’s pH balance. This range fluctuates depending on many variables, including hydration status and consuming highly acidic foods (meats, alcohol, sugar, or dairy) vs. basic/alkaline foods (vegetables, sea salt, and citrus). Other imbalances, including lung disease, diabetic ketoacidosis, urinary tract infections, or dehydration, may lead to unhealthy changes in blood and urine pH.\n\nThe most common cause of lower (acidic) pH is eating a standard American diet of processed foods, alcohol, sugar, and animal products with few vegetables. It can also be a result of metabolic or respiratory disease.\n\nFoods that increase urinary pH and reduce acidity are those that are high in calcium, magnesium, and potassium like green vegetables, fruits, nuts, lentils, citrus, and more vegetables. Some bacterial infections can also increase alkalinity and urine pH.\n\nAn important concept to remember: A food’s acidic or alkaline effect on the body is not necessarily related to it’s predigested pH. Scientists grade the acidity of foods based on their potential renal acid load (PRAL). The PRAL of a food is the amount of acid that is expected to reach the kidneys once it has been metabolized. Foods such as meats and grains are high in acidic nutrients, such as protein and phosphorous, so they increase the amount of acid the kidneys have to filter out, and consequently, they have a positive PRAL score. Alkaline foods, such as fruits and vegetables, on the other hand, are high in alkaline nutrients like magnesium and calcium, so they reduce the amount of acid the kidneys filter out and have a lower PRAL score. Now let us apply this to citrus, lemon juice has an acidic predigested pH, but once it is digested, it produces alkaline byproducts and therefore alkalizes the body.", comment: "")),
        TitleDescription(
            title: Constants.TIPS_TO_IMPROVE,
            description: NSLocalizedString("Since pH is so closely related to our diet, the fastest way to improve urinary pH in healthy adults is through diet & lifestyle changes.\n\nIt is important to stay well hydrated with mineral water, avoiding beverages that have a diuretic effect (caffeine) or increase acidity (alcohol, sugary sodas). A daily goal for water intake is half of your body weight (pounds) in ounces. A 150-pound adult should aim for 75 ounces of water per day. Adding a squeeze of citrus may also help reduce the acidity of the urine.", comment: ""))])
