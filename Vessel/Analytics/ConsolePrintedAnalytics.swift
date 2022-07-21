//
//  ConsolePrintedAnalytics.swift
//  Vessel
//
//  Created by Nicolas Medina on 7/16/22.
//

import UIKit

class ConsolePrintedAnalytics: Analytics
{
    func setup()
    {
        print("Analytics: Set up")
    }
    
    func log(event: AnalyticsEvent)
    {
        print("Analytics: Log event \(event.name)")
        print("Analytics:     \(event.properties)")
    }
    
    func setSuperProperty(property: String, value: Any)
    {
        print("Analytics: Set super property \(property)")
        print("Analytics:     \(value)")
    }
    
    func setSuperProperties(properties: [String: Any])
    {
        print("Analytics: Set super properties \(properties)")
    }
    
    func identify(id: String)
    {
        print("Analytics: Identify \(id)")
    }
    
    func setUserProperty(property: String, value: Any)
    {
        print("Analytics: Set user property \(property)")
        print("Analytics:     \(value)")
    }
    
    func setUserProperties(properties: [String: Any])
    {
        print("Analytics: Set user properties \(properties)")
    }
}
