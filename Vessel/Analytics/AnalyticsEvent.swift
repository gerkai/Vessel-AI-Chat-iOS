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
