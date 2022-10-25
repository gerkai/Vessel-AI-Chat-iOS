//
//  AppDelegate.swift
//  Vessel
//
//  Created by Carson Whitsett on 2/25/22.
//

import UIKit
import Bugsee
import Firebase
import ZendeskCoreSDK
import ChatSDK
import ChatProvidersSDK
import SupportSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate
{
    @Resolved private var analytics: Analytics
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        FirebaseApp.configure()
        analytics.setup()
        configureAppearance()
        MediaManager.shared.initMedia()
        UIViewController.swizzle()
        initializeZendesk()
        Bugsee.launch(token: Constants.bugseeKey, options: [BugseeCrashReportKey: false])
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
        
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().tintColor = .systemBlue
    }
    
    private func initializeZendesk()
    {
        var appId: String
        var clientId: String
        let environment = UserDefaults.standard.integer(forKey: Constants.environmentKey)
        switch environment
        {
        case Constants.DEV_INDEX:
            appId = Constants.devZendeskAppId
            clientId = Constants.devZendeskClientId
        case Constants.STAGING_INDEX:
            appId = Constants.prodZendeskAppId
            clientId = Constants.prodZendeskClientId
        default:
            appId = Constants.prodZendeskAppId
            clientId = Constants.prodZendeskClientId
        }
        
        Zendesk.initialize(
            appId: appId,
            clientId: clientId,
            zendeskUrl: Constants.zenDeskSupportURL
        )
        
        Support.initialize(withZendesk: Zendesk.instance)
        Chat.initialize(accountKey: Constants.zendeskAccountKey)
        CoreLogger.enabled = true
        CoreLogger.logLevel = .debug
    }
}

/*
//MARK: - Bugsee
extension AppDelegate
{
    func launchBugsee()
    {
        if !Constants.isProdMode
        {
            Bugsee.launch(token: Constants.bugseeKey, options: [BugseeCrashReportKey: false])
            if let userEmail = UserManager.shared.contact?.email, let contactId = UserManager.shared.contact?.id
            {
                Bugsee.setEmail(userEmail)
                Bugsee.setAttribute("contact_id", value: contactId)
            }
            
        }
        else if let savedBugseeDateString = UserDefaults.standard.value(forKey: UserDefaultsKeys.bugseeDate.rawValue) as? String
        {
            let bugseeDate = savedBugseeDateString.toDate("yyyy-MM-dd'T'HH:mm:ss.SSSSSS")
            let daysSinceSaving = Calendar.current.dateComponents([.day], from: bugseeDate, to: Date()).day
            if daysSinceSaving! <= 30
            {
                Bugsee.launch(token: Constants.bugseeKey, options: [BugseeCrashReportKey: false])
                if let userEmail = UserManager.shared.contact?.email, let contactId = UserManager.shared.contact?.id
                {
                    Bugsee.setEmail(userEmail)
                    Bugsee.setAttribute("contact_id", value: contactId)
                }
            }
        }
    }
}
*/
