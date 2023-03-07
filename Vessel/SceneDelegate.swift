//
//  SceneDelegate.swift
//  Vessel
//
//  Created by Carson Whitsett on 2/25/22.
//

import UIKit
import FirebaseDynamicLinks

class SceneDelegate: UIResponder, UIWindowSceneDelegate
{
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions)
    {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        Log_Add("Scene will connect to: \(String(describing: connectionOptions.urlContexts))")
        processDynamicLink(url: connectionOptions.urlContexts.first?.url)
        /*if let url = connectionOptions.urlContexts.first?.url.absoluteString
        {
            Log_Add("URL: \(url)")
            if let expertID = AppDelegate().extractExpertInfo(percentEncodedURLString: url)
            {
                Contact.PractitionerID = expertID
                Log_Add("3 Setting Global ExpertID: \(expertID)")
            }
        }*/
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    //Called when vessel:// link is tapped with app already running in the background
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>)
    {
        Log_Add("Scene openURLContexts")
        processDynamicLink(url: URLContexts.first?.url)
        /*if let url = URLContexts.first?.url.absoluteString
        {
            Log_Add("URL: \(url)")
            if let expertID = AppDelegate().extractExpertInfo(percentEncodedURLString: url)
            {
                Log_Add("4 Setting Global ExpertID: \(expertID)")
                //if we're already logged in, then go ahead and make the association now
                makeAssociation(expertID: expertID)
            }
        }*/
    }
    
    func scene(_ scene: UIScene, willContinueUserActivityWithType userActivityType: String)
    {
        Log_Add("Scene WillContinue: userActivityType: \(userActivityType)")
    }
    
    func makeAssociation(expertID: Int)
    {
        Contact.PractitionerID = expertID
        
        //if we're already logged in, then go ahead and make the association now
        if let contact = Contact.main()
        {
            contact.pa_id = expertID
            ObjectStore.shared.clientSave(contact)
            Contact.PractitionerID = nil
        }
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity)
    {
        Log_Add("Scene Continue")
        processDynamicLink(url: userActivity.webpageURL)
        /*if let webpageURL = userActivity.webpageURL
        {
            let _ = DynamicLinks.dynamicLinks().handleUniversalLink(webpageURL)
            { dynamiclink, error in
                Log_Add("Dynamic Link: \(String(describing: dynamiclink)), error: \(String(describing: error))")
                
                if let url = dynamiclink?.url
                {
                    if let expertID = AppDelegate().extractExpertInfo(percentEncodedURLString: url.absoluteString)
                    {
                        self.makeAssociation(expertID: expertID)
                        Log_Add("5 Setting Global ExpertID: \(expertID)")
                    }
                }
            }
        }*/
    }
    
    func processDynamicLink(url: URL?)
    {
        if let url = url
        {
            let _ = DynamicLinks.dynamicLinks().handleUniversalLink(url)
            { dynamiclink, error in
                Log_Add("Dynamic Link: \(String(describing: dynamiclink)), error: \(String(describing: error))")
                
                if let url = dynamiclink?.url
                {
                    if let expertID = AppDelegate().extractExpertInfo(percentEncodedURLString: url.absoluteString)
                    {
                        self.makeAssociation(expertID: expertID)
                        Log_Add("5 Setting Global ExpertID: \(expertID)")
                    }
                }
            }
        }
    }
    
    func sceneWillEnterForeground(_ scene: UIScene)
    {
        WaterManager.shared.resetDrinkedWaterGlassesIfNeeded()
        LessonsManager.shared.buildLessonPlanIfNeeded()
    }
}

