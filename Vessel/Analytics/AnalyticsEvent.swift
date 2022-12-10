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
    case capturedCard
    case cardScanningStarted
    case dontForgetShown
    case foodAdded(foodId: Int, foodName: String)
    case foodComplete(foodId: Int, foodName: String, completed: Bool)
    case foodShown(foodId: Int, foodName: String)
    case forgotPassword
    case identification(type: AnalyticsIdentificationType)
    case lessonCompleted(lessonId: Int, lessonName: String)
    case lessonStarted(lessonId: Int, lessonName: String)
    case logIn(loginType: AnalyticsLoginType)
    case scanError(errorString: String)
    case signUp(loginType: AnalyticsLoginType)
    case skipCaptureTimer
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
        case .capturedCard: return "Captured Card"
        case .cardScanningStarted: return "Card Scanning Started"
        case .dontForgetShown: return "Don't Forget Popup Shown"
        case .foodAdded: return "Food Added"
        case .foodComplete: return "Food Complete"
        case .foodShown: return "Food Shown"
        case .forgotPassword: return "Forgot Password"
        case .identification: return "Identification"
        case .lessonCompleted: return "Lesson Completed"
        case .lessonStarted: return "Lesson Started"
        case .logIn: return "Log In"
        case .scanError: return "Scan Error"
        case .signUp: return "Sign Up"
        case .skipCaptureTimer: return "Skip Capture Timer"
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
        case .capturedCard:
            return [:]
        case .cardScanningStarted:
            return [:]
        case .dontForgetShown:
            return [:]
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
        case .scanError(let errorString):
            return ["Error Type:": errorString]
        case .signUp(let loginType):
            return ["Login Type": loginType.rawValue]
        case .skipCaptureTimer:
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
