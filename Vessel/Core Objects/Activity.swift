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
    let description: String
    let frequency: String
    let imageUrl: String
    //let smallImage: String?
    let storage: StorageType = .cacheAndDisk
    
    var activityDetailsModel: ActivityDetailsModel
    {
        return ActivityDetailsModel(imageUrl: imageUrl, title: title, subtitle: frequency, description: description, reagents: nil, quantities: nil)
    }
    
    init(id: Int,
         last_updated: Int,
         title: String,
         description: String,
         imageUrl: String,
         frequency: String)
    {
        self.id = id
        self.last_updated = last_updated
        self.title = title
        self.description = description
        self.imageUrl = imageUrl
        self.frequency = frequency
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
}
