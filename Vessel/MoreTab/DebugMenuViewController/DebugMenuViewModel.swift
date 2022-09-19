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
        }
    }
    
    func toggle()
    {
        if let flag = flag
        {
            if isEnabled
            {
                UserDefaults.standard.removeObject(forKey: flag)
            }
            else
            {
                UserDefaults.standard.set(true, forKey: flag)
            }
        }
        else if self == .resetUserFlags
        {
            if let main = Contact.main()
            {
                main.flags = 0
                ObjectStore.shared.ClientSave(main)
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
        .relaxedScanningDistance
    ]
}
