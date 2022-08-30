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
    
    var title: String
    {
        switch self
        {
        case .resetUserFlags: return "Reset User Flags"
        case .bypassScanning: return "Bypass Scanning"
        case .showDebugDrawing: return "Show Debug Drawing"
        case .printNetworkTraffic: return "Print Network Traffic"
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
        case .bypassScanning: return "BYPASS_SCANNING"
        case .showDebugDrawing: return "SHOW_DEBUG_DRAWING"
        case .printNetworkTraffic: return Constants.KEY_PRINT_NETWORK_TRAFFIC
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
        .printNetworkTraffic
    ]
}
