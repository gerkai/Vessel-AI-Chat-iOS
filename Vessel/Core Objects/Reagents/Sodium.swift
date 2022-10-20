//
//  Sodium.swift
//  Vessel
//
//  Created by Carson Whitsett on 10/17/22.
//  ID: 23

import Foundation

let Sodium = Reagent(
    name: NSLocalizedString("Sodium", comment: "Reagent name"),
    unit: NSLocalizedString("mEq/L", comment: "unit of measurement"),
    consumptionUnit: NSLocalizedString("mEq", comment: "consumption unit"),
    type: .Colorimetric,
    recommendedDailyAllowance: 0,
    imageName: "Sodium",
    buckets: [
        Bucket(low: 50.0, high: 120.0, score: 50.0, evaluation: .high,
            hint: TitleDescription(
                title: NSLocalizedString("Your Sodium results are too high", comment: ""),
                 description: NSLocalizedString("Oops, you overshot the goal. Your sodium level is higher than what your body ideally needs at the moment, and a high concentration of sodium is being excreted out into your urine. We recommend that you do a dietary inventory of your sodium intake for a few days, reading every food label, determining how many serving sizes you ingest, doing the math and adding up your intake. If your food does not have a label (whole grains, vegetables, fruits, legumes, and unsalted nuts) then assume your sodium intake from that food is zero. We also recommend that you do not restrict or increase your sodium solely as a result of your Vessel test results. This is because too little or too much sodium seems to be connected to adverse cardiac events (that’s right—too little salt is bad for you too, but very few Americans are in danger of having this issue due to the large amount of sodium already added to the foods we eat). Keep track of any table salt you use to season your food and sodium in any beverages too! Ideally, you want to limit your sodium to no more than 2300mg of sodium each day, approximately 1 teaspoon.", comment: ""))),
    Bucket(low: 0.0, high: 50.0, score: 100.0, evaluation: .good,
        hint: TitleDescription(title: NSLocalizedString("Your Sodium results are good", comment: ""),
        description: NSLocalizedString("Good job! Your body is excreting healthy amounts of sodium in your urine. This is just what you want. Sodium in urine can be caused by the natural filtration of your kidneys, dietary sodium and hydration intake. Make sure you keep your sodium intake to about 2300mg, 1 teaspoon daily. To keep a healthy sodium intake, you can do dietary inventory of your sodium intake for a few days, reading every food label, determining how many serving sizes you ingest, doing the math and adding up your intake. If your food does not have a label (whole fruits and veggies) then assume your sodium intake from that food is zero. Check out the Science section below to see some of the potential benefits you may experience from being in a good range for sodium. Be sure to chat in with one of our health coaches to better understand food labels and sodium intake.", comment: "")))],
    goalImpacts: [
        GoalImpact(goalID: 1, impact: 2),
        GoalImpact(goalID: 2, impact: 2),
        GoalImpact(goalID: 3, impact: 2),
        GoalImpact(goalID: 4, impact: 1),
        GoalImpact(goalID: 6, impact: 3),
        GoalImpact(goalID: 8, impact: 1),
        GoalImpact(goalID: 10, impact: 3)],
    goalSources: [
        GoalSources(goalID: .SLEEP, sources: [
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/34224007/", text: NSLocalizedString("High salt intake and BMI was associated with sleep disordered breathing.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/26781276/", text: NSLocalizedString("Circadian disorders such as sleep apnea and shift work may alter the body’s response to sodium intake and influence nocturnal hypertension.", comment: ""))]),
        GoalSources(goalID: .MOOD, sources: [
            Source(url: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4480897/", text: NSLocalizedString("Research suggested that lower daily salt intake is a significant risk of mental distress for rural community-dwelling Japanese men", comment: "")),
            Source(url: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6708056/", text: NSLocalizedString("Results suggested that consumption of foods high in sodium and low in potassium may have contributed to the development of depressive symptoms in early adolescents.", comment: ""))]),
        GoalSources(goalID: .FOCUS, sources: [
            Source(url: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5334786/", text: NSLocalizedString("Lower sodium intake was associated with worse cognitive function in older community-dwelling adults. For the maintenance of cognitive health, older adults may be advised to avoid very low sodium diets.", comment: ""))]),
        GoalSources(goalID: .IMMUNITY, sources: [
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/25497276/#:~:text=The%20studies%20on%20mice%20have,on%20human%20immunity%20is%20scarce", text: NSLocalizedString("The studies on mice have revealed that sodium chloride plays a role in the modulation of the immune system. A high-salt diet can promote tissue inflammation and autoimmune disease.", comment: "")),
            Source(url: "https://www.cell.com/cell-metabolism/fulltext/S1550-4131(15)00055-8", text: NSLocalizedString("Researchers have found that sodium may accumulate in the skin and tissue in humans and mice to help control infection.", comment: ""))]),
        GoalSources(goalID: .FITNESS, sources: [
            Source(url: "https://bjsm.bmj.com/content/37/6/485", text: NSLocalizedString("The ingestion of 0.5 g of sodium citrate/kg body mass shortly before a 5 km running time trial improves performance in well trained college runners.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/1895359/", text: NSLocalizedString("Addition of sodium and potassium may be important for rehydration before and after exercise.", comment: ""))]),
        GoalSources(goalID: .CALM, sources: [
            Source(url: "https://www.jneurosci.org/content/31/14/5470", text: NSLocalizedString("Elevated levels of sodium blunt the body's natural responses to stress by inhibiting stress hormones that would otherwise be activated in stressful situations.", comment: "")),
            Source(url: "https://www.sciencedirect.com/science/article/abs/pii/003193849500077V", text: NSLocalizedString("An animal study suggests that salt may calm us. When rats are put in stressful situations, they choose to drink salty water rather than unsalted water.", comment: ""))]),
        GoalSources(goalID: .BODY, sources: [
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/18203914/", text: NSLocalizedString("High-sodium intakes are deleterious to bone health, especially in older women.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/7572702/", text: NSLocalizedString("A two-year longitudinal study in postmenopausal women found increased urinary sodium excretion (an indicator of increased sodium intake) to be associated with decreased bone mineral density (BMD) at the hip.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/16261460/", text: NSLocalizedString("Another study in 40 postmenopausal women found that adherence to a low-sodium diet (2 g/day) for six months was associated with significant reductions in sodium excretion, calcium excretion, and amino-terminal propeptide of type I collagen, a biomarker of bone resorption. Yet, these associations were only observed in women with elevated baseline urinary sodium excretions.", comment: "")),
            Source(url: "https://pubmed.ncbi.nlm.nih.gov/29021321/", text: NSLocalizedString("Study suggests association between urinary sodium excretion and blood pressure, and an inverse association between urinary potassium excretion and blood pressure. Thus, higher levels of sodium and lower levels of potassium intake are associated with higher blood pressure.", comment: "")),
            Source(url: "https://www.sciencedaily.com/releases/2018/08/180809202057.htm", text: NSLocalizedString("Study suggests average consumption of salt is safe for heart health.", comment: ""))])],
    moreInfo: [
        TitleDescription(
            title: Constants.HOW_TO_READ_THE_GRAPH,
            description: NSLocalizedString("When you’re in the good zone (darker purple), this is great news because it means that your body is not being under- or over-loaded with sodium. At Vessel we are working hard to give you easy to interpret, quick information that can motivate you to improve your wellness. For our sodium test, we are using something called a “spot urine”, showing us how much sodium is in your urine at that moment in time. While it may seem logical that eating too much salt (sodium chloride), would lead to too much sodium in your urine, it is actually much more complicated than that. Our kidneys work hard to keep the concentration of electrolytes (like sodium) in our blood in a very narrow range.\n\nUsing a combination of filtration and concentration systems in the body, cues from blood volume (affected by hydration levels), and nearly a dozen hormones, our kidneys compensate for wide variations in stressors and dietary inputs. The way they maintain this careful electrolyte balance in our blood is by changing what level of electrolytes get into our urine. As a result, the evidence behind using urine to determine whether or not our dietary sodium intake is too high is still inconclusive (and why few of you have ever received a urine sodium test ordered by your doctor). The data does show that body hydration levels, and time of day can influence sodium levels in urine.", comment: "")),
        TitleDescription(
            title: Constants.WHY_IT_MATTERS,
            description: NSLocalizedString("It has been estimated that ~75% of the sodium that we ingest comes from the salt that is added during food processing and/or manufacturing as opposed to the salt that we add during cooking or eating. We should clarify that although salt and sodium are often used interchangeably they are not the same thing. Salt refers to a crystal compound composed of sodium chloride. Sodium is a  mineral and is one of the elements that make up salt.\n\nSodium is one of the body’s essential electrolytes. It helps maintain the balance of water inside and outside of your cells. It is a key player in muscle function and nerve conduction. And, sodium is also involved in maintaining blood pressure. Your body requires a small amount of sodium to maintain proper functioning, but too much sodium may be dangerous to your health. Multiple mechanisms act on the kidneys to ensure that the body maintains proper sodium balance.\n\nMost Americans eat too much sodium. Studies have shown that Americans eat ~3,400mg of sodium per day. But the Dietary Guidelines for Americans recommends that we eat < 2,300 mg per (i.e., 1 teaspoon of salt). Lowest sodium intake is associated with the consumption of unprocessed foods, especially fruits, vegetables and legumes.\n\nHigh sodium levels rank as one of the most dangerous factors in our nation’s physical health and morbidity. A vast majority of individuals do not lower their intake while there’s time to avoid irreversible cardiac impact. You can be one of the relatively few that takes charge of your long-term health. Showing love to your heart, kidneys, and overall body systems will pay big dividends.\n\nReferences:\n\n- [https://www.fda.gov/consumers/consumer-updates/eating-too-much-salt-ways-cut-backgradually](https://www.fda.gov/consumers/consumer-updates/eating-too-much-salt-ways-cut-backgradually)\n- [https://www.fda.gov/food/nutrition-education-resources-materials/use-nutrition-facts-label-reduce-your-intake-sodium-your-diet](https://www.fda.gov/food/nutrition-education-resources-materials/use-nutrition-facts-label-reduce-your-intake-sodium-your-diet)\n-  [https://www.ncbi.nlm.nih.gov/pubmed/26788299](https://www.ncbi.nlm.nih.gov/pubmed/26788299)", comment: "")),
        TitleDescription(
            title: Constants.TIPS_TO_IMPROVE,
            description: NSLocalizedString("If your sodium is high, you should read the food labels/nutrition facts and try to limit your sodium intake to < 2,300mg per day (i.e., < 1 teaspoon of salt per day). Those people who are > 51 year of age, black, have high blood pressure, diabetes or chronic kidney disease should limit their intake to < 1500mg per day. When reading nutrition labels you should also be sure to pay attention to the number of servings you are eating. For instance if the label says “there are 400mg of sodium in  a 1-cup serving” and you are eating 2 cups (or 2 servings) then you are eating 2x the amount of sodium (i.e, 800mg).\n\nYou should try to avoid foods that are high in sodium, such as processed or pre-packaged foods. Here is a list of foods that are high in sodium:\n-   Smoked, salted, and canned meat, fish, and poultry\n-   Ham, bacon, hot dogs, and lunch meats\n-    Hard and processed cheeses\n-   Regular peanut butter\n-  Crackers\n-  Frozen prepared meals\n-  Canned and dried soups, broths and veggies\n-  Snacks, chips, and pretzels\n-  Pickles and olives\n-  Ketchup, mustard, steak sauce, soy sauce, salad dressings\n-  Pre-seasoned rice, pasta, or other side dishes\n\nChoose to eat foods that are low in sodium. Here is a list of foods low in sodium:\n-  Fresh or frozen fruits and vegetables\n-  Unsalted nuts or peanut butter\n-  Dry beans or lentils, cooked without salt\n-  Pasta, rice, or other grains made without salt\n-  Whole-grain breads\n-  Fish, meat, and poultry made without salt\n-  Unsalted crackers or chips\n\nInstead of adding salt to foods when cooking try adding different spices for flavoring, such as coriander, black pepper, nutmeg, parsley, cumin, cilantro, ginger, rosemary, marjoram, thyme, tarragon, garlic or onion powder, bay leaf, oregano, dry mustard, dill, lemon, lime or vinegar.\nReferences:\n[https://www.cardiosmart.org/~/media/Documents/Fact%20Sheets/en/zp3768.ashx](https://www.cardiosmart.org/~/media/Documents/Fact%20Sheets/en/zp3768.ashx)\n[https://www.heart.org/-/media/data-import/downloadables/8/2/0/pe-abh-why-should-i-limit-sodium-ucm_300625.pdf](https://www.heart.org/-/media/data-import/downloadables/8/2/0/pe-abh-why-should-i-limit-sodium-ucm_300625.pdf)", comment: ""))])