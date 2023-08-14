//
//  ConversationMessage.swift
//  Vessel
//
//  Created by v.martin.peshevski on 13.8.23.
//

import Foundation

struct ConversationHistoryResposne: Decodable
{
    let conversationHistory: [ConversationMessage]
    
    enum CodingKeys: String, CodingKey
    {
        case conversationHistory = "conversation_history"
    }
}

struct ConversationMessage: Codable, Hashable
{
    let message: String
    let role: String
    let created_at: String
    let updated_at: String
}
