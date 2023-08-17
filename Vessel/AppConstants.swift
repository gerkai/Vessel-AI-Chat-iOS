//
//  AppConstants.swift
//  Vessel
//
//  Created by Carson Whitsett on 2/25/22.
//

import UIKit

extension Notification.Name
{
    //when an item is checked on Food Preferences, this notification informs the other cells to update their checked/unchecked status.
    static let updateCheckmarks = Notification.Name("UpdateCheckmarks")
    
    //when new data arrives from back end, this notification gets sent with the CoreObject type. Interested parties
    //can update themselves. Used for updating the results tab when a new Result arrives.
    static let newDataArrived = Notification.Name("NewDataArrived")
    static let newPlanAddedOrRemoved = Notification.Name("newPlanAddedOrRemoved")
    static let selectTabNotification = Notification.Name("SelectTab")
    static let foodPreferencesChangedNotification = Notification.Name("FoodPreferencesChanged")
    static let showSplashScreen = Notification.Name("ShowSplashScreen") //specify a bool object to show/hide
    static let selectChartViewCell = Notification.Name("SelectChartViewCell") //so all charts can by in sync
    static let gotCobrandingImage = Notification.Name("GotCobrandingImage") //let splash screen know cobranding arrived late
}

struct Constants
{
    //website links
    static let websiteURL = "https://vesselhealth.com/pages"
    static let privacyPolicyURL = "\(websiteURL)/privacy-policy.html"
    static let termsOfServiceURL = "\(websiteURL)/terms-of-service.html"
    static let zenDeskSupportURL = "https://vesselhealth.zendesk.com/hc/en-us"
    static let orderSupplementsURL = "https://vesselhealth.com/membership"
    
    //media
    static let mediaPath = "https://media.vesselhealth.com"
    static let testCardTutorialVideo = "test_card_tutorial.mp4"
    static let timerFirstVideo = "timer_first_video.mp4"
    static let timerSecondVideo = "timer_second_video.mp4"
    
    //server environment
    static let environmentKey = "Environment"

    //Also update the segmented control tabs in DebugViewController
    static let PROD_INDEX = 0
    static let STAGING_INDEX = 1
    static let DEV_INDEX = 2
    static let MinimumPasswordLength: Int = 6
    enum AWS
    {
        static let transferUtilityKey = "vessel-health-transfer-utility"
        
        static let WellnessSampleImagesBucket = Server.shared.S3BucketName()
        
        static let accessKey = Server.shared.S3AccessKey()
        static let secretKey = Server.shared.S3SecretKey()
    }
    static let LiveChatLicenseID = "13081182"

    //analytics
    static let ProdMixpanelToken = "d3e262e686a9df32346c3825102b9f39"
    static let ProdMixpanelAPISecret = "f64ce29607e303927a7634ba44d5a6bb"
    static let StagingMixpanelToken = "3cce6aca0474012d5ec516506a41a619"
    static let StagingMixpanelAPISecret = "610c3dfe0f47112e309797c8e266a2f6"
    static let DevMixpanelToken = "c59e2fe4109393b804d14910f37323b1"
    static let DevMixpanelAPISecret = "879879b5f7e32ff541ff968e5b249429"
    
    //Bugsee
    static let bugseeKey = "552f7749-4035-41e4-8c1b-895630d6ef84"
    
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
    static let vesselBlack = #colorLiteral(red: 0.0862745098, green: 0.08235294118, blue: 0.07843137255, alpha: 1)    //#161514
    static let vesselGray = #colorLiteral(red: 0.3289078772, green: 0.3246636391, blue: 0.3246636391, alpha: 1)     //#545353
    static let vesselPoor = #colorLiteral(red: 0.9043522477, green: 0.7674039006, blue: 0.6951909661, alpha: 1)     //#E7C4B1
    static let vesselFair = #colorLiteral(red: 0.9455940127, green: 0.8627095222, blue: 0.8065157533, alpha: 1)     //#F1DCCe
    static let vesselGood = #colorLiteral(red: 0.8588235294, green: 0.9215686275, blue: 0.8352941176, alpha: 1)     //#DBEBD5
    static let vesselGreat = #colorLiteral(red: 0.7568627451, green: 0.8705882353, blue: 0.7294117647, alpha: 1)     //#C1DEBA
    static let vesselTope = #colorLiteral(red: 0.831372549, green: 0.7960784314, blue: 0.7725490196, alpha: 1)      //#D4CBC5
    static let vesselPeach = #colorLiteral(red: 0.9843137255, green: 0.9647058824, blue: 0.9294117647, alpha: 1)     //FBF6ED
    static let vesselChatGreen = #colorLiteral(red: 0.8156862745, green: 0.8862745098, blue: 0.7843137255, alpha: 1) //d0e2c8
    
    //common date formats
    static let SERVER_DATE_FORMAT = "yyyy-MM-dd"
    static let PRESENTATION_DATE_FORMAT = "dd MM yyyy"
    static let VERBOSE_FORMAT = "d MMMM"
    static let ISO_DATE_FORMAT = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
    static let DAY_INITIAL_DATE_FORMAT = "EEEEE"
    
    //demographics
    static let GENDER_MALE = "m"
    static let GENDER_FEMALE = "f"
    static let GENDER_OTHER = "o"
    static let MAX_HEIGHT_METRIC = 302
    static let MIN_HEIGHT_METRIC = 61
    static let MIN_WEIGHT_IMPERIAL: Double = 50.0
    static let MAX_WEIGHT_IMPERIAL: Double = 500.0
    static let DEFAULT_HEIGHT = 168 /*cm (5' 6") */
    static let MIN_AGE = 18
    static let MAX_AGE = 100
    static let AVERAGE_AGE = 37 /* determines default date picker date in onboarding */
    
    //UserDefaults Keys
    static let KEY_DEBUG_MENU = "KEY_DEBUG_MENU"
    static let KEY_DEBUG_LOG = "KEY_DEBUG_LOG"
    static let KEY_DEFAULT_LOGIN_EMAIL = "KEY_DEFAULT_LOGIN_EMAIL"
    static let KEY_DEFAULT_LOGIN_PASSWORD = "KEY_DEFAULT_LOGIN_PASSWORD"
    static let KEY_DEFAULT_WEIGHT_LBS = "KEY_DEFAULT_WEIGHT_LBS"
    static let KEY_BYPASS_SCANNING = "KEY_BYPASS_SCANNING"
    static let KEY_PRINT_NETWORK_TRAFFIC = "KEY_PRINT_NETWORK_TRAFFIC"
    static let KEY_SHOW_DEBUG_DRAWING = "KEY_SHOW_DEBUG_DRAWING"
    static let KEY_PRINT_INIT_DEINIT = "KEY_PRINT_INIT_DEINIT"
    static let KEY_RELAXED_SCANNING_DISTANCE = "KEY_RELAXED_SCANNING_DISTANCE"
    static let KEY_ENABLE_CHAT_GPT_COACH = "KEY_ENABLE_CHAT_GPT_COACH"
    static let KEY_ENABLE_FUEL = "KEY_ENABLE_FUEL"
    
    static let KEY_ERASE_ALL = "KEY_ERASE_ALL"
    static let KEY_ERASE_ACTIVITIES = "KEY_ERASE_ACTIVITIES"
    static let KEY_ERASE_CURRICULUMS = "KEY_ERASE_CURRICULUMS"
    static let KEY_ERASE_FOOD = "KEY_ERASE_FOODS"
    static let KEY_ERASE_LESSONS = "KEY_ERASE_LESSONS"
    static let KEY_ERASE_PLANS = "KEY_ERASE_PLANS"
    static let KEY_ERASE_RESULTS = "KEY_ERASE_RESULTS"
    static let KEY_ERASE_STEPS = "KEY_ERASE_STEPS"
    
    static let KEY_ERASE_STORED_LESSONS = "KEY_ERASE_STORED_LESSONS"
    static let KEY_RESET_LESSON_PROGRESS = "KEY_RESET_LESSON_PROGRESS"
    static let KEY_NEW_LESSON_DAY = "KEY_NEW_LESSON_DAY"
    static let KEY_USE_MOCK_RESULTS = "KEY_USE_MOCK_RESULTS"
    static let KEY_FORCE_APP_REVIEW = "KEY_FORCE_APP_REVIEW"
    static let KEY_LAST_OPENED_DAY = "KEY_LAST_OPENED_DAY"
    static let ALLOW_BUGSEE_KEY = "ALLOW_BUGSEE"
    static let KEY_FIRST_LAUNCH_DATE = "KEY_FIRST_LAUNCH_DATE"
    static let KEY_PRACTITIONER_IMAGE_URL = "KEY_PRACTITIONER_IMAGE_URL"
    static let KEY_PRACTITIONER_ID = "KEY_PRACTITIONER_ID"
    static let KEY_USE_SHORT_PERIODS_FOR_TAKE_A_TEST_PUSHES = "KEY_USE_SHORT_PERIODS_FOR_TAKE_A_TEST_PUSHES"
    static let KEY_USE_SHORT_PERIODS_FOR_GENERAL_WELLNESS_PUSHES = "KEY_USE_SHORT_PERIODS_FOR_GENERAL_WELLNESS_PUSHES"
    static let KEY_USE_SHORT_PERIODS_FOR_REMINDERS_PUSHES = "KEY_USE_SHORT_PERIODS_FOR_REMINDERS_PUSHES"
    static let KEY_USE_SHORT_PERIODS_FOR_FUEL_PUSHES = "KEY_USE_SHORT_PERIODS_FOR_FUEL_PUSHES"
    
    //Contact Flags (App Flags on back end)
    static let DECLINED_BIRTH_DATE          = 0x00000001
    static let HIDE_PEE_TIPS                = 0x00000002
    static let HIDE_DROPLET_TIPS            = 0x00000004
    static let SAW_MAGNESIUM_INFO           = 0x00000008
    static let SAW_SODIUM_INFO              = 0x00000010
    static let SAW_CALCIUM_INFO             = 0x00000020
    static let SAW_VITAMIN_C_INFO           = 0x00000040
    static let SAW_PH_LOW_INFO              = 0x00000080
    static let SAW_PH_HIGH_INFO             = 0x00000100
    static let SAW_HYDRATION_LOW_INFO       = 0x00000200
    static let SAW_HYDRATION_HIGH_INFO      = 0x00000400
    static let SAW_KETONES_LOW_INFO         = 0x00000800
    static let SAW_KETONES_ELEVATED_INFO    = 0x00001000
    static let SAW_KETONES_HIGH_INFO        = 0x00002000
    static let SAW_B7_LOW_INFO              = 0x00004000
    static let SAW_CORTISOL_LOW_INFO        = 0x00008000
    static let SAW_CORTISOL_HIGH_INFO       = 0x00010000
    static let SAW_TESTING_REMINDER         = 0x00020000
    static let SAW_INSIGHT_POPUP            = 0x00040000
    static let SAW_ACTIVITY_POPUP           = 0x00080000
    static let SAW_WELLNESS_POPUP           = 0x00100000
    static let SAW_COACH_POPUP              = 0x00200000
    static let SAW_REAGENT_POPUP            = 0x00400000
    static let HAS_RATED_APP                = 0x00800000
    
    //Misc
    static let MAX_GOALS_AT_A_TIME = 3 /* max goals a user can select during onboarding */
    static let MIN_GOALS_AT_A_TIME = 1 /* min goals a user can select during onboarding */
    static let MORNING_TEST_TIME_START = 4 /* 4am */
    static let MORNING_TEST_TIME_END = 9 /* 9am */
    static let CARD_ACTIVATION_SECONDS = 180.0  /* defines how much time user has to wait for card to activate */
    static let TAB_BAR_TODAY_INDEX = 0
    static let TAB_BAR_RESULTS_INDEX = 1
    static let TAB_BAR_COACH_INDEX = 3
    static let TAB_BAR_MORE_INDEX = 4
    static let WATER_GLASSESS_PER_ROW = 9
    static let MINIMUM_WATER_INTAKE = 4
    static let WATER_LIFESTYLE_RECOMMENDATION_ID = 5
    static let CHART_Y_COORDINATE_FOR_BAD_DATA = -10.0 //far enough off chart to not plot visible dot
    static let AFTER_TEST_POP_UP_TIMEOUT = 10.0
    
    static let FUEL_AM_LIFESTYLE_RECOMMENDATION_ID = 15
    static let FUEL_PM_LIFESTYLE_RECOMMENDATION_ID = 14
    static let GET_SUPPLEMENTS_LIFESTYLE_RECOMMENDATION_ID = 13
    static let TAKE_A_TEST_LIFESTYLE_RECOMMENDATION_ID = 11
    static let WEEKS_UNTIL_START_REMINDING_TAKE_A_TEST_MONTHLY = 5
    
    static let DAYS_OF_THE_WEEK = [NSLocalizedString("Monday", comment: ""), NSLocalizedString("Tuesday", comment: ""), NSLocalizedString("Wednesday", comment: ""), NSLocalizedString("Thursday", comment: ""), NSLocalizedString("Friday", comment: ""), NSLocalizedString("Saturday", comment: ""), NSLocalizedString("Sunday", comment: "")]
    static let ABBREVIATED_WEEK_DAYS = [NSLocalizedString("Mon", comment: ""), NSLocalizedString("Tue", comment: ""), NSLocalizedString("Wed", comment: ""), NSLocalizedString("Thu", comment: ""), NSLocalizedString("Fri", comment: ""), NSLocalizedString("Sat", comment: ""), NSLocalizedString("Sun", comment: "")]
    static let REMINDERS_DEFAULT_TIMES = [NSLocalizedString("Morning", comment: ""), NSLocalizedString("Daytime", comment: ""), NSLocalizedString("Evening", comment: "")]

    //Common Strings
    static let DONT_SHOW_AGAIN_STRING = NSLocalizedString("Don't show this again", comment: "")
    static let INTERNET_CONNECTION_STRING = NSLocalizedString("Please check your internet connection", comment: "")
    static let ENTER_VALID_EMAIL_STRING = NSLocalizedString("Please enter a valid email", comment: "")
    static let ENTER_PASSWORD_STRING = NSLocalizedString("Please enter your password", comment: "")
    static let INCORRECT_PASSWORD_STRING = NSLocalizedString("This email and password combination is incorrect", comment: "")
    static let POOR_STRING = NSLocalizedString("Poor", comment: "")
    static let FAIR_STRING = NSLocalizedString("Fair", comment: "")
    static let GOOD_STRING = NSLocalizedString("Good", comment: "")
    static let GREAT_STRING = NSLocalizedString("Great", comment: "")
    static let HOW_TO_READ_THE_GRAPH = NSLocalizedString("How to read the graph", comment: "")
    static let WHY_IT_MATTERS = NSLocalizedString("Why It Matters", comment: "")
    static let TIPS_TO_IMPROVE = NSLocalizedString("Tips to Improve", comment: "")
    static let AM_SYMBOL = NSLocalizedString("AM", comment: "")
    static let PM_SYMBOL = NSLocalizedString("PM", comment: "")
    
    //Fonts
    static let FontBodyMain16 = UIFont(name: "BananaGrotesk-Regular", size: 16)!
    static let FontTitleMain24 = UIFont(name: "BananaGrotesk-Semibold", size: 24)!
    static let FontTitleMain16 = UIFont(name: "BananaGrotesk-Semibold", size: 16)!
    static let FontTitleBold18 = UIFont(name: "BananaGrotesk-Bold", size: 18)!
    static let FontTitleBold16 = UIFont(name: "BananaGrotesk-Bold", size: 16)!
    static let FontTitleRegular16 = UIFont(name: "BananaGrotesk-Regular", size: 16)!
    static let FontTitleMain12 = UIFont(name: "BananaGrotesk-Semibold", size: 12)!
    static let FontBoldMain28 = UIFont(name: "BananaGrotesk-Bold", size: 28)!
    static let FontBodyAlt16 = UIFont(name: "NoeText-Book", size: 16)!
    static let FontBodyAlt14 = UIFont(name: "NoeText", size: 14.0)!
    static let FontPicker22 = UIFont(name: "BananaGrotesk-Regular", size: 22)!
    static let FontPickerSemibold22 = UIFont(name: "BananaGrotesk-Semibold", size: 22)!
    static let FontLearnMore10 = UIFont(name: "BananaGrotesk-Semibold", size: 10.0)!
    
    //Zendesk
    static let prodZendeskAppId = "b6273136dbc4bea26a8ad79ba27bd254d1f63c1ad9cfe7c9"
    static let devZendeskAppId = "e4ae8e69bbad13f5cc56ebd5539f0feee0d4770850c668f6"
    static let prodZendeskClientId = "mobile_sdk_client_cfeee48b507a629642f2"
    static let devZendeskClientId = "mobile_sdk_client_c13e73cb4f8c7c461a39"
    static let zendeskURL = "https://vesselhealth.zendesk.com"
    static let zendeskAccountKey = "EWda2709qRt8svzTBZIRlwHEnXaBVIwl"
    static let prodZendeskChatAppKey = "310166506647351297"
    static let devZendeskChatAppKey = "310166681225994241"
    
    static func stringForScore(score: Double) -> String
    {
        if score < 0.25
        {
            return Constants.POOR_STRING
        }
        if score < 0.5
        {
            return Constants.FAIR_STRING
        }
        if score < 0.75
        {
            return Constants.GOOD_STRING
        }
        return Constants.GREAT_STRING
    }
    
    static func colorForScore(score: Double) -> UIColor
    {
        if score < 0.25
        {
            return Constants.vesselPoor
        }
        if score < 0.5
        {
            return Constants.vesselFair
        }
        if score < 0.75
        {
            return Constants.vesselGood
        }
        return Constants.vesselGreat
    }
}
