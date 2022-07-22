//
//  MixpanelAnalytics.swift
//  Vessel
//
//  Created by Nicolas Medina on 7/11/22.
//

import Foundation
import Mixpanel

class MixpanelAnalytics: Analytics
{
    private var analyticsToken: String
    {
        let environment = UserDefaults.standard.integer(forKey: Constants.environmentKey)
        switch environment
        {
            case Constants.DEV_INDEX:
                return Constants.DevMixpanelToken
            case Constants.STAGING_INDEX:
                return Constants.StagingMixpanelToken
            default:
                return Constants.ProdMixpanelToken
        }
    }
    
    private var analyticsAppSecret: String
    {
        let environment = UserDefaults.standard.integer(forKey: Constants.environmentKey)
        switch environment
        {
            case Constants.DEV_INDEX:
                return Constants.DevMixpanelAPISecret
            case Constants.STAGING_INDEX:
                return Constants.StagingMixpanelAPISecret
            default:
                return Constants.ProdMixpanelAPISecret
        }
    }
    
    func setup()
    {
        Mixpanel.initialize(token: analyticsToken)
    }
    
    func log(event: AnalyticsEvent)
    {
        guard let properties = event.properties as? [String: MixpanelType] else
        {
            fatalError("Not valid types found in properties for event: \(event)")
        }
        Mixpanel.mainInstance().track(event: event.name, properties: properties)
    }
    
    func setSuperProperty(property: String, value: Any)
    {
        setSuperProperties(properties: [property: value])
    }
    
    func setSuperProperties(properties: [String: Any])
    {
        let mixpanelProperties = properties.compactMapValues
        { value in
            return value as? MixpanelType
        }
        
        Mixpanel.mainInstance().registerSuperProperties(mixpanelProperties)
    }
    
    func identify(id: String)
    {
        Mixpanel.mainInstance().identify(distinctId: id)
    }
    
    func setUserProperty(property: String, value: Any)
    {
        setUserProperties(properties: [property: value])
    }
    
    func setUserProperties(properties: [String: Any])
    {
        let mixpanelProperties = properties.compactMapValues
        { value in
            return value as? MixpanelType
        }
        
        Mixpanel.mainInstance().people.set(properties: mixpanelProperties)
    }
}
