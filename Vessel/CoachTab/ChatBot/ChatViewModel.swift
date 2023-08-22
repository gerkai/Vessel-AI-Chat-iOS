//
//  ChatBotViewModel.swift
//  Vessel
//
//  Created by v.martin.peshevski on 10.8.23.
//

import SwiftUI

let CHAT_URL = "http://54.215.179.243:1000/"
let GET_CONVERSATION_HISTORY = "api/get_conversation_history"
let GET_CONVERSATIONS = "api/conversations"
let SEND_MESSAGE = "api/chat_2"
let CREATE_CONVERSATION = "api/create_conversation"
let TOKEN = "Token 852a988c1b4d7f56978564c78b207e21ef1933ba"

class ChatBotViewModel: NSObject, ObservableObject, URLSessionTaskDelegate
{
    @Published var conversations: [Conversation] = []
    @Published var conversationHistory: [ConversationMessage] = []
    @Published var isProcessing: Bool = false
    @Published var showBackButton = false
    
    func startChat(completion: @escaping (Int) -> ())
    {
        let urlString = "\(CHAT_URL)\(CREATE_CONVERSATION)"
        guard let url = URL(string: urlString) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //        if let accessToken = Server.shared.accessToken
        //        {
        request.setValue(TOKEN, forHTTPHeaderField: AUTH_KEY)
        //        }
        
        let dictBody: Dictionary = ["username": "mp"]
        do
        {
            let jsonData = try JSONSerialization.data(withJSONObject: dictBody, options: .prettyPrinted)
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: {data, response, error in
                guard error == nil else
                {
                    print(error?.localizedDescription ?? "Response Error")
                    return
                }
                guard let serverData = data else
                {
                    print("server data error")
                    return
                }
                do
                {                    
                    let json = try JSONSerialization.jsonObject(with: serverData, options: [])
                    let jsonData = try JSONSerialization.data(withJSONObject: json)
                    let response = try JSONDecoder().decode(NewConversationResponse.self, from: jsonData)
                    self.conversations.append(Conversation(id: response.conversation.id))
                    self.getConversationHistory(response.conversation.id)
                    completion(response.conversation.id)
                    print("startChat json: \(String(describing: json))")
                } catch let responseError
                {
                    print("Serialisation in error in creating response body: \(responseError.localizedDescription)")
                    let message = String(bytes: serverData, encoding: .ascii)
                    print(message as Any)
                }
            })
            task.resume()
        }
        catch let error
        {
            print("JSONSerialization in error in creating response body: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func getConversations()
    {
        let urlString = "\(CHAT_URL)\(GET_CONVERSATIONS)"
        guard let url = URL(string: urlString) else {return}
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
//        if let accessToken = Server.shared.accessToken
//        {
//            request.setValue("\(AUTH_PREFIX) \(accessToken)", forHTTPHeaderField: AUTH_KEY)
            request.setValue(TOKEN, forHTTPHeaderField: AUTH_KEY)
//        }
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        
        let dictBody: Dictionary = ["username": "mp"]
        do
        {
            let jsonData = try JSONSerialization.data(withJSONObject: dictBody, options: .prettyPrinted)
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: {data, response, error in
                guard error == nil else
                {
                    print(error?.localizedDescription ?? "Response Error")
                    return
                }
                guard let serverData = data else
                {
                    print("server data error")
                    return
                }
                do
                {
                    let json = try JSONSerialization.jsonObject(with: serverData, options: [])
                    let jsonData = try JSONSerialization.data(withJSONObject: json)
                    let response = try JSONDecoder().decode(ConversationResponse.self, from: jsonData)
                    self.conversations = response.conversations
//                    print("getConversations json: \(String(describing: self.conversations))")
                } catch let responseError
                {
                    print("Serialisation in error in creating response body: \(responseError.localizedDescription)")
                    let message = String(bytes: serverData, encoding: .ascii)
                    print(message as Any)
                }
            })
            task.resume()
        }
        catch let error
        {
            print("JSONSerialization in error in creating response body: \(error.localizedDescription)")
        }
    }
    
    func getConversationHistory(_ conversationId: Int)
    {
        let urlString = "\(CHAT_URL)\(GET_CONVERSATION_HISTORY)"
        guard let url = URL(string: urlString) else {return}
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
//        if let accessToken = Server.shared.accessToken
//        {
//            request.setValue("\(AUTH_PREFIX) \(accessToken)", forHTTPHeaderField: AUTH_KEY)
            request.setValue(TOKEN, forHTTPHeaderField: AUTH_KEY)
//        }
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        
        let dictBody: Dictionary = ["username": "mp", "conversation_id": conversationId] as [String: Any]
        do
        {
            let jsonData = try JSONSerialization.data(withJSONObject: dictBody, options: .prettyPrinted)
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: {data, response, error in
                guard error == nil else
                {
                    print(error?.localizedDescription ?? "Response Error")
                    return
                }
                guard let serverData = data else
                {
                    print("server data error")
                    return
                }
                do
                {
                    let json = try JSONSerialization.jsonObject(with: serverData, options: [])
                    let jsonData = try JSONSerialization.data(withJSONObject: json)
                    let response = try JSONDecoder().decode(ConversationHistoryResposne.self, from: jsonData)
                    self.conversationHistory = response.conversationHistory
//                    print("getConversationHistory json: \(String(describing: self.conversationHistory))")
                } catch let responseError
                {
                    print("Serialisation in error in creating response body: \(responseError.localizedDescription)")
                    let message = String(bytes: serverData, encoding: .ascii)
                    print(message as Any)
                }
            })
            task.resume()
        }
        catch let error
        {
            print("JSONSerialization in error in creating response body: \(error.localizedDescription)")
        }
    }
    
    func sendMessage(_ message: String, conversationId: Int)
    {
        isProcessing = true
        let urlString = "\(CHAT_URL)\(SEND_MESSAGE)"
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
//        if let accessToken = Server.shared.accessToken
//        {
//            request.setValue("\(AUTH_PREFIX) \(accessToken)", forHTTPHeaderField: AUTH_KEY)
            request.setValue(TOKEN, forHTTPHeaderField: AUTH_KEY)
//        }
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        let dictBody: Dictionary = ["username": "mp", "conversation_id": conversationId, "Body": message, "isNotPhoneCall": "Not a phone call"] as [String: Any]
        do
        {
            let jsonData = try JSONSerialization.data(withJSONObject: dictBody, options: .prettyPrinted)
            request.httpBody = jsonData
            
//            let task1 = URLSession.shared.streamTask(withHostName: <#T##String#>, port: <#T##Int#>)
            let task = URLSession.shared.dataTask(with: request, completionHandler: {data, response, error in
                guard error == nil else
                {
                    print(error?.localizedDescription ?? "Response Error")
                    return
                }
                guard let serverData = data else
                {
                    print("server data error")
                    return
                }
                
                let string = String(data: serverData, encoding: .utf8)
                print("sendMessage response: \(String(describing: string))")
                let message = ConversationMessage(message: string ?? "Error", role: "assistant", created_at: self.messageDate(), updated_at: self.messageDate())
                self.conversationHistory.append(message)
                self.isProcessing = false
//                print("conversationHistory: \(String(describing: self.conversationHistory))")
            })
            task.resume()
        }
        catch let error
        {
            isProcessing = false
            print("JSONSerialization in error in creating response body: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func streamMessage(_ message: String, conversationId: Int) async throws
    {
        isProcessing = true
        let urlString = "\(CHAT_URL)\(SEND_MESSAGE)"
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
//        if let accessToken = Server.shared.accessToken
//        {
//            request.setValue("\(AUTH_PREFIX) \(accessToken)", forHTTPHeaderField: AUTH_KEY)
            request.setValue(TOKEN, forHTTPHeaderField: AUTH_KEY)
//        }
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        let dictBody: Dictionary = ["username": "mp", "conversation_id": conversationId, "Body": message, "isNotPhoneCall": "Not a phone call"] as [String: Any]
        do
        {
            let jsonData = try JSONSerialization.data(withJSONObject: dictBody, options: .prettyPrinted)
            request.httpBody = jsonData
            
            let (bytes, _) = try await URLSession.shared.bytes(for: request)
            var message = ConversationMessage(message: "", role: "assistant", created_at: self.messageDate(), updated_at: self.messageDate())
            self.conversationHistory.append(message)
            for try await character in bytes.characters
            {
                self.conversationHistory.removeLast()
                message.appendChar(character)
                self.conversationHistory.append(message)
            }
            self.isProcessing = false
        }
        catch let error
        {
            isProcessing = false
            print("JSONSerialization in error in creating response body: \(error.localizedDescription)")
        }
    }
    
    func addUserMessage(_ message: String)
    {
        let message = ConversationMessage(message: message, role: "user", created_at: messageDate(), updated_at: messageDate())
        self.conversationHistory.append(message)
    }
    
    private func messageDate() -> String
    {
        let dateFormatter = DateFormatter()
        return dateFormatter.string(from: Date())
    }
}
