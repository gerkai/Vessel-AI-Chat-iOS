//
//  AnalyticsProtocol.swift
//  Vessel
//
//  Created by Nicolas Medina on 7/11/22.
//

import UIKit

protocol Analytics {
    func setup()
    func log(event: String, properties: [String: Any])
}
