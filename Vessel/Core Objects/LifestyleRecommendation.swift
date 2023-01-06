//
//  LifestyleRecommendation.swift
//  Vessel
//
//  Created by Carson Whitsett on 1/4/23.
//
//  Commented out last_updated as we're loading this object with V2 api. Once we switch to ObjectStore, put last_updated back in.
//  V2 object has no subtext so commented that out too

import Foundation

class LifestyleRecommendation: CoreObjectProtocol
{
    let id: Int
    //var last_updated: Int
    var last_updated: Int
    {
        get
        {
            _last_updated ?? 0
        }
        set
        {
            _last_updated = newValue
        }
    }

    private var _last_updated: Int?
    var imageURL: String?
    var title: String
    var subtext: String?
    var description: String
    let storage: StorageType = .cache //just store in cache for now since we're loading each time using V2 API
    
    init(id: Int, lastUpdated: Int, imageURL: String?, title: String, subtext: String, description: String)
    {
        self.id = id
        self.imageURL = imageURL
        self.title = title
        self.subtext = subtext
        self.description = description
        self.last_updated = lastUpdated
    }
    
    enum CodingKeys: String, CodingKey
    {
        case id
        //case last_updated
        case imageURL = "image_url"
        case title = "activity_name"
        //case subtext
        case description
    }
}

