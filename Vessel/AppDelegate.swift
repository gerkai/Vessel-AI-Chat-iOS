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
import AVFoundation
import FirebaseRemoteConfig

@main
class AppDelegate: UIResponder, UIApplicationDelegate
{
    @Resolved private var analytics: Analytics
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        Log_Init()
        Log_Load()
        Log_Add("App did finish launching with options \(String(describing: launchOptions))")
        FirebaseApp.configure()
        RemoteConfigManager.shared.launchRemoteConfig()
        analytics.setup()
        configureAppearance()
        MediaManager.shared.initMedia()
        UIViewController.swizzle() //used for analytics
        initializeZendesk()
        launchBugsee()
        //so videos will play sound even if mute button is on
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration
    {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    /*func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool
    {
        let handled = DynamicLinks.dynamicLinks()
            .handleUniversalLink(userActivity.webpageURL!) { dynamiclink, error in
              // ...
            }

          return handled
    }
    */
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>)
    {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func applicationWillResignActive(_ application: UIApplication)
    {
        Log_Add("App resigning active")
        Log_Save()
    }
    
    func applicationWillTerminate(_ application: UIApplication)
    {
        Log_Add("App Terminating")
        Log_Save()
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool
    {
        Log_Add("Open URL: \(url), options:\(options)")
        return true
    }

    func launchBugsee()
    {
        //launch bugsee if we're in dev or staging. If we're in prod, only launch bugsee if ALLOW_BUGSEE key has been set.
        let index = UserDefaults.standard.integer(forKey: Constants.environmentKey)
        switch index
        {
            case Constants.DEV_INDEX:
                Bugsee.launch(token: Constants.bugseeKey, options: [BugseeCrashReportKey: false])
            case Constants.STAGING_INDEX:
                Bugsee.launch(token: Constants.bugseeKey, options: [BugseeCrashReportKey: false])
            default:
                //production
                //only launch Bugsee if ALLOW_BUGSEE userDefault key is present
                let allowBugsee = UserDefaults.standard.bool(forKey: Constants.ALLOW_BUGSEE_KEY)
                if allowBugsee == true
                {
                    Bugsee.launch(token: Constants.bugseeKey, options: [BugseeCrashReportKey: false])
                }
        }
    }
    
    func configureAppearance()
    {
        //app-wide segmented control configuration
        let font = UIFont(name: "BananaGrotesk-Semibold", size: 16.0)!
        let normalAttribute: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: Constants.VESSEL_BLACK]
        UISegmentedControl.appearance().setTitleTextAttributes(normalAttribute, for: .normal)

        let selectedAttribute: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: UIColor.white]
        UISegmentedControl.appearance().setTitleTextAttributes(selectedAttribute, for: .selected)
        
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().tintColor = .systemBlue
        
        //These were added to fix keyboard tool bar appearance in LiveChat session under coach tab (VH-4551, VH-4552)
        UITextField.appearance().tintColor = UIColor.black
        UITextView.appearance().tintColor = UIColor.black
        UIToolbar.appearance().backgroundColor = Constants.vesselGreat
        UIToolbar.appearance().tintColor = Constants.vesselBlack
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
