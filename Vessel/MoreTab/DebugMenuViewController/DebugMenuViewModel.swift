//
//  DebugMenuViewModel.swift
//  Vessel
//
//  Created by Nicolas Medina on 8/25/22.
//

import Foundation

enum DebugMenuOption: Int
{
    case debugMenu
    case resetUserFlags
    case bypassScanning
    case showDebugDrawing
    case printNetworkTraffic
    case printInitAndDeinit
    case relaxedScanningDistance
    
    case addActivity
    
    case eraseAll
    case eraseActivities
    case eraseCurriculums
    case eraseFood
    case eraseLessons
    case erasePlans
    case eraseResults
    case eraseSteps
    
    case resetLessonProgress
    case newDayForLesson
    case useMockResults
    case useShortPeriodsForRemindersPushes
    case useShortPeriodsForTakeATestPushes
    case useShortPeriodsForGeneralWellnessPushes
    case useShortPeriodsForFuelPushes
    
    case forceAppReview
    
    var title: String
    {
        switch self
        {
            case .debugMenu: return "Debug Menu"
            case .resetUserFlags: return "Reset User Flags"
            case .bypassScanning: return "Bypass Scanning"
            case .showDebugDrawing: return "Show Debug Drawing"
            case .printNetworkTraffic: return "Print Network Traffic"
            case .printInitAndDeinit: return "Print intialization and deinitialization"
            case .relaxedScanningDistance: return "Relaxed Scanning Distance"
            
            case .addActivity: return "Add activity with id: "
            
            case .eraseAll: return "Erase all objects"
            case .eraseActivities: return "Erase all activities"
            case .eraseCurriculums: return "Erase all curriculums"
            case .eraseFood: return "Erase all food"
            case .eraseLessons: return "Erase all lessons"
            case .erasePlans: return "Erase all plans"
            case .eraseResults: return "Erase all test results"
            case .eraseSteps: return "Erase all steps"
            
            case .resetLessonProgress: return "Reset Lesson Progress"
            case .newDayForLesson: return "Make today a new lesson day"
            case .useMockResults: return "Use mock test results"
            case .useShortPeriodsForRemindersPushes: return "Use short periods for reminders pushes"
            case .useShortPeriodsForTakeATestPushes: return "Use short periods for take a test pushes"
            case .useShortPeriodsForGeneralWellnessPushes: return "Use short periods for wellness pushes"
            case .useShortPeriodsForFuelPushes: return "Use short periods for fuel pushes"

            case .forceAppReview: return "Force App Review"
        }
    }
    
    var isEnabled: Bool
    {
        guard let flag = flag else { return false }
        return UserDefaults.standard.object(forKey: flag) != nil
    }
    
    var showTextField: Bool
    {
        switch self
        {
            case .addActivity: return true
            default: return false
        }
    }
    
    private var flag: String?
    {
        switch self
        {
            case .debugMenu: return Constants.KEY_DEBUG_MENU
            case .resetUserFlags: return nil
            case .bypassScanning: return Constants.KEY_BYPASS_SCANNING
            case .printNetworkTraffic: return Constants.KEY_PRINT_NETWORK_TRAFFIC
            case .showDebugDrawing: return Constants.KEY_SHOW_DEBUG_DRAWING
            case .printInitAndDeinit: return Constants.KEY_PRINT_INIT_DEINIT
            case .relaxedScanningDistance: return Constants.KEY_RELAXED_SCANNING_DISTANCE
            case .addActivity: return nil
            case .eraseAll: return Constants.KEY_ERASE_ALL
            case .eraseActivities: return Constants.KEY_ERASE_ACTIVITIES
            case .eraseCurriculums: return Constants.KEY_ERASE_CURRICULUMS
            case .eraseFood: return Constants.KEY_ERASE_FOOD
            case .eraseLessons: return Constants.KEY_ERASE_LESSONS
            case .erasePlans: return Constants.KEY_ERASE_PLANS
            case .eraseResults: return Constants.KEY_ERASE_RESULTS
            case .eraseSteps: return Constants.KEY_ERASE_STEPS
            case .resetLessonProgress: return Constants.KEY_RESET_LESSON_PROGRESS
            case .newDayForLesson: return Constants.KEY_NEW_LESSON_DAY
            case .useMockResults: return Constants.KEY_USE_MOCK_RESULTS
            case .useShortPeriodsForRemindersPushes: return Constants.KEY_USE_SHORT_PERIODS_FOR_REMINDERS_PUSHES
            case .useShortPeriodsForTakeATestPushes: return Constants.KEY_USE_SHORT_PERIODS_FOR_TAKE_A_TEST_PUSHES
            case .useShortPeriodsForGeneralWellnessPushes: return Constants.KEY_USE_SHORT_PERIODS_FOR_GENERAL_WELLNESS_PUSHES
            case .useShortPeriodsForFuelPushes: return Constants.KEY_USE_SHORT_PERIODS_FOR_FUEL_PUSHES
            case .forceAppReview: return Constants.KEY_FORCE_APP_REVIEW
        }
    }
    
    func toggle(value: String?) -> Bool
    {
        var shouldRefresh = false
        if self == .resetUserFlags
        {
            if let main = Contact.main()
            {
                main.flags = 0 //clears all app_flags (definitions of each flag in AppConstants)
                main.gender = nil //forces user to go through onboarding again as well
                ObjectStore.shared.clientSave(main)
            }
        }
        else if self == .addActivity
        {
            guard let planId = Int(value ?? "") else { return shouldRefresh }
            let planToAdd = Plan(type: .activity, typeId: planId)
            Server.shared.addSinglePlan(plan: planToAdd) { addedPlan in
                PlansManager.shared.addPlans(plansToAdd: [addedPlan])
            } onFailure: { _ in
            }
        }
        else if self == .eraseActivities
        {
            let activities = PlansManager.shared.getActivityPlans()
            
            for activity in activities
            {
                Storage.remove(activity.id, objectType: Plan.self)
            }
            NotificationCenter.default.post(name: .newDataArrived, object: nil, userInfo: ["objectType": String(describing: Plan.self)])
        }
        else if self == .eraseFood
        {
            Storage.clear(objectType: Food.self)
            //force today tab to update
            NotificationCenter.default.post(name: .newDataArrived, object: nil, userInfo: ["objectType": String(describing: Food.self)])
        }
        else if self == .eraseLessons
        {
            //clear all lessons from storage
            Storage.clear(objectType: Lesson.self)
            //force today tab to update
            NotificationCenter.default.post(name: .newDataArrived, object: nil, userInfo: ["objectType": String(describing: Lesson.self)])
        }
        else if self == .erasePlans
        {
            //clear all lessons from storage
            Storage.clear(objectType: Plan.self)
            //force today tab to update
            NotificationCenter.default.post(name: .newDataArrived, object: nil, userInfo: ["objectType": String(describing: Plan.self)])
        }
        else if self == .eraseResults
        {
            //clear all results from storage
            Storage.clear(objectType: Result.self)
            //force today and results tabs to update and show/hide blocker view if necessary
            NotificationCenter.default.post(name: .newDataArrived, object: nil, userInfo: ["objectType": String(describing: Result.self)])
        }
        else if self == .eraseSteps
        {
            //clear all steps from storage
            Storage.clear(objectType: Step.self)
            //force today and results tabs to update and show/hide blocker view if necessary
            NotificationCenter.default.post(name: .newDataArrived, object: nil, userInfo: ["objectType": String(describing: Plan.self)])
        }
        else if self == .resetLessonProgress
        {
            LessonsManager.shared.resetLessonProgress()
        }
        else if self == .newDayForLesson
        {
            LessonsManager.shared.shiftLessonDaysBack()
        }
        else if self == .eraseAll
        {
            //clear all objects from storage
            Storage.clear(objectType: Tip.self) //activity
            Storage.clear(objectType: Curriculum.self)
            Storage.clear(objectType: Food.self)
            Storage.clear(objectType: Lesson.self)
            Storage.clear(objectType: Plan.self)
            Storage.clear(objectType: Result.self)
            Storage.clear(objectType: Step.self)
            Storage.clear(objectType: Expert.self)
            //force today tab to update
            NotificationCenter.default.post(name: .newDataArrived, object: nil, userInfo: ["objectType": String(describing: Lesson.self)])
        }
        else if self == .useMockResults
        {
            //force today and results tabs to update and show/hide blocker view if necessary
            NotificationCenter.default.post(name: .newDataArrived, object: nil, userInfo: ["objectType": String(describing: Result.self)])
        }
        else if self == .forceAppReview
        {
            //set date in NSUserDefaults to be 12 days ago
            let date = Calendar.current.date(byAdding: .day, value: -30, to: Date())
            UserDefaults.standard.set(date, forKey: Constants.KEY_FIRST_LAUNCH_DATE)
            
            //clear app flag to allow review prompt to appear again for this user
            if let contact = Contact.main()
            {
                contact.flags &= ~Constants.HAS_RATED_APP
                ObjectStore.shared.clientSave(contact)
            }
        }
        else if let flag = flag
        {
            if isEnabled
            {
                UserDefaults.standard.removeObject(forKey: flag)
                if self == .debugMenu
                {
                    shouldRefresh = true
                }
            }
            else
            {
                UserDefaults.standard.set(true, forKey: flag)
            }
        }
        return shouldRefresh
    }
}

class DebugMenuViewModel
{
    let options: [DebugMenuOption] = [
        .debugMenu,
        .resetUserFlags,
        .bypassScanning,
        .showDebugDrawing,
        .printNetworkTraffic,
        .printInitAndDeinit,
        .relaxedScanningDistance,
        .addActivity,
        .eraseAll,
        .eraseActivities,
        .eraseCurriculums,
        .eraseFood,
        .eraseLessons,
        .erasePlans,
        .eraseResults,
        .eraseSteps,
        .resetLessonProgress,
        .newDayForLesson,
        .useMockResults,
        .useShortPeriodsForRemindersPushes,
        .useShortPeriodsForTakeATestPushes,
        .useShortPeriodsForGeneralWellnessPushes,
        .useShortPeriodsForFuelPushes,
        .forceAppReview
    ]
    
    func contactIDText() -> String
    {
        let contact = Contact.main()!
        let result = "Contact ID: \(contact.id)"
        return result
    }
}
