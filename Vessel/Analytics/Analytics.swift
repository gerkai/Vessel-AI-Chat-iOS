//
//  Analytics.swift
//  Vessel
//
//  Created by Nicolas Medina on 7/11/22.
//
//  Super properties are properties that once added the will be sent on every posterior called event
//  User properties are properties assigned for an specific user but aren't from an event
//  By identifying you can assign an Id to the user, so events are shared between devices (Commonly the DB id for the user) 
//  This is by Mixpanel design, here is more documentation on this: https://developer.mixpanel.com/docs/swift
//

import Foundation

protocol Analytics: AnyObject
{
    func setup()
    func log(event: AnalyticsEvent, properties: [String: Any])
    func setSuperProperty(property: String, value: Any)
    func setSuperProperties(properties: [String: Any])
    func identify(id: String)
    func setUserProperty(property: String, value: Any)
    func setUserProperties(properties: [String: Any])
}
