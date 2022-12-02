//
//  AnalyticsEvent.swift
//  Vessel
//
//  Created by Nicolas Medina on 7/12/22.
//

import Foundation

enum AnalyticsEvent
{
    case viewedPage(screenName: String, flowName: AnalyticsFlowName, associatedValue: String? = nil)
    case logIn(loginType: AnalyticsLoginType)
    case signUp(loginType: AnalyticsLoginType)
    case forgotPassword
    case identification(type: AnalyticsIdentificationType)
    case accountDeleted
    case lessonStarted(lessonId: Int, lessonName: String)
    case lessonCompleted(lessonId: Int, lessonName: String)
    case activityAdded(activityId: Int, activityName: String)
    case waterAdded
    case waterComplete(waterAmount: Int, totalWaterAmount: Int)
    case foodAdded(foodId: Int, foodName: String)
    case foodShown(foodId: Int, foodName: String)
    case foodComplete(foodId: Int, foodName: String, completed: Bool)
    
    var name: String
    {
        switch self
        {
        case .viewedPage: return "Viewed Page"
        case .logIn: return "Log In"
        case .signUp: return "Sign Up"
        case .forgotPassword: return "Forgot Password"
        case .identification: return "Identification"
        case .accountDeleted: return "Account Deleted"
        case .lessonStarted: return "Lesson Started"
        case .lessonCompleted: return "Lesson Completed"
        case .activityAdded: return "Activity Added"
        case .waterAdded: return "Water Added"
        case .waterComplete: return "Water Complete"
        case .foodAdded: return "Food Added"
        case .foodShown: return "Food Shown"
        case .foodComplete: return "Food Complete"
        }
    }
    
    var properties: [String: Any]
    {
        switch self
        {
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
        case .logIn(let loginType):
            return ["Login Type": loginType.rawValue]
        case .signUp(let loginType):
            return ["Login Type": loginType.rawValue]
        case .forgotPassword:
            return [:]
        case .identification(let identificationType):
            return ["Type": identificationType.rawValue]
        case .accountDeleted:
            return [:]
        case .lessonStarted(let lessonId, let lessonName):
            return ["Lesson ID": lessonId,
                    "Lesson Name": lessonName]
        case .lessonCompleted(let lessonId, let lessonName):
            return ["Lesson ID": lessonId,
                    "Lesson Name": lessonName]
        case .activityAdded(let activityId, let activityName):
            return ["Activity ID": activityId,
                    "Activity Name": activityName]
        case .waterAdded:
            return [:]
        case .waterComplete(let waterAmount, let totalWaterAmount):
            return ["Water Amount": waterAmount,
                    "Total Water Amount": totalWaterAmount]
        case .foodAdded(let foodId, let foodName):
            return ["Food ID": foodId,
                    "Food Name": foodName]
        case .foodShown(let foodId, let foodName):
            return ["Food ID": foodId,
                    "Food Name": foodName]
        case .foodComplete(let foodId, let foodName, let completed):
            return ["Food ID": foodId,
                    "Food Name": foodName,
                    "Completed": completed]
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
