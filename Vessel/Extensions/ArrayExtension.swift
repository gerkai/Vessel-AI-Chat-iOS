//
//  ArrayExtension.swift
//  Vessel
//
//  Created by Nicolas Medina on 7/26/22.
//

import Foundation

extension Array
{
    subscript (safe index: Int) -> Element?
    {
        guard index >= 0 && index < count else
        {
            return nil
        }

        return self[index]
    }
}
