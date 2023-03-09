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
                self.loadLifestyleRecommendations
                {
                    PlansManager.shared.loadPlans()
                    RemindersManager.shared.setupRemindersIfNeeded()
                    done()
                }
            })
        },
        onFailure:
        {
            done()
        })
    }
    
    func loadLifestyleRecommendations(onDone done: @escaping () -> Void)
    {
        //load lifestyle recommendation template objects
        //this is how we should be doing it
        /*ObjectStore.shared.get(type: LifestyleRecommendation.self, id: Constants.GET_SUPPLEMENTS_LIFESTYLE_RECOMMENDATION_ID) { object in
            print("Got Object: \(object)")
        } onFailure: {
            print("FAILED!")
        }*/
        
        print("Requesting Lifestyle recommendations")
        //this is using V2 api and not using ObjectStore. THIS IS TEMPORARY CODE
        Server.shared.getLifestyleRecommendation(id: Constants.GET_SUPPLEMENTS_LIFESTYLE_RECOMMENDATION_ID, onSuccess:
        { result in
            print("Got Get Supplements Recommendation")
            //object on back end doesn't have a subtext field. Our local object does so we add the desired subtext here.
            //Tech Debt: Add subtext field to back end lifestyle recommendation object
            result.subtext = NSLocalizedString("Take a simple 3 minute quiz", comment: "")
            ObjectStore.shared.serverSave(result)
            
            Server.shared.getLifestyleRecommendation(id: Constants.FUEL_AM_LIFESTYLE_RECOMMENDATION_ID, onSuccess:
            { result in
                print("Got AM Fuel Recommendation")
                ObjectStore.shared.serverSave(result)
                
                Server.shared.getLifestyleRecommendation(id: Constants.FUEL_PM_LIFESTYLE_RECOMMENDATION_ID, onSuccess:
                { result in
                    print("Got PM Fuel Recommendation")
                    ObjectStore.shared.serverSave(result)
                    done()
                },
                onFailure:
                { error in
                    print("ERROR: \(String(describing: error))")
                    done()
                })
            },
            onFailure:
            { error in
                print("ERROR: \(String(describing: error))")
                done()
            })
        },
        onFailure:
        { error in
            print("ERROR: \(String(describing: error))")
            done()
        })
    }
}
