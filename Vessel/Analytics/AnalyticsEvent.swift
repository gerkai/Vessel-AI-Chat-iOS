//
//  AnalyticsEvent.swift
//  Vessel
//
//  Created by Nicolas Medina on 7/12/22.
//

import Foundation

enum AnalyticsEvent
{
    case viewedPage(screenName: AnalyticsScreenName)
    case logIn(loginType: AnalyticsLoginType)
    case signUp(loginType: AnalyticsLoginType)
    case forgotPassword
    case identification(type: AnalyticsIdentificationType)
    case back(screenName: AnalyticsScreenName)
    case accountDeleted
    
    var name: String
    {
        switch self
        {
        case .viewedPage: return "Viewed Page"
        case .logIn: return "Log In"
        case .signUp: return "Sign Up"
        case .forgotPassword: return "Forgot Password"
        case .identification: return "Identification"
        case .back: return "Back"
        case .accountDeleted: return "Account Deleted"
        }
    }
    
    var properties: [String: Any]
    {
        switch self
        {
        case .viewedPage(let screenName):
            return ["Screen Name": screenName.rawValue]
        case .logIn(let loginType):
            return ["Login Type": loginType.rawValue]
        case .signUp(let loginType):
            return ["Login Type": loginType.rawValue]
        case .forgotPassword:
            return [:]
        case .identification(let identificationType):
            return ["Type": identificationType.rawValue]
        case .back(let screenName):
            return ["Screen Name": screenName.rawValue]
        case .accountDeleted:
            return [:]
        }
    }
}

enum AnalyticsScreenName: String
{
    case main = "Main"
    case welcomeBack = "Welcome Back"
    case debugMenu = "Debug Menu"
    case welcome = "Welcome"
    case identification = "Identification"
    case boughtOnWebsite = "Bought On Website"
    case gifted = "Gifted"
    case dontHaveYet = "Dont Have Yet"
    case existing = "Existing"
    case create = "Create"
    case forgotPassword = "Forgot Password"
    case forgotPasswordSuccess = "Forgot Password Success"
    case moreTab = "More Tab"
    case myAccount = "My Account"
    case profile = "Profile"
    case changePassword = "Change Password"
    case choosePhoto = "Choose Photo"
    case deleteAccount = "Unsubscribe"
    case foodPreferencesDiet = "Food Preferences Diet"
    case foodPreferencesAllergies = "Food Preferences Allergies"
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
