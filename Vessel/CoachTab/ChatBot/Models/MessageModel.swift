//
//  MessageModel.swift
//  Vessel
//
//  Created by v.martin.peshevski on 11.9.23.
//

import Foundation

struct MessageModel: Codable, Hashable
{
    var text: String
    var timestamp: Date
}
