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
import FirebaseDynamicLinks
import Pushwoosh

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
        
        Pushwoosh.sharedInstance().delegate = self
        if #available(iOS 12.0, *)
        {
            Pushwoosh.sharedInstance().additionalAuthorizationOptions = UNAuthorizationOptions.provisional
        }
        Pushwoosh.sharedInstance().registerForPushNotifications()
        Pushwoosh.sharedInstance().showPushnotificationAlert = true
        
        //so videos will play sound even if mute button is on
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        
        if let url = launchOptions?[UIApplication.LaunchOptionsKey.url] as? URL
        {
            processDynamicLink(url: url)
        }
        else if let activityDictionary = launchOptions?[UIApplication.LaunchOptionsKey.userActivityDictionary] as? [AnyHashable: Any]
        {
            for key in activityDictionary.keys
            {
                if let userActivity = activityDictionary[key] as? NSUserActivity
                {
                    if let url = userActivity.webpageURL
                    {
                        processDynamicLink(url: url)
                    }
                }
            }
        }
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {(accepted, error) in
            if !accepted
            {
                print("Notification access denied")
            }
         }
        
        return true
    }
    
    func open(_ url: URL, options: [String: Any] = [:], completionHandler completion: ((Bool) -> Swift.Void)? = nil)
    {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let page = components?.host ?? ""
        
        if let route = RoutingOption(rawValue: page)
        {
            print("Route to: \(route.rawValue)")
            _ = RouteManager.shared.routeTo(route)
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        let token = deviceToken.map { String(format: "%.2hhx", $0) }.joined()
        print("didRegisterForRemoteNotifications: \(token)")
        Pushwoosh.sharedInstance().handlePushRegistration(deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error)
    {
        Pushwoosh.sharedInstance().handlePushRegistrationFailure(error)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
    {
        Pushwoosh.sharedInstance().handlePushReceived(userInfo)
    }

    func extractExpertInfo(percentEncodedURLString: String) -> Int?
    {
        var expertID: Int?
        Log_Add("extractExpertInfo")
        if let url = percentEncodedURLString.removingPercentEncoding
        {
            //analytics.log(event: .prlClicked(url: url))
            let componentString = url.replacingOccurrences(of: "?", with: "&")
            let components = componentString.components(separatedBy: "&")
            //print(components)

            for component in components
            {
                if let range = component.range(of: "expert_id=")
                {
                    let numberString = component[range.upperBound...]
                    if let number = numberString.components(separatedBy: CharacterSet.decimalDigits.inverted).first
                    {
                        expertID = Int(number)
                        Log_Add("Captured ExpertID: \(String(describing: expertID))")
                    }
                }
                if let range = component.range(of: "logo=")
                {
                    let logoString = String(component[range.upperBound...])
                    UserDefaults.standard.setValue(logoString, forKey: Constants.KEY_PRACTITIONER_IMAGE_URL)
                    Log_Add("1 Setting Global ExpertLogo: \(logoString)")
                    //post a notification in case splash screen already got instantiated. Splash screen will pick up this notification.
                    NotificationCenter.default.post(name: .gotCobrandingImage, object: nil, userInfo: ["logo": logoString])
                }
            }
            if let id = expertID
            {
                Log_Add("1 Found Expert ID: \(id)")
                analytics.log(event: .prlFoundExpertID(expertID: id))
            }
        }
        return expertID
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration
    {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    //handle links received as Universal Links when the app is already installed
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool
    {
        Log_Add("Continue User Activity")
        if let urlString = userActivity.webpageURL?.absoluteString
        {
            if let expertID = extractExpertInfo(percentEncodedURLString: urlString)
            {
                Contact.PractitionerID = expertID
                Log_Add("1 Setting Global ExpertID: \(expertID)")
            }
        }
        
        //cw not sure if this code is needed for our use case. Adding logging so we can gain insight...
        let handled = DynamicLinks.dynamicLinks().handleUniversalLink(userActivity.webpageURL!)
        { dynamiclink, error in
            Log_Add("App Delegate Dynamic Link: \(String(describing: dynamiclink)), error: \(String(describing: error))")
            if let urlString = dynamiclink?.url?.absoluteString
            {
                if let expertID = self.extractExpertInfo(percentEncodedURLString: urlString)
                {
                    Contact.PractitionerID = expertID
                    Log_Add("Dynamic Link had ExpertID: \(expertID)")
                }
            }
        }
        return handled
    }
    
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
        Log_Add("App Terminating\n\n\n\n\n")
        Log_Save()
    }
    
    //called by Firebase Dynamic Links SDK when the app is opened the first time after installation
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool
    {
        Log_Add("Open URL: \(url), options:\(options)")
        
        //if there's an expert_id in the URL, pass it to the Contact module so we can attribute the contact to the expert
        if let expertID = extractExpertInfo(percentEncodedURLString: url.absoluteString)
        {
            Contact.PractitionerID = expertID
            Log_Add("2 Setting Global ExpertID: \(expertID)")
        }
        
        return application(app, open: url,
                           sourceApplication: options[UIApplication.OpenURLOptionsKey
                             .sourceApplication] as? String,
                           annotation: "")
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool
    {
        let component = url.lastPathComponent
        if let _ = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url)
        {
            if let route = RoutingOption(rawValue: component)
            {
                let result = RouteManager.shared.routeTo(route)
                if !result
                {
                    RouteManager.shared.pendingRoutingOption = route
                }
            }
            return true
        }
        return false
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
    
    func processDynamicLink(url: URL?)
    {
        if let url = url
        {
            let component = url.lastPathComponent
            let _ = DynamicLinks.dynamicLinks().handleUniversalLink(url)
            { dynamiclink, error in
                Log_Add("App Delegate Process Dynamic Link: \(String(describing: dynamiclink)), error: \(String(describing: error))")
                
                if let route = RoutingOption(rawValue: component)
                {
                    let result = RouteManager.shared.routeTo(route)
                    if !result
                    {
                        RouteManager.shared.pendingRoutingOption = route
                    }
                }
            }
        }
    }
}

extension AppDelegate: PWMessagingDelegate
{
    func pushwoosh(_ pushwoosh: Pushwoosh, onMessageOpened message: PWMessage)
    {
        print("onMessageOpened: ", message.payload?.description ?? "")
    }
    
    func pushwoosh(_ pushwoosh: Pushwoosh, onMessageReceived message: PWMessage)
    {
        print("onMessageReceived: ", message.payload?.description ?? "")
    }
}
