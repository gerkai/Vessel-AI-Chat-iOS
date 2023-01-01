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
        Log_Add("LoadCoreObjects(Result, Food, Curriculum, Plan)")
        ObjectStore.shared.getMostRecent(objectTypes: [Result.self, Food.self, Curriculum.self, Plan.self], onSuccess: 
        {
            Contact.main()!.getFuelStatus()
            LessonsManager.shared.buildLessonPlan(onDone:
            {
                PlansManager.shared.loadPlans()
                done()
            })
        },
        onFailure:
        {
            done()
        })
    }
}
