//
//  Expert.swift
//  Vessel
//
//  Created by Carson Whitsett on 1/31/23.
//

import Foundation

struct Expert: CoreObjectProtocol, Decodable
{
    let id: Int
    var last_updated: Int
    let storage: StorageType = .disk
    let url_code: String?
    let business_name: String?
    let description: String?
    let contact_id: Int?
    let phone_number: String?
    let expert_uuid: String
    let last_name: String?
    let first_name: String?
    let business_address: String?
    let logo_image_url: String?
    let dynamic_link: String?
    let download_url: String?
    let is_cobranded: Bool?
    
    enum CodingKeys: CodingKey
    {
        case id
        case last_updated
        case url_code
        case business_name
        case description
        case contact_id
        case phone_number
        case expert_uuid
        case last_name
        case first_name
        case business_address
        case logo_image_url
        case dynamic_link
        case download_url
        case is_cobranded
    }
}
