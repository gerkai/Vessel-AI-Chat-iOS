//
//  RemoteConfigManager.swift
//  Vessel
//
//  Created by Nicolas Medina on 11/22/22.
//

import Foundation
import FirebaseRemoteConfig

enum RemoteConfigKey
{
    // Feature flag
    case progressDaysFeature
    case insightsFeature
    case activitiesFeature
    case foodFeature
    case waterFeature
    case remindersFeature
    
    // Config
    case minimumSupportedVersion
    
    static var allKeys: [String]
    {
        return [RemoteConfigKey.insightsFeature.key]
    }
    
    var key: String
    {
        switch self
        {
        case .progressDaysFeature:
            return "progress_days_feature"
        case .insightsFeature:
            return "insights_feature"
        case .activitiesFeature:
            return "activities_feature"
        case .foodFeature:
            return "food_feature"
        case .waterFeature:
            return "water_feature"
        case .remindersFeature:
            return "reminders_feature"
        case .minimumSupportedVersion:
            return "app_min_version"
        }
    }
    
    var value: Any
    {
        switch self
        {
        case .progressDaysFeature, .insightsFeature, .activitiesFeature, .foodFeature, .waterFeature, .remindersFeature:
            return RemoteConfig.remoteConfig()[key].boolValue
        case .minimumSupportedVersion:
            return RemoteConfig.remoteConfig()[key].stringValue ?? "1.0"
        }
    }
}

class RemoteConfigManager
{
    static let shared = RemoteConfigManager()
    private init() {}
    
    var remoteConfigLoadedCorrectly = false
    {
        didSet
        {
            if remoteConfigLoadedCorrectly == true
            {
                DispatchQueue.main.async
                {
                    Log_Add("RemoteConfigManager: remoteConfigLoadedCorrectly() - post .newDataArrived: Lesson")
                    NotificationCenter.default.post(name: .newDataArrived, object: nil, userInfo: ["objectType": String(describing: Lesson.self)])
                }
            }
        }
    }
    
    private let remoteConfig = RemoteConfig.remoteConfig()

    func launchRemoteConfig()
    {
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        remoteConfig.setDefaults(fromPlist: "remote_config_defaults")
        
        remoteConfig.fetch { (status, error) -> Void in
            if status == .success
            {
                print("Config fetched!")
                self.remoteConfig.activate { changed, error in
                    self.remoteConfigLoadedCorrectly = true
                }
            }
            else
            {
                self.remoteConfigLoadedCorrectly = false
                print("Config not fetched")
                print("Error: \(error?.localizedDescription ?? "No error available.")")
            }
        }
    }
    
    func getValue(for key: RemoteConfigKey) -> Any?
    {
        let index = UserDefaults.standard.integer(forKey: Constants.environmentKey)
        switch index
        {
        case Constants.DEV_INDEX, Constants.STAGING_INDEX:
            switch key
            {
            case .progressDaysFeature:
                return true
            case .insightsFeature:
                return true
            case .activitiesFeature:
                return true
            case .foodFeature:
                return true
            case .waterFeature:
                return true
            case .remindersFeature:
                return true
            case .minimumSupportedVersion:
                return "1.0"
            }
        case Constants.PROD_INDEX:
            return key.value
        default:
            return key.value
        }
    }
}
