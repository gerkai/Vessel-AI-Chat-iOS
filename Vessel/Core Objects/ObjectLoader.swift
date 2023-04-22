//
//  ObjectLoader.swift
//  Vessel
//
//  Created by Carson Whitsett on 12/5/22.
//
//  This is called after login (or after onboarding) to load all of the core objects from the back end. If the objects already
//  exist in local storage, the back end will return empty arrays. If stale objects exist locally, the back end will return
//  updated objects. ObjectStore takes care of storing the objects locally after they've been returned from the back end.

import Foundation

class ObjectLoader: NSObject
{
    static let shared = ObjectLoader()
    
    func loadCoreObjects(onDone done: @escaping () -> Void)
    {
        Log_Add("LoadCoreObjects(Result, Food, Curriculum, Plan, Reminder)")
        //add Expert once back end updates objects/all endpoint to handle Expert
        ObjectStore.shared.getMostRecent(objectTypes: [Result.self, Food.self, Curriculum.self, Plan.self, Reminder.self/*, Expert.self*/], onSuccess:
        {
            Contact.main()!.getFuel
            {
            }
            LessonsManager.shared.buildLessonPlan(onDone:
            {
                self.loadLifestyleRecommendations()
                PlansManager.shared.loadPlans()
                LocalNotificationsManager.shared.setupLocalNotifications()
                RemindersManager.shared.setupRemindersIfNeeded()
                done()
            })
        },
        onFailure:
        {
            done()
        })
    }
    
    func loadLifestyleRecommendations()
    {
        ObjectStore.shared.serverSave(LifestyleRecommendation.takeATest, notifyNewDataArrived: false)
        ObjectStore.shared.serverSave(LifestyleRecommendation.supplements, notifyNewDataArrived: false)
        ObjectStore.shared.serverSave(LifestyleRecommendation.fuelAM, notifyNewDataArrived: false)
        ObjectStore.shared.serverSave(LifestyleRecommendation.fuelPM, notifyNewDataArrived: false)
    }
}
