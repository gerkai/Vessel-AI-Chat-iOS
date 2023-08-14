//
//  Conversation.swift
//  Vessel
//
//  Created by v.martin.peshevski on 13.8.23.
//

import Foundation

struct ConversationResponse: Decodable
{
    let conversations: [Conversation]
}

struct Conversation: Codable, Identifiable, Hashable
{
    let id: Int
}

struct NewConversationResponse: Decodable
{
    let conversation: NewConversation
}

struct NewConversation: Codable, Identifiable, Hashable
{
    let id: Int
    let message: String
}
