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
        Log_Add("Scene will connect to: \(connectionOptions)")
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    func scene(_ scene: UIScene, willContinueUserActivityWithType userActivityType: String)
    {
        Log_Add("Scene WillContinue: userActivityType: \(userActivityType)")
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity)
    {
        Log_Add("Scene Continue")
        let _ = DynamicLinks.dynamicLinks()
            .handleUniversalLink(userActivity.webpageURL!)
        { dynamiclink, error in
            Log_Add("Dynamic Link: \(String(describing: dynamiclink)), error: \(String(describing: error))")
        }
    }
    
    func sceneWillEnterForeground(_ scene: UIScene)
    {
        WaterManager.shared.resetDrinkedWaterGlassesIfNeeded()
        LessonsManager.shared.buildLessonPlanIfNeeded()
    }
}

