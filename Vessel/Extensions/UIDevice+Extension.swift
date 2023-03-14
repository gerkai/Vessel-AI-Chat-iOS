//
//  UIDevice+Extension.swift
//  Vessel
//
//  Created by Nicolas Medina on 3/13/23.
//

import UIKit

extension UIDevice
{
    static let isIphone14: Bool =
    {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        let iPhone14Identifiers = ["iPhone15,2", "iPhone15,3"]
        return iPhone14Identifiers.contains(identifier)
    }()
}
