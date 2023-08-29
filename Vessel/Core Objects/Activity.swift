//
//  Activity.swift
//  Vessel
//
//  Created by Nicolas Medina on 11/29/22.
//

import Foundation

class Tip: CoreObjectProtocol
{
    var id: Int = 0
    var last_updated: Int = 0
    let title: String
    let description: String?
    let frequency: String
    let imageUrl: String
    //let smallImage: String?
    let storage: StorageType = .cacheAndDisk
    var isLifestyleRecommendation = false
    var isPlan = false
    var subtitle = ""
    var longDescription = ""
    var isCompleted = false
    
    init(id: Int,
         last_updated: Int,
         title: String,
         description: String?,
         imageUrl: String,
         frequency: String,
         isLifestyleRecommendation: Bool = false,
         isPlan: Bool = false,
         subtitle: String = "",
         longDescription: String = "",
         isCompleted: Bool = false)
    {
        self.id = id
        self.last_updated = last_updated
        self.title = title
        self.description = description
        self.imageUrl = imageUrl
        self.frequency = frequency
        self.isLifestyleRecommendation = isLifestyleRecommendation
        self.isPlan = isPlan
        self.subtitle = subtitle
        self.longDescription = longDescription
        self.isCompleted = isCompleted
    }
    
    enum CodingKeys: String, CodingKey
    {
        case id
        case last_updated
        case title
        case description
        case frequency
        case imageUrl = "image_url"
    }
    
    func getActivityDetailsModel(planId: Int) -> ActivityDetailsModel
    {
        return ActivityDetailsModel(id: planId, imageUrl: imageUrl, title: title, subtitle: frequency, description: description ?? "", reagents: nil, quantities: nil, type: .activity)
    }
}
