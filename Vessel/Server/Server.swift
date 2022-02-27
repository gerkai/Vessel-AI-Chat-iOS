//
//  Server.swift
//  Vessel
//
//  Created by Carson Whitsett on 2/26/22.
//
//  All back end communication goes through here.
//  All callbacks are dispatched on MainQueue

import Foundation

let DEV_API = "https://dev-api.vesselhealth.com/v2/"
let DEV_ORDER_CARDS_URL = "https://dev.vesselhealth.com/membership-dev"

let STAGING_API = "https://staging-api.vesselhealth.com/v2/"
let STAGING_ORDER_CARDS_URL = "https://stage.vesselhealth.com/membership"

let PROD_API = "https://api.vesselhealth.com/v2/"
let PROD_ORDER_CARDS_URL = "https://vesselhealth.com/membership"

let AUTH_PREFIX =                       "Bearer"
let AUTH_KEY  =                         "Authorization"

let SUPPORT_URL = "http://help.vesselhealth.com/"

let SERVER_FORGOT_PASSWORD_PATH =       "auth/forgot-password"
let SERVER_LOGIN_PATH =                 "auth/login"
let APPLE_LOGIN_PATH =                  "auth/apple/login"
let APPLE_RETRIEVE_PATH =               "auth/apple/retrieve"
let GOOGLE_LOGIN_PATH =                 "auth/google/login"
let GOOGLE_RETRIEVE_PATH =              "auth/google/retrieve"
let CONTACT_PATH =                      "contact"
let CONTACT_EXISTS_PATH =               "contact/exists"

class Server: NSObject
{
    static let shared = Server()
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
    
    func OrderCardsURL() -> String
    {
        let index = UserDefaults.standard.integer(forKey: Constants.environmentKey)
        switch index
        {
            case Constants.DEV_INDEX:
                return DEV_ORDER_CARDS_URL
            case Constants.STAGING_INDEX:
                return STAGING_ORDER_CARDS_URL
            default:
                return PROD_ORDER_CARDS_URL
        }
    }
    
    func SupportURL() -> String
    {
        return SUPPORT_URL
    }

    func serverPost(request : URLRequest, onSuccess success: @escaping (_ json : [String : Any]) -> Void, onFailure failure: @escaping (_ string : String) -> Void)
    {
        var mutableRequest = request
        mutableRequest.httpMethod = "POST"
        mutableRequest.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        /*if(MainUser.shared.profile != nil)
        {
            mutableRequest.setValue("\(AUTH_PREFIX) \(MainUser.shared.profile!.AuthToken)", forHTTPHeaderField: AUTH_KEY)
        }
         */
        mutableRequest.setValue("vessel-ios", forHTTPHeaderField: "User-Agent")
        
        let session = URLSession.shared
        session.dataTask(with: mutableRequest)
        { (data, response, error) in

            if let data = data //unwrap data
            {
                do
                {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
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
    
    func postToServer(dictBody: [String : String], url: String, onSuccess success: @escaping (_ object: [String : Any]) -> Void, onFailure failure: @escaping (_ message: String) -> Void)
    {
        do
        {
            let jsonData = try JSONSerialization.data(withJSONObject: dictBody, options: .prettyPrinted)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            print(jsonString)

            let Url = String(format:url)
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
                    failure(NSLocalizedString("Server Error", comment:""))
                }
            })
        }
        catch
        {
            print(error.localizedDescription)
        }
    }
    //MARK: - Public functions
    
    ///will return true if contact e-mail exists on back end
    func contactExists(email: String, onSuccess success: @escaping (_ exists: Bool) -> Void, onFailure failure: @escaping (_ string: String) -> Void)
    {
        var dictPostBody = [String : String]()
        dictPostBody["email"] = email
        
        postToServer(dictBody: dictPostBody, url: "\(API())\(CONTACT_EXISTS_PATH)")
        { object in
            if let exists = object["exists"] as? Bool
            {
                success(exists)
            }
            else
            {
                failure("ContactExists: Unexpected Server Response")
            }
        }
        onFailure:
        { message in
            failure(NSLocalizedString("Server Error", comment:""))
        }
    }
    
    func forgotPassword(email: String, onSuccess success: @escaping (_ message: String) -> Void, onFailure failure: @escaping (_ object: [String : Any]) -> Void)
    {
        var dictPostBody = [String : String]()
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
            failure(["Failure" : NSLocalizedString("Server Error", comment:"")])
        }
    }
    
    func login(email: String, password: String, onSuccess success: @escaping () -> Void, onFailure failure: @escaping (_ string: String) -> Void)
    {
        var dictPostBody = [String : String]()
        dictPostBody["email"] = email
        dictPostBody["password"] = password
        
        postToServer(dictBody: dictPostBody, url: "\(API())\(SERVER_LOGIN_PATH)")
        { object in
            if let accessToken = object["access_token"] as? String, let refreshToken = object["refresh_token"] as? String
            {
                self.accessToken = accessToken
                self.refreshToken = refreshToken
                success()
            }
            else
            {
                failure(NSLocalizedString("Bad username or password", comment:""))
            }
        }
        onFailure:
        { string in
            failure(string)
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
    
    func getTokens(isGoogle: Bool, onSuccess success: @escaping () -> Void, onFailure failure: @escaping () -> Void)
    {
        let Url = isGoogle ? googleRetrieveURL() : appleRetrieveURL()
        guard let serviceUrl = URL(string: Url) else { return }
        let request = URLRequest(url: serviceUrl)
        
        var mutableRequest = request
        mutableRequest.httpMethod = "GET"
        mutableRequest.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        mutableRequest.setValue("vessel-ios", forHTTPHeaderField: "User-Agent")
        
        let session = URLSession.shared
        session.dataTask(with: mutableRequest)
        { (data, response, error) in

            if let data = data //unwrap data
            {
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
                        
                        //print("SUCCESS: \(object)")
                    }
                    else
                    {
                        //failure("Unable to parse response from server")
                        //print("FAILURE")
                        DispatchQueue.main.async()
                        {
                            failure()
                        }
                    }
                }
                catch
                {
                    let string = String.init(data: data, encoding: .utf8)
                    print("ERROR: \(string ?? "Unknown")")
                    DispatchQueue.main.async()
                    {
                        failure()
                    }
                }
            }
        }.resume()
    }
    
    func getContact(onSuccess success: @escaping () -> Void, onFailure failure: @escaping () -> Void)
    {
        if accessToken != nil
        {
            let Url = "\(API())\(CONTACT_PATH)"
            guard let serviceUrl = URL(string: Url) else { return }
            let request = URLRequest(url: serviceUrl)
            
            var mutableRequest = request
            mutableRequest.httpMethod = "GET"
            mutableRequest.setValue("Application/json", forHTTPHeaderField: "Content-Type")
            mutableRequest.setValue("\(AUTH_PREFIX) \(accessToken!)", forHTTPHeaderField: AUTH_KEY)
            mutableRequest.setValue("vessel-ios", forHTTPHeaderField: "User-Agent")
            
            let session = URLSession.shared
            session.dataTask(with: mutableRequest)
            { (data, response, error) in

                if let data = data //unwrap data
                {
                    do
                    {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        if let object = json as? [String: Any]
                        {
                            //print("SUCCESS: \(object)")
                            DispatchQueue.main.async()
                            {
                                success()
                            }
                        }
                        else
                        {
                            //failure("Unable to parse response from server")
                            //print("FAILURE")
                            DispatchQueue.main.async()
                            {
                                failure()
                            }
                        }
                    }
                    catch
                    {
                        let string = String.init(data: data, encoding: .utf8)
                        print("ERROR: \(string ?? "Unknown")")
                        DispatchQueue.main.async()
                        {
                            failure()
                        }
                    }
                }
            }.resume()
        }
    }
}
