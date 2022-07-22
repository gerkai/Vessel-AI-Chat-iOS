//
//  AppConstants.swift
//  Vessel
//
//  Created by Carson Whitsett on 2/25/22.
//

import UIKit

struct Constants
{
    //website links
    static let websiteURL = "https://vesselhealth.com/pages"
    static let privacyPolicyURL = "\(websiteURL)/privacy-policy.html"
    static let termsOfServiceURL = "\(websiteURL)/terms-of-service.html"
    
    //media
    static let mediaPath = "https://dittylabs.com/temp/vessel"
    static let testCardTutorialVideo = "test_card_tutorial.mp4"
    static let timerFirstVideo = "timer_first_video.mp4"
    static let timerSecondVideo = "timer_second_video.mp4"
    
    //server environment
    static let environmentKey = "Environment"
    //TODO: swap DEV_INDEX and PROD_INDEX before release. Currently we default to DEV_INDEX so app starts pointing to dev environment
    //which is the only environment that works with /v3 currently.
    //Also update the segmented control tabs in DebugViewController
    static let DEV_INDEX = 0
    static let STAGING_INDEX = 1
    static let PROD_INDEX = 2
    
    static let MinimumPasswordLength: Int = 6
    
    //analytics
    static let ProdMixpanelToken = "d3e262e686a9df32346c3825102b9f39"
    static let ProdMixpanelAPISecret = "f64ce29607e303927a7634ba44d5a6bb"
    static let StagingMixpanelToken = "3cce6aca0474012d5ec516506a41a619"
    static let StagingMixpanelAPISecret = "610c3dfe0f47112e309797c8e266a2f6"
    static let DevMixpanelToken = "c59e2fe4109393b804d14910f37323b1"
    static let DevMixpanelAPISecret = "879879b5f7e32ff541ff968e5b249429"
    
    //used for reducing content on smaller screens
    static let SMALL_SCREEN_HEIGHT_THRESHOLD = 700.0
    
    //geometry
    static let MIN_VERT_SPACING_TO_BACK_BUTTON = 20.0
    static let CORNER_RADIUS = 22.0
    static let CHECK_BUTTON_HEIGHT = 60.0
    static let SMALL_SCREEN_CHECK_BUTTON_HEIGHT = 50.0
    
    //colors
    static let DARK_GRAY_TRANSLUCENT = UIColor.init(red: 0.0863, green: 0.0824, blue: 0.0784, alpha: 0.7)
    static let VESSEL_BLACK = UIColor.init(red: 22.0 / 255.0, green: 21.0 / 255.0, blue: 20.0 / 255.0, alpha: 1.0)
    static let SOLID_BLACK = UIColor.black
    
    //common date formats
    static let SERVER_DATE_FORMAT = "yyyy-MM-dd"
    
    //demographics
    static let GENDER_MALE = "m"
    static let GENDER_FEMALE = "f"
    static let GENDER_OTHER = "o"
    static let MAX_HEIGHT_METRIC = 302
    static let MIN_HEIGHT_METRIC = 61
    static let DEFAULT_HEIGHT = 168 /*cm (5' 6") */
    static let MIN_AGE = 18
    static let MAX_AGE = 100
    static let AVERAGE_AGE = 37 /* determines default date picker date in onboarding */
    
    //UserDefaults Keys
    static let KEY_DEFAULT_LOGIN_EMAIL = "KEY_DEFAULT_LOGIN_EMAIL"
    static let KEY_DEFAULT_LOGIN_PASSWORD = "KEY_DEFAULT_LOGIN_PASSWORD"
    static let KEY_DEFAULT_WEIGHT_LBS = "KEY_DEFAULT_WEIGHT_LBS"
    
    //Database IDs
    static let ID_NO_DIETS = 17
    static let ID_NO_ALLERGIES = 20
    
    //Contact Flags
    static let DECLINED_BIRTH_DATE          = 0x00000001
    static let HIDE_PEE_TIPS                = 0x00000002
    static let HIDE_DROPLET_TIPS            = 0x00000004
    
    //Colors
    static let vesselBlack   = #colorLiteral(red: 0.0862745098, green: 0.08235294118, blue: 0.07843137255, alpha: 1)    //#161514
    static let vesselGray   = #colorLiteral(red: 0.3289078772, green: 0.3246636391, blue: 0.3246636391, alpha: 1)     //#545353
    
    //Misc
    static let MAX_GOALS_AT_A_TIME = 3 /* max goals a user can select during onboarding */
    static let MORNING_TEST_TIME_START = 4 /* 4am */
    static let MORNING_TEST_TIME_END = 9 /* 9am */
    static let CARD_ACTIVATION_SECONDS = 180.0  /* defines how much time user has to wait for card to activate */
    
    //Common Strings
    static let DONT_SHOW_AGAIN_STRING = NSLocalizedString("Don't show this again", comment: "")
}
