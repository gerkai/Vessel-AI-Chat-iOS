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
    var message: String
    let role: String
    let created_at: String
    let updated_at: String
    
    var isTag = false
    var currentTag = ""
    var tagCounter = 0
    var isBetweenTags: Bool { tagCounter % 2 != 0 }
    
    init(message: String, role: String, created_at: String, updated_at: String)
    {
        self.message = message
        self.role = role
        self.created_at = created_at
        self.updated_at = updated_at
    }
    
    init(from decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        var messageRaw = try values.decode(String.self, forKey: .message)
        messageRaw = messageRaw.replacingOccurrences(of: "<b>", with: "**")
        messageRaw = messageRaw.replacingOccurrences(of: "</b>", with: "**")
        messageRaw = messageRaw.replacingOccurrences(of: "<strong>", with: "**")
        messageRaw = messageRaw.replacingOccurrences(of: "</strong>", with: "**")
        messageRaw = messageRaw.replacingOccurrences(of: "</n>", with: "/n")
        message = messageRaw
        role = try values.decode(String.self, forKey: .role)
        created_at = try values.decode(String.self, forKey: .created_at)
        updated_at = try values.decode(String.self, forKey: .updated_at)
    }
        
    mutating func appendChar(_ c: Character)
    {
        if c == "<" {
            isTag = true
        } else if c == ">" {
            isTag = false
            currentTag.append(c)
            currentTag = currentTag.replacingOccurrences(of: "<b>", with: "**")
            currentTag = currentTag.replacingOccurrences(of: "</b>", with: "**")
            currentTag = currentTag.replacingOccurrences(of: "<strong>", with: "**")
            currentTag = currentTag.replacingOccurrences(of: "</strong>", with: "**")
            message.append(currentTag)
            currentTag = ""
            tagCounter += 1
            if isBetweenTags { message.append("**") }
            else if message.hasSuffix("**")
            {
                message.removeLast()
                message.removeLast()
            }
        }

        if isTag
        {
            currentTag.append(c)
        } else if c != ">"
        {
            if isBetweenTags
            {
                message.insert(c, at: message.index(message.endIndex, offsetBy: -2))
            }
            else { message.append(c) }
        }
    }
}
