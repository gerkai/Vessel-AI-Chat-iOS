//
//  UIScreenExtension.swift
//  Vessel
//
//  Created by Nicolas Medina on 12/23/22.
//

import UIKit

enum ScreenSize
{
    case small
    case mid
    case large
}

extension UIScreen
{
    func getScreenSize() -> ScreenSize
    {
        if bounds.width <= 375
        {
            return .small
        }
        else if bounds.width >= 414
        {
            return .large
        }
        else
        {
            return .mid
        }
    }
}
