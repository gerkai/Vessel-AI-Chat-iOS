//
//  ChatUser.swift
//  Vessel
//
//  Created by v.martin.peshevski on 22.8.23.
//

import Foundation

struct ChatUser: Decodable
{
    let user: User
    let token: String
}

struct User: Decodable
{
    let id: Int
    let username: String
    let password: String
}
