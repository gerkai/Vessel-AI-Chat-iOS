//
//  ChatViewModel.swift
//  Vessel
//
//  Created by v.martin.peshevski on 10.8.23.
//

import SwiftUI

// http://54.215.179.243:1000 is the base URL
//
//api/get_conversation_history: getting previous messages in the conversation
//api/conversations: getting the conversation ids for a user
//api/chat_2: send a message, get a response from the AI
//api/create_conversation: start a conversation

let CHAT_URL = "http://54.215.179.243:1000/"

let GET_CONVERSATION_HISTORY = "api/get_conversation_history"
let GET_CONVERSATIONS = "api/conversations"
let SEND_MESSAGE = "api/chat_2"
let CREATE_CONVERSATION = "api/create_conversation"

class ChatViewModel: ObservableObject
{
    @Published var messages: [MessageModel] = []
    
    func startChat()
    {
        let urlString = "\(CHAT_URL)\(CREATE_CONVERSATION)"
        guard let url = URL(string: urlString) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue("vessel-ios", forHTTPHeaderField: "User-Agent")
        if let accessToken = Server.shared.accessToken
        {
//            print("Token \(accessToken)")
            request.setValue("Token ea81e2878e24e4f010c5936f677e96e6dd9843da", forHTTPHeaderField: AUTH_KEY)
        }

        // Set parameters here. Replace with your own.
        //        let postData = "param1_id=param1_value&param2_id=param2_value".data(using: .utf8)
        //        request.httpBody = postData
        
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
                print("serverData json: \(String(describing: json))")
                if let object = json as? [String: Any]
                {
                    print("serverData object: \(String(describing: object))")
                }
                print("serverData: \(String(describing: String(data: serverData, encoding: .utf8)))")
                if let requestJson = try JSONSerialization.jsonObject(with: serverData, options: .mutableContainers) as? [String: Any]{
                    print("Response: \(requestJson)")
                }
            } catch let responseError
            {
                print("Serialisation in error in creating response body: \(responseError.localizedDescription)")
                let message = String(bytes: serverData, encoding: .ascii)
                print(message as Any)
            }
        })
        task.resume()
    }
    
    func getConversations()
    {
        let urlString = "\(CHAT_URL)\(GET_CONVERSATIONS)"
        guard let url = URL(string: urlString) else {return}
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        if let accessToken = Server.shared.accessToken
        {
            request.setValue("\(AUTH_PREFIX) \(accessToken)", forHTTPHeaderField: AUTH_KEY)
        }
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("vessel-ios", forHTTPHeaderField: "User-Agent")
        
        //        Set parameters here. Replace with your own.
        //        username
                
        //        let postData = "message=\(message)".data(using: .utf8)
        //        request.httpBody = postData
        
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
                if let requestJson = try JSONSerialization.jsonObject(with: serverData, options: .mutableContainers) as? [String: Any]{
                    print("Response: \(requestJson)")
                }
            } catch let responseError
            {
                print("Serialisation in error in creating response body: \(responseError.localizedDescription)")
                let message = String(bytes: serverData, encoding: .ascii)
                print(message as Any)
            }
        })
        task.resume()
    }
    
    func getConversationHistory()
    {
        let urlString = "\(CHAT_URL)\(GET_CONVERSATION_HISTORY)"
        guard let url = URL(string: urlString) else {return}
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        if let accessToken = Server.shared.accessToken
        {
            request.setValue("\(AUTH_PREFIX) \(accessToken)", forHTTPHeaderField: AUTH_KEY)
        }
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("vessel-ios", forHTTPHeaderField: "User-Agent")
        
//        Set parameters here. Replace with your own.
//        username
//        conversation_id
        
//        let postData = "message=\(message)".data(using: .utf8)
//        request.httpBody = postData
        
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
                if let requestJson = try JSONSerialization.jsonObject(with: serverData, options: .mutableContainers) as? [String: Any]{
                    print("Response: \(requestJson)")
                }
            } catch let responseError
            {
                print("Serialisation in error in creating response body: \(responseError.localizedDescription)")
                let message = String(bytes: serverData, encoding: .ascii)
                print(message as Any)
            }
        })
        task.resume()
    }
    
    func sendMessage(_ message: String)
    {
        let urlString = "\(CHAT_URL)\(SEND_MESSAGE)"
        guard let url = URL(string: urlString) else {return}
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        if let accessToken = Server.shared.accessToken
        {
            request.setValue("\(AUTH_PREFIX) \(accessToken)", forHTTPHeaderField: AUTH_KEY)
        }
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("vessel-ios", forHTTPHeaderField: "User-Agent")
        // Set parameters here. Replace with your own.
        
//        conversation_id
//        username
//        Body (this is the message body, can/would like to rename it)
        
        let postData = "message=\(message)".data(using: .utf8)
        request.httpBody = postData
        
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
                if let requestJson = try JSONSerialization.jsonObject(with: serverData, options: .mutableContainers) as? [String: Any]{
                    print("Response: \(requestJson)")
                }
            } catch let responseError
            {
                print("Serialisation in error in creating response body: \(responseError.localizedDescription)")
                let message = String(bytes: serverData, encoding: .ascii)
                print(message as Any)
            }
        })
        task.resume()
    }
}
