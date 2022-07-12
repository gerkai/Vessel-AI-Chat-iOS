//
//  MixpanelAnalytics.swift
//  Vessel
//
//  Created by Nicolas Medina on 7/11/22.
//

import UIKit
import Mixpanel

class MixpanelAnalytics: Analytics {
    private var analyticsToken: String {
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
    
    private var analyticsAppSecret: String {
        let environment = UserDefaults.standard.integer(forKey: Constants.environmentKey)
        switch environment
        {
            case Constants.DEV_INDEX:
                return Constants.DevMixpanelAppSecret
            case Constants.STAGING_INDEX:
                return Constants.StagingMixpanelAppSecret
            default:
                return Constants.ProdMixpanelAppSecret
        }
    }
    
    func setup() {
        Mixpanel.initialize(token: analyticsToken)
    }
    
    func log(event: String, properties: [String: Any]) {
        guard let properties = properties as? [String: MixpanelType] else {
            fatalError("Not valid types found in properties for event: \(event)")
        }
        Mixpanel.mainInstance().track(event: event, properties: properties)
    }
}
