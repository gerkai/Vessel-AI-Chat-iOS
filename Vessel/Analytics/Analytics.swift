//
//  Analytics.swift
//  Vessel
//
//  Created by Nicolas Medina on 7/11/22.
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
