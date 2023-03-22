//
//  RouteManager.swift
//  Vessel
//
//  Created by Nicolas Medina on 3/22/23.
//

import UIKit

enum RoutingOption: String
{
    case takeATest = "takeTest"
    case coachTab = "coach"
    case resultsTab = "results"
    case todayTab = "today"
}

class RouteManager
{
    static let shared = RouteManager()
    
    var pendingRoutingOption: RoutingOption?
    
    func routeTo(_ route: RoutingOption) -> Bool
    {
        if route == .takeATest
        {
            if let mainTabBar = ((UIApplication.shared.windows.first?.rootViewController as? UINavigationController)?.topViewController as? MainTabBarController)
            {
                mainTabBar.vesselButtonPressed()
                return true
            }
            else if let mainTabBar = ((UIApplication.shared.windows.first?.rootViewController as? UINavigationController)?.topViewController)?.mainTabBarController
            {
                mainTabBar.selectedViewController?.navigationController?.popToRootViewController(animated: true)
                mainTabBar.vesselButtonPressed()
                return true
            }
            else
            {
                return false
            }
        }
        else if route == .resultsTab
        {
            if let mainTabBar = ((UIApplication.shared.windows.first?.rootViewController as? UINavigationController)?.topViewController as? MainTabBarController)
            {
                mainTabBar.selectedIndex = Constants.TAB_BAR_RESULTS_INDEX
                return true
            }
            else if let mainTabBar = ((UIApplication.shared.windows.first?.rootViewController as? UINavigationController)?.topViewController)?.mainTabBarController
            {
                mainTabBar.selectedViewController?.navigationController?.popToRootViewController(animated: true)
                mainTabBar.selectedIndex = Constants.TAB_BAR_RESULTS_INDEX
                return true
            }
            else
            {
                return false
            }
        }
        else if route == .coachTab
        {
            if let mainTabBar = ((UIApplication.shared.windows.first?.rootViewController as? UINavigationController)?.topViewController as? MainTabBarController)
            {
                mainTabBar.selectedIndex = Constants.TAB_BAR_COACH_INDEX
                return true
            }
            else if let mainTabBar = ((UIApplication.shared.windows.first?.rootViewController as? UINavigationController)?.topViewController)?.mainTabBarController
            {
                mainTabBar.selectedViewController?.navigationController?.popToRootViewController(animated: true)
                mainTabBar.selectedIndex = Constants.TAB_BAR_COACH_INDEX
                return true
            }
            else
            {
                return false
            }        }
        else if route == .todayTab
        {
            if let mainTabBar = ((UIApplication.shared.windows.first?.rootViewController as? UINavigationController)?.topViewController as? MainTabBarController)
            {
                mainTabBar.selectedIndex = Constants.TAB_BAR_TODAY_INDEX
                return true
            }
            else if let mainTabBar = ((UIApplication.shared.windows.first?.rootViewController as? UINavigationController)?.topViewController)?.mainTabBarController
            {
                mainTabBar.selectedViewController?.navigationController?.popToRootViewController(animated: true)
                mainTabBar.selectedIndex = Constants.TAB_BAR_TODAY_INDEX
                return true
            }
            else
            {
                return false
            }
        }
        return false
    }
}
