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
    case insightsFeature

    static var allKeys: [String]
    {
        return [RemoteConfigKey.insightsFeature.key]
    }
    
    var key: String
    {
        switch self
        {
        case .insightsFeature:
            return "insights_feature"
        }
    }
    
    var value: Any
    {
        switch self
        {
        case .insightsFeature:
            return RemoteConfig.remoteConfig()[key].boolValue
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
                NotificationCenter.default.post(name: .newDataArrived, object: nil, userInfo: ["objectType": String(describing: Lesson.self)])
            }
        }
    }
    
    private let remoteConfig = RemoteConfig.remoteConfig()
//    private var values = UserDefaults.standard.object(forKey: Constants.RC_STATUS) as? [String: Any]

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
            // Needded if we want to load something urgent at startup
//            self.displayWelcome()
        }
    }
    
    func getValue(for key: RemoteConfigKey) -> Any?
    {
        return key.value
    }
}