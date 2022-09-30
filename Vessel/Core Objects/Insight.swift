//
//  Insight.swift
//  Vessel
//
//  Created by Nicolas Medina on 9/27/22.
//

import Foundation

struct Insight: Equatable
{
    var id: Int
    var lastUpdated: Int
    var title: String
    var subtitle: String
    var description: String
    var backgroundImage: String
    var completedDate: String?
    
    init(id: Int, lastUpdated: Int, title: String, subtitle: String, description: String, backgroundImage: String, completedDate: String?)
    {
        self.id = id
        self.lastUpdated = lastUpdated
        self.title = title
        self.subtitle = subtitle
        self.description = description
        self.backgroundImage = backgroundImage
        self.completedDate = completedDate
    }
    
    // MARK: - Equatable
    static func == (lhs: Insight, rhs: Insight) -> Bool
    {
        return lhs.id == rhs.id &&
        lhs.lastUpdated == rhs.lastUpdated &&
        lhs.title == rhs.title &&
        lhs.subtitle == rhs.subtitle &&
        lhs.description == rhs.description &&
        lhs.backgroundImage == rhs.backgroundImage &&
        lhs.completedDate == rhs.completedDate
    }
}
