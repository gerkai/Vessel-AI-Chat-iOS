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
    var id: Int
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
    
    init(id: Int, lastUpdated: Int, imageURL: String?, title: String, subtext: String?, description: String)
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

extension LifestyleRecommendation
{
    static var takeATest: LifestyleRecommendation = LifestyleRecommendation(id: 11,
                                                                            lastUpdated: 0,
                                                                            imageURL: "https://dev-media.vesselhealth.com/test.png",
                                                                            title: NSLocalizedString("Take a Test", comment: ""),
                                                                            subtext: nil,
                                                                            description: NSLocalizedString("Unlock your results and get personalized recommendations", comment: ""))
    static var supplements: LifestyleRecommendation = LifestyleRecommendation(id: 13,
                                                                              lastUpdated: 0,
                                                                              imageURL: "https://dev-media.vesselhealth.com/Today%E2%80%99s%20Lesson2_1672865219290.jpg",
                                                                              title: NSLocalizedString("Get your supplement plan", comment: ""),
                                                                              subtext: nil,
                                                                              description: NSLocalizedString("Get a precise supplement plan personalized to you.", comment: ""))
    static var fuelPM: LifestyleRecommendation = LifestyleRecommendation(id: 14,
                                                                         lastUpdated: 0,
                                                                         imageURL: "https://dev-media.vesselhealth.com/PM%20Card@3x%20cropped_1672942873580.jpg",
                                                                         title: NSLocalizedString("Vessel Fuel PM", comment: ""),
                                                                         subtext: nil,
                                                                         description: NSLocalizedString("Only the finest ingredients designed for sleep to help you wake up feeling unstoppable.", comment: ""))
    static var fuelAM: LifestyleRecommendation = LifestyleRecommendation(id: 15,
                                                                         lastUpdated: 0,
                                                                         imageURL: "https://dev-media.vesselhealth.com/AM%20Card%20cropped_1672942778950.jpg",
                                                                         title: NSLocalizedString("Vessel Fuel AM", comment: ""),
                                                                         subtext: nil,
                                                                         description: NSLocalizedString("Personalized for you to help improve your nutrient levels and to help with %@.", comment: ""))
}
