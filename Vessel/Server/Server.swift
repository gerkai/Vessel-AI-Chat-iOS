//
//  Server.swift
//  Vessel
//
//  Created by Carson Whitsett on 2/26/22.
//

import Foundation

let DEV_API = "https://dev-api.vesselhealth.com/v2/"
let STAGING_API = "https://staging-api.vesselhealth.com/v2/"
let PROD_API = "https://api.vesselhealth.com/v2/"

let SERVER_FORGOT_PASSWORD_PATH =       "auth/forgot-password"
let SERVER_LOGIN_PATH =                 "auth/login"

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
    
    //MARK: - Public functions
    
    func forgotPassword(email: String, onSuccess success: @escaping (_ message: String) -> Void, onFailure failure: @escaping (_ object: [String : Any]) -> Void)
    {
        var dictPostBody = [String : String]()
        dictPostBody["email"] = email
        do
        {
            let jsonData = try JSONSerialization.data(withJSONObject: dictPostBody, options: .prettyPrinted)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            print(jsonString)

            let Url = String(format:"\(API())\(SERVER_FORGOT_PASSWORD_PATH)")
            guard let serviceUrl = URL(string: Url) else { return }
            var request = URLRequest(url: serviceUrl)
            request.httpBody = jsonData
            
            serverPost(request: request, onSuccess:
            { (object) in
                DispatchQueue.main.async()
                {
                    if let message = object["message"] as? String
                    {
                        success(message)
                    }
                    else
                    {
                        success("")
                    }
                }
            },
            onFailure:
            { (string) in
                DispatchQueue.main.async()
                {
                    failure(["Failure" : NSLocalizedString("Server Error", comment:"")])
                }
            })
        }
        catch
        {
            print(error.localizedDescription)
        }
    }
    
    func login(email: String, password: String, onSuccess success: @escaping () -> Void, onFailure failure: @escaping (_ object: [String : Any]) -> Void)
    {
        var dictPostBody = [String : String]()
        dictPostBody["email"] = email
        dictPostBody["password"] = password 
        do
        {
            let jsonData = try JSONSerialization.data(withJSONObject: dictPostBody, options: .prettyPrinted)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            print(jsonString)

            let Url = String(format:"\(API())\(SERVER_LOGIN_PATH)")
            guard let serviceUrl = URL(string: Url) else { return }
            var request = URLRequest(url: serviceUrl)
            request.httpBody = jsonData
            
            serverPost(request: request, onSuccess:
            { (object) in
                DispatchQueue.main.async()
                {
                    if let accessToken = object["access_token"] as? String, let refreshToken = object["refresh_token"] as? String
                    {
                        self.accessToken = accessToken
                        self.refreshToken = refreshToken
                        success()
                    }
                    else
                    {
                        failure(["message": NSLocalizedString("Bad username or password", comment:"")])
                    }
                    
                }
            },
            onFailure:
            { (string) in
                DispatchQueue.main.async()
                {
                    print("FAILURE: \(string)")
                    failure(["Failure" : NSLocalizedString("Server Error", comment:"")])
                }
            })
        }
        catch
        {
            print(error.localizedDescription)
        }
    }
}
