//
//  Server.swift
//  Vessel
//
//  Created by Carson Whitsett on 2/26/22.
//
//  All back end communication goes through here.
//  All callbacks are dispatched on MainQueue
//  TODO: Handle refresh tokens

import Foundation

let ENDPOINT_ROOT = "v3/"

//Environment Constants
let DEV_API = "https://dev-api.vesselhealth.com/" + ENDPOINT_ROOT
//let DEV_ORDER_CARDS_URL = "https://dev.vesselhealth.com/membership-dev"
let DEV_QUIZ_URL = "https://vesselhealth.com/pages/new-quiz"

let STAGING_API = "https://staging-api.vesselhealth.com/" + ENDPOINT_ROOT
//let STAGING_ORDER_CARDS_URL = "https://stage.vesselhealth.com/membership"
let STAGING_QUIZ_URL = "https://vesselhealth.com/pages/new-quiz"

let PROD_API = "https://api.vesselhealth.com/" + ENDPOINT_ROOT
//let PROD_ORDER_CARDS_URL = "https://vesselhealth.com/membership"
let PROD_QUIZ_URL = "https://vesselhealth.com/pages/new-quiz"

//Security strings
let AUTH_PREFIX = "Bearer"
let AUTH_KEY = "Authorization"

let SUPPORT_URL = "http://help.vesselhealth.com/"

//Endpoints
let SERVER_FORGOT_PASSWORD_PATH = "auth/forgot-password"
let SERVER_LOGIN_PATH = "auth/login"
let APPLE_LOGIN_PATH = "auth/apple/login"
let APPLE_RETRIEVE_PATH = "auth/apple/retrieve"
let GOOGLE_LOGIN_PATH = "auth/google/login"
let GOOGLE_RETRIEVE_PATH = "auth/google/retrieve"
let CONTACT_PATH = "contact"
let CONTACT_EXISTS_PATH = "contact/exists"

class Server: NSObject
{
    static let shared = Server()
    //TODO: Move access and refresh tokens to secure storage
    var accessToken: String?
    var refreshToken: String?
    
    func API() -> String
    {
        let index = UserDefaults.standard.integer(forKey: Constants.environmentKey)
        switch index
        {
            case Constants.DEV_INDEX:
                return DEV_API
            case Constants.STAGING_INDEX:
                return STAGING_API
            default:
                return PROD_API
        }
    }
    
    func QuizURL() -> String
    {
        let index = UserDefaults.standard.integer(forKey: Constants.environmentKey)
        switch index
        {
            case Constants.DEV_INDEX:
                return DEV_QUIZ_URL
            case Constants.STAGING_INDEX:
                return STAGING_QUIZ_URL
            default:
                return PROD_QUIZ_URL
        }
    }
    
    func SupportURL() -> String
    {
        return SUPPORT_URL
    }

    private func serverGet(url: String, onSuccess success: @escaping (_ data: Data) -> Void, onFailure failure: @escaping (_ string: String) -> Void)
    {
        guard let serviceUrl = URL(string: url) else { return }
        let request = URLRequest(url: serviceUrl)
        
        var mutableRequest = request
        mutableRequest.httpMethod = "GET"
        mutableRequest.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        if accessToken != nil
        {
            mutableRequest.setValue("\(AUTH_PREFIX) \(accessToken!)", forHTTPHeaderField: AUTH_KEY)
        }
        mutableRequest.setValue("vessel-ios", forHTTPHeaderField: "User-Agent")
        
        //print("\(mutableRequest)")
        let session = URLSession.shared
        session.dataTask(with: mutableRequest)
        { (data, response, error) in
            if let data = data //unwrap data
            {
                //self.debugJSONResponse(data: data)
                success(data)
            }
            else
            {
                //print(error)
                failure("Error: no data returned")
            }
        }.resume()
    }
    
    private func serverPost(request: URLRequest, onSuccess success: @escaping (_ json: [String: Any]) -> Void, onFailure failure: @escaping (_ string: String) -> Void)
    {
        serverWrite(request: request, requestType: "POST", onSuccess: success, onFailure: failure)
    }
    
    private func serverPut(request: URLRequest, onSuccess success: @escaping (_ json: [String: Any]) -> Void, onFailure failure: @escaping (_ string: String) -> Void)
    {
        serverWrite(request: request, requestType: "PUT", onSuccess: success, onFailure: failure)
    }
    
    private func serverWrite(request: URLRequest, requestType: String, onSuccess success: @escaping (_ json: [String: Any]) -> Void, onFailure failure: @escaping (_ string: String) -> Void)
    {
        var mutableRequest = request
        mutableRequest.httpMethod = "POST"
        mutableRequest.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        if accessToken != nil
        {
            mutableRequest.setValue("\(AUTH_PREFIX) \(accessToken!)", forHTTPHeaderField: AUTH_KEY)
        }
        mutableRequest.setValue("vessel-ios", forHTTPHeaderField: "User-Agent")
        if let url = request.url
        {
            print("POST: \(url)")
        }
        //print("\(mutableRequest)")
        let session = URLSession.shared
        session.dataTask(with: mutableRequest)
        { (data, response, error) in
            if let data = data //unwrap data
            {
                do
                {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
//CW: Put a breakpoint here to see json response from server
                    if let object = json as? [String: Any]
                    {
                        success(object)
                    }
                    else
                    {
                        failure("Unable to parse response from server")
                    }
                }
                catch
                {
                    let string = String.init(data: data, encoding: .utf8)
                    print("ERROR: \(string ?? "Unknown")")
                    failure(error.localizedDescription)
                }
            }
        }.resume()
    }
    
    private func postToServer(dictBody: [String: String], url: String, onSuccess success: @escaping (_ object: [String: Any]) -> Void, onFailure failure: @escaping (_ message: String) -> Void)
    {
        do
        {
            let jsonData = try JSONSerialization.data(withJSONObject: dictBody, options: .prettyPrinted)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            //print(jsonString)

            let Url = String(format: url)
            guard let serviceUrl = URL(string: Url) else { return }
            var request = URLRequest(url: serviceUrl)
            request.httpBody = jsonData
            
            serverPost(request: request, onSuccess:
            { (object) in
                DispatchQueue.main.async()
                {
                    success(object)
                }
            },
            onFailure:
            { (string) in
                DispatchQueue.main.async()
                {
                    failure(NSLocalizedString("Server Error", comment: ""))
                }
            })
        }
        catch
        {
            print(error.localizedDescription)
        }
    }
    
    func appleLoginURL() -> String
    {
        return "\(API())\(APPLE_LOGIN_PATH)"
    }
    
    func appleRetrieveURL() -> String
    {
        return "\(API())\(APPLE_RETRIEVE_PATH)"
    }
    
    func googleLoginURL() -> String
    {
        return "\(API())\(GOOGLE_LOGIN_PATH)"
    }
    
    func googleRetrieveURL() -> String
    {
        return "\(API())\(GOOGLE_RETRIEVE_PATH)"
    }
    
    //MARK: - Public functions
    
    func isLoggedIn() -> Bool
    {
        //if we have an access token, then we're assumed to be logged in
        return accessToken != nil
    }
    
    func forgotPassword(email: String, onSuccess success: @escaping (_ message: String) -> Void, onFailure failure: @escaping (_ object: [String: Any]) -> Void)
    {
        var dictPostBody = [String: String]()
        dictPostBody["email"] = email
        
        postToServer(dictBody: dictPostBody, url: "\(API())\(SERVER_FORGOT_PASSWORD_PATH)")
        { object in
            if let message = object["message"] as? String
            {
                success(message)
            }
            else
            {
                success("")
            }
        }
        onFailure:
        { message in
            failure(["Failure": NSLocalizedString("Server Error", comment: "")])
        }
    }
    
    func login(email: String, password: String, onSuccess success: @escaping () -> Void, onFailure failure: @escaping (_ string: String) -> Void)
    {
        var dictPostBody = [String: String]()
        dictPostBody["email"] = email
        dictPostBody["password"] = password
        
        postToServer(dictBody: dictPostBody, url: "\(API())\(SERVER_LOGIN_PATH)")
        { object in
            if let accessToken = object["access_token"] as? String, let refreshToken = object["refresh_token"] as? String
            {
                self.accessToken = accessToken
                self.refreshToken = refreshToken
                DispatchQueue.main.async()
                {
                    success()
                }
            }
            else
            {
                DispatchQueue.main.async()
                {
                    failure(NSLocalizedString("This email and password combination is incorrect", comment: ""))
                }
            }
        }
        onFailure:
        { string in
            DispatchQueue.main.async()
            {
                failure(string)
            }
        }
    }
    
    private func debugJSONResponse(data: Data)
    {
        do
        {
            let jsonString = String(data: data, encoding: .utf8)!
            print("SUCCESS: \(jsonString)")
        }
    }
    
    //call this after successful Google / Apple SSO sign-in. This will establish access and refresh tokens
    func getTokens(isGoogle: Bool, onSuccess success: @escaping () -> Void, onFailure failure: @escaping (_ string: String) -> Void)
    {
        let url = isGoogle ? googleRetrieveURL() : appleRetrieveURL()
        serverGet(url: url)
        { data in
            do
            {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any]
                {
                    if let accessToken = object["access_token"] as? String, let refreshToken = object["refresh_token"] as? String
                    {
                        self.accessToken = accessToken
                        self.refreshToken = refreshToken
                        DispatchQueue.main.async()
                        {
                            success()
                        }
                    }
                }
                else
                {
                    DispatchQueue.main.async()
                    {
                        failure(NSLocalizedString("Unable to decode access token", comment: "Server error message"))
                    }
                }
            }
            catch
            {
                DispatchQueue.main.async()
                {
                    failure(NSLocalizedString("Unable to decode access token", comment: "Server error message"))
                }
            }
        }
        onFailure:
        { string in
            DispatchQueue.main.async()
            {
                failure(string)
            }
        }
    }
    
    func logOut()
    {
        accessToken = nil
        refreshToken = nil
    }
    
    //MARK:  Contact
    
    ///will return true if contact e-mail exists on back end
    func contactExists(email: String, onSuccess success: @escaping (_ exists: Bool) -> Void, onFailure failure: @escaping (_ string: String) -> Void)
    {
        var dictPostBody = [String: String]()
        dictPostBody["email"] = email
        
        postToServer(dictBody: dictPostBody, url: "\(API())\(CONTACT_EXISTS_PATH)")
        { object in
            if let exists = object["exists"] as? Bool
            {
                DispatchQueue.main.async()
                {
                    success(exists)
                }
            }
            else
            {
                DispatchQueue.main.async()
                {
                    failure("ContactExists: Unexpected Server Response")
                }
            }
        }
        onFailure:
        { message in
            failure(NSLocalizedString("Server Error", comment: ""))
        }
    }
    
    //pass an ID to get a specific contact or leave nil to get the primary contact
    func getContact(id: Int? = nil, onSuccess success: @escaping (_ contact: Contact) -> Void, onFailure failure: @escaping (_ error: String) -> Void)
    {
        //print("GET CONTACT...")
        if accessToken != nil
        {
            var url = "\(API())\(CONTACT_PATH)"
            if id != nil
            {
                url = url + "/\(id!)"
            }
            serverGet(url: url)
            { data in
                //let str = String(decoding: data, as: UTF8.self)
                //print (str)
                
                let decoder = JSONDecoder()
                do
                {
                    let contact = try decoder.decode(Contact.self, from: data)
                    //print(contact)
                    DispatchQueue.main.async()
                    {
                        success(contact)
                    }
                }
                
                 //cw: good for debugging JSON responses
                 catch DecodingError.dataCorrupted(let context)
                {
                    print(context)
                }
                catch DecodingError.keyNotFound(let key, let context)
                {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                }
                catch DecodingError.valueNotFound(let value, let context)
                {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                }
                catch DecodingError.typeMismatch(let type, let context)
                {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                }
                catch
                {
                    print("error: ", error)
                    DispatchQueue.main.async()
                    {
                        failure(error.localizedDescription)
                    }
                }
            }
            onFailure:
            { string in
                DispatchQueue.main.async()
                {
                    failure(string)
                }
            }
        }
    }
    
    func createContact(contact: Contact, onSuccess success:@escaping () -> Void, onFailure failure: @escaping (_ error: String) -> Void)
    {
        let url = "\(API())\(CONTACT_PATH)"
        
        if var contactDict = contact.dictionary
        {
            contactDict.removeValue(forKey: "id")
            do
            {
                let jsonData = try JSONSerialization.data(withJSONObject: contactDict, options: .prettyPrinted)
                let jsonString = String(data: jsonData, encoding: .utf8)!
                //print(jsonString)
                
                let Url = String(format: url)
                guard let serviceUrl = URL(string: Url) else { return }
                var request = URLRequest(url: serviceUrl)
                request.httpBody = jsonData
                
                //send it to server
                serverPost(request: request, onSuccess:
                { (object) in
                    if let accessToken = object["access_token"] as? String, let refreshToken = object["refresh_token"] as? String
                    {
                        self.accessToken = accessToken
                        self.refreshToken = refreshToken
                        DispatchQueue.main.async()
                        {
                            success()
                        }
                    }
                    else
                    {
                        DispatchQueue.main.async()
                        {
                            failure(NSLocalizedString("This email and password combination is incorrect", comment: ""))
                        }
                    }
                },
                onFailure:
                { (string) in
                    DispatchQueue.main.async()
                    {
                        failure(NSLocalizedString("Server Error", comment: ""))
                    }
                })
            }
            catch
            {
                print(error.localizedDescription)
                DispatchQueue.main.async()
                {
                    failure(error.localizedDescription)
                }
            }
        }
    }
    
    func updateContact(contact: Contact, onSuccess success: @escaping () -> Void, onFailure failure: @escaping (_ error: String) -> Void)
    {
        if accessToken != nil
        {
            let url = "\(API())\(CONTACT_PATH)"

            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try! encoder.encode(contact)
            let jsonString = String(data: data, encoding: .utf8)!
            //print(jsonString)
            
            let Url = String(format: url)
            guard let serviceUrl = URL(string: Url) else { return }
            var request = URLRequest(url: serviceUrl)
            request.httpBody = data
            
            //send it to server
            serverPut(request: request, onSuccess:
            { (object) in
                DispatchQueue.main.async()
                {
                    success()
                }
            },
            onFailure:
            { (string) in
                DispatchQueue.main.async()
                {
                    failure(NSLocalizedString("Server Error", comment: ""))
                }
            })
        }
    }
}
/*
 
 
{
    "id": Int,
    "lastUpdated": Int,
    "title": String,
    "link_url": String,
    "link_text": String,
    "description": String,
    "insert_date": String(Date)
}

*/
