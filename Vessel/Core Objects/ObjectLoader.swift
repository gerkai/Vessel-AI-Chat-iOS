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
    
    @Resolved var analytics: Analytics
    
    func loadCoreObjects(onDone done: @escaping () -> Void)
    {
        guard let splitInitialLoad = RemoteConfigManager.shared.getValue(for: .splitInitialLoad) as? Bool, !splitInitialLoad else
        {
            loadCoreObjectsSplit
            {
                done()
            }
            return
        }
        
        let loadStartTime = DispatchTime.now()

        Log_Add("INITIAL LOAD")
        //add Expert once back end updates objects/all endpoint to handle Expert
        ObjectStore.shared.getMostRecent(objectTypes: [Result.self, Food.self, Curriculum.self, Plan.self, Reminder.self/*, Expert.self*/], onSuccess:
        {
            Contact.main()!.getFuel
            {
            }
            
            let objectsLoadedTimeEnd = DispatchTime.now()
            let objectsLoadedTime = (Double(objectsLoadedTimeEnd.uptimeNanoseconds) - Double(loadStartTime.uptimeNanoseconds)) / 1_000_000_000.0
            Log_Add("INITIAL LOAD 1. LoadedCoreObjects(Result, Food, Curriculum, Plan, Reminder): \(objectsLoadedTime) seconds")
            
            LessonsManager.shared.buildLessonPlan(onDone:
            {
                let buildLessonPlanTimeEnd = DispatchTime.now()
                let buildLessonPlanTime = (Double(buildLessonPlanTimeEnd.uptimeNanoseconds) - Double(loadStartTime.uptimeNanoseconds)) / 1_000_000_000.0
                Log_Add("INITIAL LOAD 2. Built Lesson Plan: \(buildLessonPlanTime) seconds")

                self.loadLifestyleRecommendations()
                PlansManager.shared.loadPlans()
                LocalNotificationsManager.shared.setupLocalNotifications()
                RemindersManager.shared.setupRemindersIfNeeded()
                
                let completeTimeEnd = DispatchTime.now()
                let completeTime = (Double(completeTimeEnd.uptimeNanoseconds) - Double(loadStartTime.uptimeNanoseconds)) / 1_000_000_000.0
                Log_Add("INITIAL LOAD 3. Complete: \(completeTime) seconds")
                
                self.analytics.log(event: .loadComplete(objectsLoadedTime: objectsLoadedTime, buildLessonPlanTime: buildLessonPlanTime, completeTime: completeTime))
                done()
            })
        },
        onFailure:
        {
            done()
        })
    }
    
    func loadCoreObjectsSplit(onDone done: @escaping () -> Void)
    {
        let loadStartTime = DispatchTime.now()

        Log_Add("SPLIT INITIAL LOAD")
        //add Expert once back end updates objects/all endpoint to handle Expert
        ObjectStore.shared.getMostRecent(objectTypes: [Result.self, Food.self, Curriculum.self, Plan.self, Reminder.self/*, Expert.self*/], onSuccess:
        {
            Contact.main()!.getFuel
            {
            }
            
            let objectsLoadedTimeEnd = DispatchTime.now()
            let objectsLoadedTime = (Double(objectsLoadedTimeEnd.uptimeNanoseconds) - Double(loadStartTime.uptimeNanoseconds)) / 1_000_000_000.0
            Log_Add("INITIAL LOAD 1. LoadedCoreObjects(Result, Food, Curriculum, Plan, Reminder): \(objectsLoadedTime) seconds")
            
            LessonsManager.shared.buildLessonPlan(onDone:
            {
                let buildLessonPlanTimeEnd = DispatchTime.now()
                let buildLessonPlanTime = (Double(buildLessonPlanTimeEnd.uptimeNanoseconds) - Double(loadStartTime.uptimeNanoseconds)) / 1_000_000_000.0
                Log_Add("INITIAL LOAD 2. Built Lesson Plan: \(buildLessonPlanTime) seconds")
                NotificationCenter.default.post(name: .newDataArrived, object: nil, userInfo: ["objectType": String(describing: Lesson.self)])
            })
            
            self.loadLifestyleRecommendations()
            PlansManager.shared.loadPlans()
            LocalNotificationsManager.shared.setupLocalNotifications()
            RemindersManager.shared.setupRemindersIfNeeded()
            
            let completeTimeEnd = DispatchTime.now()
            let completeTime = (Double(completeTimeEnd.uptimeNanoseconds) - Double(loadStartTime.uptimeNanoseconds)) / 1_000_000_000.0
            Log_Add("INITIAL LOAD 3. Complete: \(completeTime) seconds")
            
            self.analytics.log(event: .loadComplete(objectsLoadedTime: objectsLoadedTime, buildLessonPlanTime: 0.0, completeTime: completeTime))
            
            done()
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
