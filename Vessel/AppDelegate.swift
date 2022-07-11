//
//  AppDelegate.swift
//  Vessel
//
//  Created by Carson Whitsett on 2/25/22.
//
// TODO: Add auto-login
// TODO: Add server logs debug on/off toggle

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate
{
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        FirebaseApp.configure()
        
        configureAppearance()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration
    {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>)
    {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func configureAppearance()
    {
        //app-wide segmented control configuration
        let font = UIFont(name: "BananaGrotesk-Semibold", size: 16.0)!
        let normalAttribute: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: Constants.VESSEL_BLACK]
        UISegmentedControl.appearance().setTitleTextAttributes(normalAttribute, for: .normal)

        let selectedAttribute: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: UIColor.white]
        UISegmentedControl.appearance().setTitleTextAttributes(selectedAttribute, for: .selected)
        
        //app-wide tab bar appearance
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "BananaGrotesk-Semibold", size: 16)!], for: .normal)
        //UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "BananaGrotesk-Semibold", size: 11)!], for: .selected)
        //UITabBar.appearance().barTintColor = .orange
            //UITabBar.appearance().tintColor = .green
    }
}

