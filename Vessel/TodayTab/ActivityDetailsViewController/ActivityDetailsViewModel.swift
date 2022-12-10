//
//  ActivityDetailsViewModel.swift
//  Vessel
//
//  Created by Nicolas Medina on 10/5/22.
//

import Foundation

struct ActivityDetailsModel
{
    let id: Int
    let imageUrl: String
    let title: String
    let subtitle: String
    let description: String
    let reagents: String?
    let quantities: String?
}

class ActivityDetailsViewModel
{
    // MARK: - Private vars
    private var object: ActivityDetailsModel
    
    private var isMetric: Bool
    {
        //determine if we are using imperial or metric units
        Locale.current.usesMetricSystem
    }
    
    // MARK: - Public properties
    var id: Int
    {
        object.id
    }
    
    var imageURL: URL?
    {
        URL(string: object.imageUrl)
    }
    
    var title: String
    {
        object.title
    }
    
    var subtitle: String
    {
        object.subtitle
    }
    
    var description: String
    {
        object.description
    }
    
    var reagents: String?
    {
        object.reagents
    }
    
    var quantities: String?
    {
        object.quantities
    }
    
    init(model: ActivityDetailsModel)
    {
        object = model
    }
}
