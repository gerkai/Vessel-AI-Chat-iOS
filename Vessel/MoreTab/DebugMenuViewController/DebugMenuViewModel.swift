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
    case clearResults
    case clearLessons
    case clearAllPlanData
    case useMockResults
    case showAllFoodsEveryday
    
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
            case .clearResults: return "Clear all test results"
            case .clearLessons: return "Clear locally stored lessons"
            case .clearAllPlanData: return "Clear plans, lessons, steps, foods, curriculum"
            case .useMockResults: return "Use mock test results"
            case .showAllFoodsEveryday: return "Show all foods everyday"
        }
    }
    
    var isEnabled: Bool
    {
        guard let flag = flag else { return false }
        return UserDefaults.standard.object(forKey: flag) != nil
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
            case .clearResults: return Constants.KEY_CLEAR_RESULTS
            case .clearLessons: return Constants.KEY_CLEAR_LESSONS
            case .clearAllPlanData: return Constants.KEY_CLEAR_ALL_PLAN_DATA
            case .useMockResults: return Constants.KEY_USE_MOCK_RESULTS
            case .showAllFoodsEveryday: return Constants.SHOW_ALL_FOODS_EVERYDAY
        }
    }
    
    func toggle()
    {
        if self == .resetUserFlags
        {
            if let main = Contact.main()
            {
                main.flags = 0 //clears all app_flags (definitions of each flag in AppConstants)
                main.gender = nil //forces user to go through onboarding again as well
                ObjectStore.shared.ClientSave(main)
            }
        }
        else if self == .clearResults
        {
            //clear all results from storage
            Storage.clear(objectType: Result.self)
            //force today and results tabs to update and show/hide blocker view if necessary
            NotificationCenter.default.post(name: .newDataArrived, object: nil, userInfo: ["objectType": String(describing: Result.self)])
        }
        else if self == .clearLessons
        {
            //clear all lessons from storage
            Storage.clear(objectType: Lesson.self)
            //force today tab to update
            NotificationCenter.default.post(name: .newDataArrived, object: nil, userInfo: ["objectType": String(describing: Lesson.self)])
        }
        else if self == .clearAllPlanData
        {
            //clear all lessons from storage
            Storage.clear(objectType: Lesson.self)
            Storage.clear(objectType: Plan.self)
            Storage.clear(objectType: Step.self)
            Storage.clear(objectType: Food.self)
            Storage.clear(objectType: Curriculum.self)
            //force today tab to update
            NotificationCenter.default.post(name: .newDataArrived, object: nil, userInfo: ["objectType": String(describing: Lesson.self)])
        }
        else if let flag = flag
        {
            if isEnabled
            {
                UserDefaults.standard.removeObject(forKey: flag)
            }
            else
            {
                UserDefaults.standard.set(true, forKey: flag)
            }
            if self == .useMockResults
            {
                //force today and results tabs to update and show/hide blocker view if necessary
                NotificationCenter.default.post(name: .newDataArrived, object: nil, userInfo: ["objectType": String(describing: Result.self)])
            }
        }
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
        .clearResults,
        .clearLessons,
        .clearAllPlanData,
        .useMockResults,
        .showAllFoodsEveryday
    ]
}
