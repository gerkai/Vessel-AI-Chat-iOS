//
//  AnalyticsEvent.swift
//  Vessel
//
//  Created by Nicolas Medina on 7/12/22.
//

import Foundation

enum AnalyticsEvent
{
    case accountDeleted
    case activityAdded(activityId: Int, activityName: String)
    case activityComplete(activityId: Int, activityName: String, completed: Bool)
    case activityShown(activityId: Int, activityName: String)
    case appReviewComments(text: String)
    case appReviewFeedback(text: String)
    case appReviewGoToStore(value: Bool)
    case cancelButtonTapped
    case cameraOpened
    case continuePastTimer
    case dontForgetShown
    case everythingComplete(date: String, numberOfActivities: Int, numberOfFoods: Int, totalWaterAmount: Int, completedInsights: Int)
    case foodAdded(foodId: Int, foodName: String)
    case foodComplete(foodId: Int, foodName: String, completed: Bool)
    case foodShown(foodId: Int, foodName: String)
    case forgotPassword
    case identification(type: AnalyticsIdentificationType)
    case lessonCompleted(lessonId: Int, lessonName: String)
    case lessonStarted(lessonId: Int, lessonName: String)
    case logIn(loginType: AnalyticsLoginType)
    case sampleImageCaptured(attemptTimeMs: Int, cardUUID: String)
    case sampleImageConfirmed(cardUUID: String)
    case scanError(errorString: String)
    case signUp(loginType: AnalyticsLoginType)
    case skipCaptureTimer
    case startCaptureTimer
    case testTaken
    case vButtonTapped
    case viewedPage(screenName: String, flowName: AnalyticsFlowName, associatedValue: String? = nil)
    case waterAdded
    case waterComplete(waterAmount: Int, totalWaterAmount: Int)
    
    var name: String
    {
        switch self
        {
        case .accountDeleted: return "Account Deleted"
        case .activityAdded: return "Activity Added"
        case .activityComplete: return "Activity Complete"
        case .activityShown: return "Activity Shown"
        case .appReviewComments: return "App Review Comments"
        case .appReviewFeedback: return "App Review Feedback"
        case .appReviewGoToStore: return "App Review Go To Store"
        case .cancelButtonTapped: return "CANCEL TAKE TEST"
        case .cameraOpened: return "CAMERA OPENED"
        case .continuePastTimer: return "CONTINUE PAST TIMER"
        case .dontForgetShown: return "Don't Forget Popup Shown"
        case .everythingComplete: return "Everything Complete"
        case .foodAdded: return "Food Added"
        case .foodComplete: return "Food Complete"
        case .foodShown: return "Food Shown"
        case .forgotPassword: return "Forgot Password"
        case .identification: return "Identification"
        case .lessonCompleted: return "Lesson Completed"
        case .lessonStarted: return "Lesson Started"
        case .logIn: return "Log In"
        case .sampleImageCaptured: return "SAMPLE IMAGE CAPTURED"
        case .sampleImageConfirmed: return "SAMPLE IMAGE CONFIRMED"
        case .scanError: return "SCAN ERROR"
        case .signUp: return "Sign Up"
        case .skipCaptureTimer: return "SKIP TIMER"
        case .startCaptureTimer: return "START TIMER"
        case .testTaken: return "TEST TAKEN"
        case .vButtonTapped: return "TAKE TEST V BUTTON"
        case .viewedPage: return "Viewed Page"
        case .waterAdded: return "Water Added"
        case .waterComplete: return "Water Complete"
        }
    }
    
    var properties: [String: Any]
    {
        switch self
        {
        case .accountDeleted:
            return [:]
        case .activityAdded(let activityId, let activityName):
            return ["Activity ID": activityId,
                    "Activity Name": activityName]
        case .activityComplete(let activityId, let activityName, let completed):
            return ["Activity ID": activityId,
                    "Activity Name": activityName,
                    "Completed": completed]
        case .activityShown(let activityId, let activityName):
            return ["Activity ID": activityId,
                    "Activity Name": activityName]
        case .appReviewComments(let text):
            return ["text": text]
        case .appReviewFeedback(let text):
            return ["text": text]
        case .appReviewGoToStore(let value):
            return ["value": value]
        case .cancelButtonTapped:
            return [:]
        case .cameraOpened:
            return [:]
        case .continuePastTimer:
            return [:]
        case .dontForgetShown:
            return [:]
        case .everythingComplete(let date, let numberOfActivities, let numberOfFoods, let totalWaterAmount, let completedInsights):
            return ["Date": date,
                    "Number of Activities": numberOfActivities,
                    "Number of Foods": numberOfFoods,
                    "Total Water Amount": totalWaterAmount,
                    "Completed Insights": completedInsights]
        case .foodAdded(let foodId, let foodName):
            return ["Food ID": foodId,
                    "Food Name": foodName]
        case .foodComplete(let foodId, let foodName, let completed):
            return ["Food ID": foodId,
                    "Food Name": foodName,
                    "Completed": completed]
        case .foodShown(let foodId, let foodName):
            return ["Food ID": foodId,
                    "Food Name": foodName]
        case .forgotPassword:
            return [:]
        case .identification(let identificationType):
            return ["Type": identificationType.rawValue]
        case .lessonCompleted(let lessonId, let lessonName):
            return ["Lesson ID": lessonId,
                    "Lesson Name": lessonName]
        case .lessonStarted(let lessonId, let lessonName):
            return ["Lesson ID": lessonId,
                    "Lesson Name": lessonName]
        case .logIn(let loginType):
            return ["Login Type": loginType.rawValue]
        case .sampleImageCaptured(let captureTime, let cardUUID):
            return ["attempt_time_ms": captureTime, "wellness_card_uuid": cardUUID]
        case .sampleImageConfirmed(let cardUUID):
            return ["wellness_card_uuid": cardUUID]
        case .scanError(let errorString):
            return ["error": errorString]
        case .signUp(let loginType):
            return ["Login Type": loginType.rawValue]
        case .skipCaptureTimer:
            return [:]
        case .startCaptureTimer:
            return [:]
        case .testTaken:
            return [:]
        case .vButtonTapped:
            return [:]
        case .viewedPage(let screenName, let flowName, let associatedValue):
            if let associatedValue = associatedValue
            {
                return["Screen Name": screenName,
                       "Flow Name": flowName.rawValue,
                       "Associated Value": associatedValue]
            }
            else
            {
                return["Screen Name": screenName,
                       "Flow Name": flowName.rawValue]
            }
        case .waterAdded:
            return [:]
        case .waterComplete(let waterAmount, let totalWaterAmount):
            return ["Water Amount": waterAmount,
                    "Total Water Amount": totalWaterAmount]
        }
    }
}

enum AnalyticsFlowName: String
{
    case afterTestFlow = "After Test Flow"
    case coachTabFlow = "Coach Tab Flow"
    case lessonsFlow = "Lessons Flow"
    case loginFlow = "Login Flow"
    case moreTabFlow = "More Tab Flow"
    case onboardingFlow = "Onboarding Flow"
    case resultsTabFlow = "Results Tab Flow"
    case takeTestFlow = "Take Test Flow"
    case todayTabFlow = "Today Tab Flow"
    case appReviewFlow = "App Review Flow"
}

enum AnalyticsLoginType: String
{
    case email = "Email"
    case apple = "Apple"
    case google = "Google"
}

enum AnalyticsIdentificationType: String
{
    case purchased = "Purchased"
    case gifted = "Gifted"
    case dontHaveYet = "Dont Have Yet"
}
