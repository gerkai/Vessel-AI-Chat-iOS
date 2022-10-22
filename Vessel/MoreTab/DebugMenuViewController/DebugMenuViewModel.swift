//
//  DebugMenuViewModel.swift
//  Vessel
//
//  Created by Nicolas Medina on 8/25/22.
//

import Foundation

enum DebugMenuOption: Int
{
    case resetUserFlags
    case bypassScanning
    case showDebugDrawing
    case printNetworkTraffic
    case printInitAndDeinit
    case relaxedScanningDistance
    case clearResults
    case useMockResults
    
    var title: String
    {
        switch self
        {
            case .resetUserFlags: return "Reset User Flags"
            case .bypassScanning: return "Bypass Scanning"
            case .showDebugDrawing: return "Show Debug Drawing"
            case .printNetworkTraffic: return "Print Network Traffic"
            case .printInitAndDeinit: return "Print intialization and deinitialization"
            case .relaxedScanningDistance: return "Relaxed Scanning Distance"
            case .clearResults: return "Clear all test results"
            case .useMockResults: return "Use mock test results"
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
            case .resetUserFlags: return nil
            case .bypassScanning: return Constants.KEY_BYPASS_SCANNING
            case .printNetworkTraffic: return Constants.KEY_PRINT_NETWORK_TRAFFIC
            case .showDebugDrawing: return Constants.KEY_SHOW_DEBUG_DRAWING
            case .printInitAndDeinit: return Constants.KEY_PRINT_INIT_DEINIT
            case .relaxedScanningDistance: return Constants.KEY_RELAXED_SCANNING_DISTANCE
            case .clearResults: return Constants.KEY_CLEAR_RESULTS
            case .useMockResults: return Constants.KEY_USE_MOCK_RESULTS
        }
    }
    
    func toggle()
    {
        if self == .resetUserFlags
        {
            if let main = Contact.main()
            {
                main.flags = 0
                ObjectStore.shared.ClientSave(main)
            }
        }
        else if self == .clearResults
        {
            //clear all results from storage
            Storage.clear(objectType: Result.self)
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
                NotificationCenter.default.post(name: .newDataFromServer, object: nil, userInfo: ["objectType": String(describing: Result.self)])
            }
        }
    }
}

class DebugMenuViewModel
{
    let options: [DebugMenuOption] = [
        .resetUserFlags,
        .bypassScanning,
        .showDebugDrawing,
        .printNetworkTraffic,
        .printInitAndDeinit,
        .relaxedScanningDistance,
        .clearResults,
        .useMockResults
    ]
}
