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
let LOGIN = "authentication/auth/login/"
let SIGNUP = "authentication/auth/signup/"

class ChatBotViewModel: NSObject, ObservableObject, URLSessionTaskDelegate
{
    @Published var conversations: [Conversation] = []
    @Published var conversationHistory: [ConversationMessage] = []
    @Published var isProcessing: Bool = false
    
    enum LoginResponse
    {
        case success
        case error
        case invalidCredentials
    }
    
    func signup(username: String, completion: @escaping (Bool) -> ())
    {
        let urlString = "\(CHAT_URL)\(SIGNUP)"
        guard let url = URL(string: urlString) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: Dictionary = ["username": username, "password": "123qweQWE"]
        
        do
        {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: {data, response, error in
                guard error == nil else
                {
                    print(error?.localizedDescription ?? "Response Error")
                    completion(false)
                    return
                }
                guard let serverData = data else
                {
                    print("server data error")
                    completion(false)
                    return
                }
                do
                {
                    let json = try JSONSerialization.jsonObject(with: serverData, options: [])
                    let jsonData = try JSONSerialization.data(withJSONObject: json)
                    let response = try JSONDecoder().decode(ChatUser.self, from: jsonData)
                    Server.shared.chatToken = response.token
                    completion(true)
                } catch let responseError
                {
                    print("signup Serialisation in error in creating response body: \(responseError.localizedDescription)")
                    let message = String(bytes: serverData, encoding: .ascii)
                    print(message as Any)
                    completion(false)
                }
            })
            task.resume()
        }
        catch let error
        {
            print("JSONSerialization in error in creating response body: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    func login(username: String, completion: @escaping (LoginResponse) -> ())
    {
        let urlString = "\(CHAT_URL)\(LOGIN)"
        guard let url = URL(string: urlString) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let parameters: Dictionary = ["username": username, "password": "123qweQWE"]
        
        do
        {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: {data, response, error in
                guard error == nil else
                {
                    print(error?.localizedDescription ?? "Response Error")
                    completion(.error)
                    return
                }
                guard let serverData = data else
                {
                    print("server data error")
                    completion(.error)
                    return
                }
                do
                {
                    let json = try JSONSerialization.jsonObject(with: serverData, options: [])
                    let jsonData = try JSONSerialization.data(withJSONObject: json)
                    let response = try JSONDecoder().decode(ChatUser.self, from: jsonData)
                    Server.shared.chatToken = response.token
                    completion(.success)
                }
                catch let responseError
                {
                    print("login Serialisation in error in creating response body: \(responseError.localizedDescription)")
                    if let message = String(bytes: serverData, encoding: .ascii)
                    {
                        print(message as Any)
                        if message.contains("Invalid username or password.")
                        {
                            completion(.invalidCredentials)
                        }
                        else
                        {
                            completion(.error)
                        }
                    }
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
    func startChat() async -> Int
    {
        await withCheckedContinuation { continuation in
            startChat() { id in
                continuation.resume(returning: id)
            }
        }
    }
    
    @MainActor
    func startChat(completion: @escaping (Int) -> ())
    {
        let urlString = "\(CHAT_URL)\(CREATE_CONVERSATION)"
        let parameters = ["username": username]
        makeRequest(urlString: urlString,
                    parameters: parameters,
                    type: NewConversationResponse.self,
                    completion:
        { response in
            guard let response else
            {
                print("start chat error")
                return
            }
            self.conversations.append(Conversation(id: response.conversation.id))
            self.getConversationHistory(response.conversation.id)
            completion(response.conversation.id)
        })
    }
    
    @MainActor
    func getConversations()
    {
        let urlString = "\(CHAT_URL)\(GET_CONVERSATIONS)"
        let parameters = ["username": username]
        makeRequest(urlString: urlString,
                    parameters: parameters,
                    type: ConversationResponse.self,
                    completion:
        { response in
            guard let response else
            {
                print("getConversations error")
                return
            }
            self.conversations = response.conversations
        })
    }
    
    @MainActor
    func getConversationHistory(_ conversationId: Int)
    {
        let urlString = "\(CHAT_URL)\(GET_CONVERSATION_HISTORY)"
        let parameters: Dictionary = ["username": username, "conversation_id": conversationId] as [String: Any]
        makeRequest(urlString: urlString,
                    parameters: parameters,
                    type: ConversationHistoryResposne.self,
                    completion:
        { response in
            guard let response else
            {
                print("getConversationHistory error")
                return
            }
            self.conversationHistory = response.conversationHistory
        })
    }

    @MainActor
    func streamMessage(_ message: String, conversationId: Int) async throws
    {
        isProcessing = true
        let urlString = "\(CHAT_URL)\(SEND_MESSAGE)"
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        if let token = Server.shared.chatToken
        {
            request.setValue("Token \(token)", forHTTPHeaderField: AUTH_KEY)
        }
        
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        let parameters: Dictionary = ["username": username, "conversation_id": conversationId, "Body": message, "isNotPhoneCall": "Not a phone call"] as [String: Any]
        do
        {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
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
    
    func makeRequest<T>(urlString: String, parameters: [String: Any], type: T.Type, completion: @escaping (T?) -> ()) where T: Decodable
    {
        guard let url = URL(string: urlString) else
        {
            completion(nil)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = Server.shared.chatToken
        {
            request.setValue("Token \(token)", forHTTPHeaderField: AUTH_KEY)
        }

        if let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        {
            request.httpBody = httpBody
                
            let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                guard error == nil else
                {
                    print(error?.localizedDescription ?? "Response Error")
                    completion(nil)
                    return
                }
                guard let serverData = data else
                {
                    print("server data error")
                    completion(nil)
                    return
                }
                
                do
                {
                    let json = try JSONSerialization.jsonObject(with: serverData, options: [])
                    let jsonData = try JSONSerialization.data(withJSONObject: json)
                    let response = try JSONDecoder().decode(T.self, from: jsonData)
                    completion(response)
                }
                catch
                {
                    print("JSONSerialization in error in creating response body: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
            })
            task.resume()
        }
        else
        {
            completion(nil)
        }
    }
}

//MARK: Messages
extension ChatBotViewModel
{
    func addUserMessage(_ message: String)
    {
        let message = ConversationMessage(message: message, role: "user", created_at: messageDate(), updated_at: messageDate())
        self.conversationHistory.append(message)
    }
    
    private func messageDate() -> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        if let timeZone = TimeZone(secondsFromGMT: 0)
        {
            formatter.timeZone = timeZone
        }
        return formatter.string(from: Date())
    }
    
    func time(createdAt: String) -> Date?
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        if let timeZone = TimeZone(secondsFromGMT: 0)
        {
            formatter.timeZone = timeZone
        }
        let createdAtDate = formatter.date(from: createdAt) ?? Date()
        return createdAtDate
    }
}

extension ChatBotViewModel
{
    var username: String
    {
        return "mpes"
//        guard let firstName = Contact.main()?.first_name, let lastName = Contact.main()?.last_name else
//        {
//            return ""
//        }
//        return String((firstName + lastName).prefix(15))
    }
}
