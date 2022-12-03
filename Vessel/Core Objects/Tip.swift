//
//  Tip.swift
//  Vessel
//
//  Created by Nicolas Medina on 11/29/22.
//

import Foundation

class Tip: CoreObjectProtocol
{
    var id: Int = 0
    var last_updated: Int = 0
    let storage: StorageType = .cacheAndDisk
    
    let title: String
    let description: String
    let imageUrl: String
    let frequency: String
    
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
        case title
        case description
        case imageUrl = "image_url"
        case frequency
    }
}
