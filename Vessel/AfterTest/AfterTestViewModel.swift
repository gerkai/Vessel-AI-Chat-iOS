//
//  AfterTestViewModel.swift
//  Vessel
//
//  Created by Carson Whitsett on 7/28/22.
//
//
//  TODO: Some screens aren't iplemented yet. They're defined in the enums below but commented out
//  TODO: After flow is completed, save contactFlags to Contact.main()!.flags

import UIKit

class AfterTestViewModel
{
    var reagentInfoFlags: Int = 0
    var testResult: TestResult!
    var currentScreen: Int = -1
    var contactFlags: Int = 0
    var screens: [AfterTestScreen] = []
    
    enum AfterTestScreen
    {
        case MAG_LOW_1
        case MAG_LOW_2
        //case MAG_LOW_3
        case SOD_HIGH_1
        case SOD_HIGH_2
        case SOD_HIGH_3
        case CAL_LOW_1
        case CAL_LOW_2
        case CAL_LOW_3
        //case CAL_LOW_4
        case VIT_C_LOW_1
        case VIT_C_LOW_2
        //case VIT_C_LOW_3
        case VIT_C_LOW_4
        case PH_LOW_1
        case PH_LOW_2
        //case PH_LOW_3
        case PH_HIGH_1
        case PH_HIGH_2
        case PH_HIGH_3
        case HYDRO_LOW_1
        case HYDRO_LOW_2
        //case HYDRO_LOW_3
        case HYDRO_HIGH_1
        case HYDRO_HIGH_2
        case HYDRO_HIGH_3
        //case HYDRO_HIGH_4
        case KETO_LOW_1
        case KETO_LOW_2
        case KETO_LOW_3
        //case KETO_LOW_4
        case KETO_ELEVATED_1
        //case KETO_ELEVATED_2
        case KETO_HIGH_1
        case KETO_HIGH_2
        case B7_LOW_1
        case B7_LOW_2
        //case B7_LOW_3
        case CORT_LOW_1
        case CORT_LOW_2
        //case CORT_LOW_3
        case CORT_HIGH_1
        case CORT_HIGH_2
        //case CORT_HIGH_3
        case TEST_REMINDER
    }
    
    init(testResult: TestResult)
    {
        self.testResult = testResult
        calculateTotalScreens()
    }
    
    func calculateTotalScreens()
    {
        //Determines how many screens will be shown based on evaluation of test results.
        //This allows us to know the maximum value of the progress bar that is displayed on many of the screens.
        let contact = Contact.main()!
        
        if contact.flags & Constants.SAW_MAGNESIUM_INFO == 0
        {
            if testResult.isEvaluatedTo(id: Reagent.ID.MAGNESIUM, evaluation: .low)
            {
                contactFlags |= Constants.SAW_MAGNESIUM_INFO
                screens.append(.MAG_LOW_1)
                screens.append(.MAG_LOW_2)
                //screens.append(.MAG_LOW_3)
            }
        }
        if contact.flags & Constants.SAW_SODIUM_INFO == 0
        {
            if testResult.isEvaluatedTo(id: Reagent.ID.SODIUM, evaluation: .high)
            {
                contactFlags |= Constants.SAW_SODIUM_INFO
                screens.append(.SOD_HIGH_1)
                screens.append(.SOD_HIGH_2)
                screens.append(.SOD_HIGH_3)
            }
        }
        if contact.flags & Constants.SAW_CALCIUM_INFO == 0
        {
            if testResult.isEvaluatedTo(id: Reagent.ID.CALCIUM, evaluation: .low)
            {
                contactFlags |= Constants.SAW_CALCIUM_INFO
                screens.append(.CAL_LOW_1)
                screens.append(.CAL_LOW_2)
                screens.append(.CAL_LOW_3)
                //screens.append(.CAL_LOW_4)
            }
        }
        if contact.flags & Constants.SAW_VITAMIN_C_INFO == 0
        {
            if testResult.isEvaluatedTo(id: Reagent.ID.VITAMIN_C, evaluation: .low)
            {
                contactFlags |= Constants.SAW_VITAMIN_C_INFO
                screens.append(.VIT_C_LOW_1)
                screens.append(.VIT_C_LOW_2)
                //screens.append(.VIT_C_LOW_3)
                screens.append(.VIT_C_LOW_4)
            }
        }
        if contact.flags & Constants.SAW_PH_LOW_INFO == 0
        {
            if testResult.isEvaluatedTo(id: Reagent.ID.PH, evaluation: .low)
            {
                contactFlags |= Constants.SAW_PH_LOW_INFO
                screens.append(.PH_LOW_1)
                screens.append(.PH_LOW_2)
                //screens.append(.PH_LOW_3)
            }
        }
        if contact.flags & Constants.SAW_PH_HIGH_INFO == 0
        {
            if testResult.isEvaluatedTo(id: Reagent.ID.PH, evaluation: .high)
            {
                contactFlags |= Constants.SAW_PH_HIGH_INFO
                screens.append(.PH_HIGH_1)
                screens.append(.PH_HIGH_2)
                screens.append(.PH_HIGH_3)
            }
        }
        if contact.flags & Constants.SAW_HYDRATION_LOW_INFO == 0
        {
            if testResult.isEvaluatedTo(id: Reagent.ID.HYDRATION, evaluation: .low)
            {
                contactFlags |= Constants.SAW_HYDRATION_LOW_INFO
                screens.append(.HYDRO_LOW_1)
                screens.append(.HYDRO_LOW_2)
                //screens.append(.HYDRO_LOW_3)
            }
        }
        if contact.flags & Constants.SAW_HYDRATION_HIGH_INFO == 0
        {
            if testResult.isEvaluatedTo(id: Reagent.ID.HYDRATION, evaluation: .high)
            {
                contactFlags |= Constants.SAW_HYDRATION_HIGH_INFO
                screens.append(.HYDRO_HIGH_1)
                screens.append(.HYDRO_HIGH_2)
                screens.append(.HYDRO_HIGH_3)
                //screens.append(.HYDRO_HIGH_4)
            }
        }
        if contact.flags & Constants.SAW_KETONES_LOW_INFO == 0
        {
            if testResult.isEvaluatedTo(id: Reagent.ID.KETONES_A, evaluation: .low)
            {
                if contact.isOnDiet(Diet.ID.KETO)
                {
                    contactFlags |= Constants.SAW_KETONES_LOW_INFO
                    screens.append(.KETO_LOW_1)
                    screens.append(.KETO_LOW_2)
                    screens.append(.KETO_LOW_3)
                    //screens.append(.KETO_LOW_4)
                }
            }
        }
        if contact.flags & Constants.SAW_KETONES_ELEVATED_INFO == 0
        {
            if testResult.isEvaluatedTo(id: Reagent.ID.KETONES_A, evaluation: .elevated)
            {
                if contact.isOnDiet(Diet.ID.KETO)
                {
                    contactFlags |= Constants.SAW_KETONES_ELEVATED_INFO
                    screens.append(.KETO_ELEVATED_1)
                    //screens.append(.KETO_ELEVATED_2)
                }
            }
        }
        if contact.flags & Constants.SAW_KETONES_HIGH_INFO == 0
        {
            if testResult.isEvaluatedTo(id: Reagent.ID.KETONES_A, evaluation: .high)
            {
                if !contact.isOnDiet(Diet.ID.KETO)
                {
                    contactFlags |= Constants.SAW_KETONES_HIGH_INFO
                    screens.append(.KETO_HIGH_1)
                    screens.append(.KETO_HIGH_2)
                }
            }
        }
        if contact.flags & Constants.SAW_B7_LOW_INFO == 0
        {
            if testResult.isEvaluatedTo(id: Reagent.ID.VITAMIN_B7, evaluation: .low)
            {
                contactFlags |= Constants.SAW_B7_LOW_INFO
                screens.append(.B7_LOW_1)
                screens.append(.B7_LOW_2)
                //screens.append(.B7_LOW_3)
            }
        }
        if contact.flags & Constants.SAW_CORTISOL_LOW_INFO == 0
        {
            if testResult.isEvaluatedTo(id: Reagent.ID.CORTISOL, evaluation: .low)
            {
                contactFlags |= Constants.SAW_CORTISOL_LOW_INFO
                screens.append(.CORT_LOW_1)
                screens.append(.CORT_LOW_2)
                //screens.append(.CORT_LOW_3)
            }
        }
        if contact.flags & Constants.SAW_CORTISOL_HIGH_INFO == 0
        {
            if testResult.isEvaluatedTo(id: Reagent.ID.CORTISOL, evaluation: .high)
            {
                contactFlags |= Constants.SAW_CORTISOL_HIGH_INFO
                screens.append(.CORT_HIGH_1)
                screens.append(.CORT_HIGH_2)
                //screens.append(.CORT_HIGH_3)
            }
        }
        if contact.flags & Constants.SAW_TESTING_REMINDER != 0
        {
            contactFlags |= Constants.SAW_TESTING_REMINDER
            //screens.append(.TEST_REMINDER)
        }
    }
    
    //MARK: - navigation
    func back()
    {
        if currentScreen > -1
        {
            currentScreen -= 1
            if currentScreen == -1
            {
                print("Backing up to beginning")
            }
            else
            {
                print("Backing up to screen \(currentScreen): \(screens[currentScreen])")
            }
        }
    }
    
    func nextViewControllerData() -> (title: String, details: String, imageName: String, transition: ScreenTransistion )
    {
        currentScreen += 1
        if currentScreen < screens.count
        {
            switch screens[currentScreen]
            {
                case .MAG_LOW_1:
                    return (NSLocalizedString("Your Magnesium is Low", comment: ""),
                            NSLocalizedString("Studies suggest Magnesium plays a key role in supporting sleep, digestion, and calm through regulating important brain chemicals such as melatonin and GABA as well as supporting the relaxation of nerves and smooth muscle contractions.", comment: ""),
                            "mag-top-right",
                            .fade)
                case .MAG_LOW_2:
                    return (NSLocalizedString("How to Improve Your Magnesium Levels", comment: ""),
                            NSLocalizedString("Magnesium levels are improved through food and supplementation. While your test results may take a few months to improve; you may notice the benefits of improved sleep and reduced stress in just a few weeks.", comment: ""),
                            "mag-top-right",
                            .push)
                case .SOD_HIGH_1:
                    return (NSLocalizedString("Your Sodium Levels are High", comment: ""),
                            NSLocalizedString("High levels of sodium in the urine may be caused by a high Sodium diet. High Sodium levels in the diet can lead to an increase in Calcium loss and could contribute to high blood pressure, stroke, and possible kidney failure. The recommended daily intake of sodium is 2,300 mg, approximately 1 teaspoon of salt per day.", comment: ""),
                            "sod-top-right",
                            .fade)
                case .SOD_HIGH_2:
                    return (NSLocalizedString("Importance of Sodium", comment: ""),
                            NSLocalizedString("Sodium helps maintain the balance of water inside and outside of your cells. It is a key player in muscle function and nerve conduction. We recommend that you do a dietary inventory of your Sodium intake for a few days, reading every food label, determining how many serving sizes you ingest, doing the math and adding up your intake. If your food does not have a label (whole grains, vegetables, fruits, legumes, and unsalted nuts) then assume your Sodium intake from that food is zero.", comment: ""),
                            "sod-top-right",
                            .fade)
                case .SOD_HIGH_3:
                    return (NSLocalizedString("How to Lower Sodium Levels", comment: ""),
                            NSLocalizedString("Do you best to limit your Sodium intake to < 2,300mg per day, one teaspoon. Those people who are > 51 year of age, have high blood pressure, diabetes or chronic kidney disease should limit their intake to < 1500mg per day. Instead of adding salt to foods when cooking, add different spices for flavoring, such as parsley, cumin, cilantro, ginger, rosemary, garlic or onion powder, bay leaf, oregano, dry mustard, dill and more!", comment: ""),
                            "sod-top-right",
                            .push)
                case .CAL_LOW_1:
                    return (NSLocalizedString("Your Calcium Level is Low", comment: ""),
                            NSLocalizedString("Low Calcium in the urine generally stems from low dietary Calcium intake. When levels begin to drop, our bones will release Calcium into the blood. In some cases, low Calcium can stem from gastric bypass surgery, medications such as diuretics, and low Vitamin D levels.", comment: ""),
                            "cal-top-right",
                            .fade)
                case .CAL_LOW_2:
                    return (NSLocalizedString("Importance of Calcium", comment: ""),
                        NSLocalizedString("Calcium is most commonly associated with the health of our bones and teeth. However, Calcium is essential for nerve and muscle function, regulating heart rhythms and blood clotting. Symptoms of low Calcium levels range from muscle cramps or weakness, numbness or tingling in fingers, and an abnormal heart rate.", comment: ""),
                            "cal-top-right",
                            .fade)
                case .CAL_LOW_3:
                    return (NSLocalizedString("How to Raise Calcium Levels", comment: ""),
                            NSLocalizedString("You can improve your levels by changing your nutrient intake, whether that’s with food and/or supplements. The TOTAL from food and supplements combined for Calcium intake should be no greater than 1000mg. Supplement using active forms such as Calcium citrate or Calcium malate improve absorption. Do not take more than 500mg of elemental Calcium at one time to maximize intestinal absorption.", comment: ""),
                            "cal-top-right",
                            .push)
                case .VIT_C_LOW_1:
                        return (NSLocalizedString("Your Vitamin C Level is Low", comment: ""),
                                NSLocalizedString("Studies show that vitamin C has a major impact on your immune system, glowing skin, a balanced mood, and a sense of calm. It does this by acting as an antioxidant to protect cells from damage and playing a major role in the production of collagen.", comment: ""),
                                "vitc-top-right",
                                .fade)
                case .VIT_C_LOW_2:
                        return (NSLocalizedString("How to Optimize Your Vitamin C Levels", comment: ""),
                                NSLocalizedString("Your Vessel results indicate a low Vitamin C level. Not to worry! Your Vitamin C levels can be improved within a few days to a few weeks through food and supplementation.", comment: ""),
                                "vitc-top-right",
                                .fade)
                case .VIT_C_LOW_4:
                    return (NSLocalizedString("What About a Vitamin C Supplement?", comment: ""),
                            NSLocalizedString("Vitamin C supplementation can be a great way to boost your overall levels. In addition to consuming vitamin C rich foods, your Vessel fuel supplement plan will contain vitamin C. Through food and supplementation intake, you can expect to see improvements in your Vitamin C results, and feel the benefits within a few weeks!", comment: ""),
                            "vitc-top-right",
                            .push)
                case .PH_LOW_1:
                    return (NSLocalizedString("Your pH is Low", comment: ""),
                            NSLocalizedString("Studies show a balanced pH level is beneficial for improved energy, endurance, and overall body wellness by preserving muscle mass and decreasing the burden placed on kidneys and cells.", comment: ""),
                            "ph-top-right",
                            .fade)
                case .PH_LOW_2:
                    return (NSLocalizedString("Improving Your pH Level", comment: ""),
                    NSLocalizedString("A low urine pH indicates that your urine is slightly acidic. A common cause of lower (acidic) pH is eating a standard American diet of foods such as soft drinks, alcohol, refined grains, caffeine, and processed dairy. Low pH is associated with feelings of fatigue. By cutting out these foods and increasing alkaline foods you should see an improvement in your pH levels in a few weeks.", comment: ""),
                    "ph-top-right",
                    .push)
                    
                case .PH_HIGH_1:
                    return (NSLocalizedString("Your pH is High", comment: ""),
                    NSLocalizedString("Studies show a balanced pH level is beneficial for improved energy, endurance, and overall body wellness by preserving muscle mass and decreasing the burden placed on kidneys and cells.", comment: ""),
                    "ph-top-right",
                            .fade)
                case .PH_HIGH_2:
                    return (NSLocalizedString("What Does a High pH Mean?", comment: ""),
                    NSLocalizedString("A high urine pH indicates that your urine is slightly more basic than is desired. A basic pH can put you at risk for or indicate a bacterial infection. Please keep in mind a plant-based diet with high intakes of alkaline foods such as leafy greens, colorful fruits, nuts, seeds, and legumes can also result in a high pH.", comment: ""),
                    "ph-top-right",
                            .fade)
                case .PH_HIGH_3:
                    return (NSLocalizedString("Monitoring Your High pH", comment: ""),
                    NSLocalizedString("It is important to closely monitor your high pH and look out for additional symptoms of urinary tract infection. If you suspect that you may have a UTI, consult your primary care practitioner for additional guidance.", comment: ""),
                    "ph-top-right",
                    .push)
                    
                case .HYDRO_LOW_1:
                    return (NSLocalizedString("Your Hydration is Low", comment: ""),
                    NSLocalizedString("Studies show that maintaining optimal cellular hydration is important for many bodily functions including mood, brain function, digestive health, energy levels, and even healthy weight management.", comment: ""),
                    "hydro-top-right",
                            .fade)
                case .HYDRO_LOW_2:
                    return (NSLocalizedString("How to Optimize Your Hydration", comment: ""),
                    NSLocalizedString("Low hydration is an indicator that you may not be drinking sufficient fluids. Within a few days of increasing your fluid intake through water and electrolyte rich foods such as: Spinach, Kale, Avocado, Broccoli, Sweet potato, and berries, you’ll be on your way to “good” hydration levels in no time!", comment: ""),
                    "hydro-top-right",
                    .push)
                    
                case .HYDRO_HIGH_1:
                    return (NSLocalizedString("Your Hydration is High", comment: ""),
                    NSLocalizedString("Studies show that maintaining optimal cellular hydration is important for many bodily functions including mood, brain function, digestive health, energy levels, and even healthy weight management.", comment: ""),
                    "hydro-top-right",
                            .fade)
                case .HYDRO_HIGH_2:
                    return (NSLocalizedString("What High Hydration Means", comment: ""),
                    NSLocalizedString("High hydration is an indicator that your urine is more diluted with water, rather than a balanced mineral to water ratio. With inadequate electrolytes, water may not be able to effectively hydrate your cells.", comment: ""),
                    "hydro-top-right",
                            .fade)
                case .HYDRO_HIGH_3:
                    return (NSLocalizedString("How to Improve Your Hydration Levels", comment: ""),
                    NSLocalizedString("In order to improve your levels, add more electrolytes into your water daily! You will notice an improvement in hydration levels within a few days by adding an electrolyte tablet, powder, or pinch of sea salt with lemon to boost your electrolyte intake daily, or add electrolyte-rich foods to your diet such as spinach, avocado, broccoli, and strawberries.", comment: ""),
                    "hydro-top-right",
                    .push)
                    
                case .KETO_LOW_1:
                    return (NSLocalizedString("Your Ketones are Low", comment: ""),
                    NSLocalizedString("Let’s break down how to optimize your production of ketones using the ketogenic diet to raise your level. Keep in mind that it can take several weeks to a month to increase ketone levels.", comment: ""),
                    "keto-top-right",
                            .fade)
                case .KETO_LOW_2:
                    return (NSLocalizedString("The Benefits of Ketones", comment: ""),
                    NSLocalizedString("Studies show that ketones are beneficial for improved focus, healthy weight management, increased energy, and a balanced mood through increasing your metabolic machinery in your cells to more efficiently burn fat for fuel with a lower production of harmful free radicals.", comment: ""),
                    "keto-top-right",
                            .fade)
                case .KETO_LOW_3:
                    return (NSLocalizedString("How Can You Optimize Ketones", comment: ""),
                    NSLocalizedString("Achieving a \"good\" or \"high\" ketone reading on your Vessel Wellness card requires increased attention to your diet. Ketones are produced when carbohydrate intake is very low, typically 20-50g/day, healthy fat intake is high, roughly 70% of caloric intake, and protein intake is moderate.", comment: ""),
                    "keto-top-right",
                    .push)
                    
                case .KETO_ELEVATED_1:
                    return (NSLocalizedString("Your Ketones are Elevated", comment: ""),
                    NSLocalizedString("Great job you are in ketosis! This means that your body is producing ketones as an alternate fuel source and you may be reaping the benefits of improved energy, focus, and healthy weight management.", comment: ""),
                    "keto-top-right",
                    .push)
                    
                case .KETO_HIGH_1:
                    return (NSLocalizedString("Your Ketones are High", comment: ""),
                    NSLocalizedString("Long periods of intermittent fasting, exercising regularly or testing with a Vessel card shortly after exercise may show an elevated reading. High ketones may also be a sign of diabetic ketoacidosis (DKA), a life-threatening condition associated with Type 1 Diabetes or alcoholism.", comment: ""),
                    "keto-top-right",
                            .fade)
                case .KETO_HIGH_2:
                    return (NSLocalizedString("We Recommend", comment: ""),
                    NSLocalizedString("We recommend speaking with your primary care doctor if you continue to receive a high ketone level.", comment: ""),
                    "keto-top-right",
                    .push)
                    
                case .B7_LOW_1:
                    return (NSLocalizedString("Your Biotin Levels are Low", comment: ""),
                    NSLocalizedString("Studies show Biotin plays a role in improving energy, glowing skin, and balanced digestion due to its function in converting your food into energy as well as regulating gene expression.", comment: ""),
                    "b7-top-right",
                            .fade)
                case .B7_LOW_2:
                    return (NSLocalizedString("Reasons Your Biotin is Low", comment: ""),
                    NSLocalizedString("The most common cause of low Biotin is not consuming enough through your diet. Other causes may include alcohol consumption and long-term use of certain medications. With proper food and supplementation, your Biotin levels may improve in a few days!", comment: ""),
                    "b7-top-right",
                    .push)
                    
                case .CORT_LOW_1:
                    return (NSLocalizedString("Your Cortisol Levels are Low", comment: ""),
                    NSLocalizedString("Cortisol is an incredibly important steroid hormone naturally produced in our body for a variety of reasons such as to regulate metabolism, a balanced mood, enhance immunity, blood pressure, blood sugar, and our sleep/wake cycles!", comment: ""),
                    "cort-top-right",
                            .fade)
                case .CORT_LOW_2:
                    return (NSLocalizedString("What Low Cortisol Could Mean", comment: ""),
                    NSLocalizedString("Low cortisol can be a signal your body has experienced high amounts of stress for long periods of time and your adrenal glands may have difficulty creating enough cortisol. Since it took a while to tire out your adrenal glands, it may take weeks to months of addressing life stressors, diet, sleep, and supplementation to notice a change in cortisol levels.", comment: ""),
                    "cort-top-right",
                    .push)
                    
                case .CORT_HIGH_1:
                    return (NSLocalizedString("Your Cortisol Levels are High", comment: ""),
                    NSLocalizedString("Cortisol is an incredibly important steroid hormone naturally produced in our body for a variety of reasons such as to regulate metabolism, a balanced mood, enhance immunity, blood pressure, blood sugar, and our sleep/wake cycles!", comment: ""),
                    "cort-top-right",
                            .fade)
                case .CORT_HIGH_2:
                    return (NSLocalizedString("What High Cortisol Could Mean", comment: ""),
                    NSLocalizedString("High cortisol may be a signal that your stress levels are elevated. Stress can be physical, emotional, psychological, environmental, infectious, or any combination. By addressing life stressors, diet, sleep, and supplementation you should notice a change in cortisol levels within a few weeks to a few months.", comment: ""),
                    "cort-top-right",
                    .push)
                    
                default:
                return ("", "", "", .dismiss)
            }
        }
        currentScreen -= 1
        return ("", "", "", .dismiss)
    }
}
