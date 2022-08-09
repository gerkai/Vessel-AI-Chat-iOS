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
import Security

let ENDPOINT_ROOT = "v3/"

//Environment Constants
let DEV_API = "https://dev-api.vesselhealth.com/" + ENDPOINT_ROOT
//let DEV_ORDER_CARDS_URL = "https://dev.vesselhealth.com/membership-dev"
let DEV_QUIZ_URL = "https://vesselhealth.com/pages/new-quiz"
let DEV_S3_BUCKET_NAME = "vessel-ips-dev-sample-images"
let DEV_S3_ACCESSS_KEY = "AKIAW42KY3LBQXWJLT6K"
let DEV_S3_SECRET_KEY = "r/h1g6XYMqFz5CkxroXUK0XS9mDV+QZWDzUr5umg"

let STAGING_API = "https://staging-api.vesselhealth.com/" + ENDPOINT_ROOT
//let STAGING_ORDER_CARDS_URL = "https://stage.vesselhealth.com/membership"
let STAGING_QUIZ_URL = "https://vesselhealth.com/pages/new-quiz"
let STAGING_S3_BUCKET_NAME = "vessel-ips-staging-sample-images"
let STAGING_S3_ACCESS_KEY = "AKIAYPGAXRLX7ZBTCRY2"
let STAGING_S3_SECRET_KEY = "cFSKNkJyyAG1Vr/wQdGDWzay8910p2h08Zdt1YxW"

let PROD_API = "https://api.vesselhealth.com/" + ENDPOINT_ROOT
//let PROD_ORDER_CARDS_URL = "https://vesselhealth.com/membership"
let PROD_QUIZ_URL = "https://vesselhealth.com/pages/new-quiz"
let PROD_S3_BUCKET_NAME = "vessel-ips-production-sample-images"
let PROD_S3_ACCESS_KEY = "AKIAYPGAXRLX7ZBTCRY2"
let PROD_S3_SECRET_KEY = "cFSKNkJyyAG1Vr/wQdGDWzay8910p2h08Zdt1YxW"

//Security strings
let AUTH_PREFIX = "Bearer"
let AUTH_KEY = "Authorization"
let ACCESS_TOKEN_KEY = "access_token"
let REFRESH_TOKEN_KEY = "refresh_token"
let KEYCHAIN_ACCOUNT = "vessel"

let SUPPORT_URL = "http://help.vesselhealth.com/"

//Endpoints
let SERVER_FORGOT_PASSWORD_PATH = "auth/forgot-password"
let SERVER_LOGIN_PATH = "auth/login"
let APPLE_LOGIN_PATH = "auth/apple/login"
let APPLE_RETRIEVE_PATH = "auth/apple/retrieve"
let GOOGLE_LOGIN_PATH = "auth/google/login"
let GOOGLE_RETRIEVE_PATH = "auth/google/retrieve"
let REFRESH_TOKEN_PATH = "auth/refresh-token"
let CONTACT_PATH = "contact"
let CONTACT_EXISTS_PATH = "contact/exists"
let SAMPLE_PATH = "sample"
let GET_SCORE_PATH = "sample/{sample_uuid}/super"

struct CardAssociation
{
    var cardBatchID: String?
    var cardCalibrationMode: String?
    var orcaSheetName: String?
}

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
    
    func S3BucketName() -> String
    {
        let index = UserDefaults.standard.integer(forKey: Constants.environmentKey)
        switch index
        {
            case Constants.DEV_INDEX:
                return DEV_S3_BUCKET_NAME
            case Constants.STAGING_INDEX:
                return STAGING_S3_BUCKET_NAME
            default:
                return PROD_S3_BUCKET_NAME
        }
    }
    
    func S3AccessKey() -> String
    {
        let index = UserDefaults.standard.integer(forKey: Constants.environmentKey)
        switch index
        {
            case Constants.DEV_INDEX:
                return DEV_S3_ACCESSS_KEY
            case Constants.STAGING_INDEX:
                return STAGING_S3_ACCESS_KEY
            default:
                return PROD_S3_ACCESS_KEY
        }
    }
    
    func S3SecretKey() -> String
    {
        let index = UserDefaults.standard.integer(forKey: Constants.environmentKey)
        switch index
        {
            case Constants.DEV_INDEX:
                return DEV_S3_SECRET_KEY
            case Constants.STAGING_INDEX:
                return STAGING_S3_SECRET_KEY
            default:
                return PROD_S3_SECRET_KEY
        }
    }
    
    func SupportURL() -> String
    {
        return SUPPORT_URL
    }

    private func serverGet(url: String, onSuccess success: @escaping (_ data: Data) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
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
                self.debugJSONResponse(data: data)
                success(data)
            }
            else
            {
                //print(error)
                failure(error)
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
        mutableRequest.httpMethod = requestType
        mutableRequest.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        if accessToken != nil
        {
            mutableRequest.setValue("\(AUTH_PREFIX) \(accessToken!)", forHTTPHeaderField: AUTH_KEY)
        }
        mutableRequest.setValue("vessel-ios", forHTTPHeaderField: "User-Agent")
        /*if let url = request.url
        {
            print("POST: \(url)")
        }
        print("POST Mutable Request\(mutableRequest)")*/
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
            //let jsonString = String(data: jsonData, encoding: .utf8)!
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
    
    func refreshTokens(onSuccess success: @escaping () -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        guard let url = URL(string: "\(API())\(REFRESH_TOKEN_PATH)") else { return }
        let request = URLRequest(url: url)
        
        var mutableRequest = request
        mutableRequest.httpMethod = "POST"
        mutableRequest.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        mutableRequest.setValue("vessel-ios", forHTTPHeaderField: "User-Agent")
        mutableRequest.setValue("\(AUTH_PREFIX) \(refreshToken!)", forHTTPHeaderField: AUTH_KEY)
        
        //print("\(mutableRequest)")
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
                        if let accessToken = object[ACCESS_TOKEN_KEY] as? String
                        {
                            self.accessToken = accessToken
                            let accessData = Data(accessToken.utf8)
                            KeychainHelper.standard.save(accessData, service: ACCESS_TOKEN_KEY, account: KEYCHAIN_ACCOUNT)
                            success()
                        }
                    }
                }
                catch
                {
                    let string = String.init(data: data, encoding: .utf8)
                    print("ERROR: \(string ?? "Unknown")")
                    failure(error)
                }
            }
            /*if let data = data //unwrap data
            {
               
                let json = try JSONSerialization.jsonObject(with: data, options: [])
//CW: Put a breakpoint here to see json response from server
                if let object = json as? [String: Any]
                {
                    if let accessToken = object[ACCESS_TOKEN_KEY] as? String
                    {
                        
                    }
                }
                print("Need to handle new tokens here")
                self.debugJSONResponse(data: data)
                success(data)
            }
            else
            {
                failure(error)
            }*/
        }.resume()
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
        if accessToken == nil
        {
            //see if we have one stored in the keychain...
            if let data = KeychainHelper.standard.read(service: ACCESS_TOKEN_KEY, account: KEYCHAIN_ACCOUNT)
            {
                accessToken = String(data: data, encoding: .utf8)!
            }
            if let data = KeychainHelper.standard.read(service: REFRESH_TOKEN_KEY, account: KEYCHAIN_ACCOUNT)
            {
                refreshToken = String(data: data, encoding: .utf8)!
            }
        }
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
            if let accessToken = object[ACCESS_TOKEN_KEY] as? String, let refreshToken = object[REFRESH_TOKEN_KEY] as? String
            {
                self.accessToken = accessToken
                self.refreshToken = refreshToken
                //save tokens to keychain
                print("login(): Saving tokens to keychain")
                let accessData = Data(accessToken.utf8)
                KeychainHelper.standard.save(accessData, service: ACCESS_TOKEN_KEY, account: KEYCHAIN_ACCOUNT)
                let refreshData = Data(refreshToken.utf8)
                KeychainHelper.standard.save(refreshData, service: REFRESH_TOKEN_KEY, account: KEYCHAIN_ACCOUNT)

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
    func getTokens(isGoogle: Bool, onSuccess success: @escaping () -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let url = isGoogle ? googleRetrieveURL() : appleRetrieveURL()
        serverGet(url: url)
        { data in
            do
            {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any]
                {
                    if let accessToken = object[ACCESS_TOKEN_KEY] as? String, let refreshToken = object[REFRESH_TOKEN_KEY] as? String
                    {
                        self.accessToken = accessToken
                        self.refreshToken = refreshToken
                        print("getTokens() saving tokens to keychain")
                        let accessData = Data(accessToken.utf8)
                        KeychainHelper.standard.save(accessData, service: ACCESS_TOKEN_KEY, account: KEYCHAIN_ACCOUNT)
                        let refreshData = Data(refreshToken.utf8)
                        KeychainHelper.standard.save(refreshData, service: REFRESH_TOKEN_KEY, account: KEYCHAIN_ACCOUNT)
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
                        let error = NSError.init(domain: "", code: 400, userInfo: ["message": NSLocalizedString("Unable to decode access token", comment: "Server error message")])
                        //let error = Error(domain: "", code: 400, userInfo: nil)
                        failure(error)
                    }
                }
            }
            catch
            {
                DispatchQueue.main.async()
                {
                    let error = NSError.init(domain: "", code: 400, userInfo: ["message": NSLocalizedString("Unable to decode access token", comment: "Server error message")])
                    failure(error)
                }
            }
        }
        onFailure:
        { error in
            DispatchQueue.main.async()
            {
                failure(error)
            }
        }
    }
    
    func logOut()
    {
        print("logout() deleting keychain tokens")
        if accessToken != nil
        {
            //let accessData = Data(accessToken!.utf8)
            KeychainHelper.standard.delete(service: ACCESS_TOKEN_KEY, account: KEYCHAIN_ACCOUNT)
            accessToken = nil
        }
        if refreshToken != nil
        {
            KeychainHelper.standard.delete(service: REFRESH_TOKEN_KEY, account: KEYCHAIN_ACCOUNT)
            refreshToken = nil
        }
    }
    
    func invalidateAccessToken()
    {
        accessToken = "Bogus Token"
        let accessData = Data(accessToken!.utf8)
        KeychainHelper.standard.save(accessData, service: ACCESS_TOKEN_KEY, account: KEYCHAIN_ACCOUNT)
        print("Invalidated access token")
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
    func getContact(id: Int? = nil, onSuccess success: @escaping (_ contact: Contact) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        //print("GET CONTACT...")

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
                 let error = NSError(domain: context.debugDescription, code: -1, userInfo: nil)
                 DispatchQueue.main.async()
                 {
                     failure(error)
                 }
            }
            catch DecodingError.keyNotFound(let key, let context)
            {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
                let error = NSError(domain: context.debugDescription, code: -1, userInfo: nil)
                DispatchQueue.main.async()
                {
                    failure(error)
                }
            }
            catch DecodingError.valueNotFound(let value, let context)
            {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
                let error = NSError(domain: context.debugDescription, code: -1, userInfo: nil)
                DispatchQueue.main.async()
                {
                    failure(error)
                }
            }
            catch DecodingError.typeMismatch(let type, let context)
            {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
                let error = NSError(domain: context.debugDescription, code: -1, userInfo: nil)
                DispatchQueue.main.async()
                {
                    failure(error)
                }
            }
            catch
            {
                print("error: ", error)
                DispatchQueue.main.async()
                {
                    failure(error)
                }
            }
        }
        onFailure:
        { error in
            DispatchQueue.main.async()
            {
                failure(error)
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
                //let jsonString = String(data: jsonData, encoding: .utf8)!
                //print(jsonString)
                
                let Url = String(format: url)
                guard let serviceUrl = URL(string: Url) else { return }
                var request = URLRequest(url: serviceUrl)
                request.httpBody = jsonData
                
                //send it to server
                serverPost(request: request, onSuccess:
                { (object) in
                    if let accessToken = object[ACCESS_TOKEN_KEY] as? String, let refreshToken = object[REFRESH_TOKEN_KEY] as? String
                    {
                        self.accessToken = accessToken
                        self.refreshToken = refreshToken
                        print("createContact() saving tokens to keychain")
                        let accessData = Data(accessToken.utf8)
                        KeychainHelper.standard.save(accessData, service: ACCESS_TOKEN_KEY, account: "vessel")
                        let refreshData = Data(refreshToken.utf8)
                        KeychainHelper.standard.save(refreshData, service: REFRESH_TOKEN_KEY, account: "vessel")

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
        let url = "\(API())\(CONTACT_PATH)"

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try! encoder.encode(contact)
        //let jsonString = String(data: data, encoding: .utf8)!
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
    
    //MARK:  Sample
    func associateTestUUID(parameters: TestUUID, onSuccess success: @escaping (_ object: CardAssociation) -> Void, onFailure failure: @escaping (_ error: String) -> Void)
    {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try! encoder.encode(parameters)
        
        let urlString = "\(API())\(SAMPLE_PATH)"
        
        let url = URL(string: urlString)!
        
        var request = URLRequest(url: url)
        request.httpBody = data
        //send it to server
        serverPost(request: request, onSuccess:
        { (object) in
            //print("SUCCESS: \(object)")
            DispatchQueue.main.async()
            {
                let cardAssociation = CardAssociation(cardBatchID: object["wellness_card_batch_id"] as? String, cardCalibrationMode: object["wellness_card_calibration_mode"] as? String, orcaSheetName: object["orca_sheet_name"] as? String)
                success(cardAssociation)
            }
        },
        onFailure:
        { (string) in
            DispatchQueue.main.async()
            {
                failure(NSLocalizedString("Server Error: \(string)", comment: ""))
            }
        })
    }
    
    func getScore(sampleID: String, onSuccess success: @escaping (_ result: TestResult) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let urlString = "\(API())\(GET_SCORE_PATH)"
        let finalUrlString = urlString.replacingOccurrences(of: "{sample_uuid}", with: sampleID)
        serverGet(url: finalUrlString)
        { data in
            do
            {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                
               // print("JSON: \(json)")
                
                if let testResult = try? JSONDecoder().decode(TestResult.self, from: data)
                {
                    //print ("Test Result: \(testResult)")
                    DispatchQueue.main.async()
                    {
                        success(testResult)
                    }
                }
                else
                if let object = json as? [String: Any]
                {
                    DispatchQueue.main.async()
                    {
                        if let message = object["message"] as? String
                        {
                            if let errorArray = object["errors"] as? [[String: Any]]
                            {
                                if let firstErrorArray = errorArray.first
                                {
                                    //print("First Error Array: \(firstErrorArray)")
                                    let code = firstErrorArray["code"] as? Int
                                    let label = firstErrorArray["label"] as? String
                                    let error = NSError.init(domain: "", code: code ?? 0, userInfo: ["message": label ?? "unknonwn"])
                                    failure(error)
                                }
                            }
                            else
                            {
                                let error = NSError.init(domain: "", code: 404, userInfo: ["message": message])
                                failure(error)
                            }
                        }
                        else
                        {
                            let error = NSError.init(domain: "", code: 400, userInfo: ["message": NSLocalizedString("Unable to decode score response", comment: "Server error message")])
                            failure(error)
                        }
                    }
                }
                else
                {
                    DispatchQueue.main.async()
                    {
                        let error = NSError.init(domain: "", code: 400, userInfo: ["message": NSLocalizedString("Unable to decode score response", comment: "Server error message")])
                        failure(error)
                    }
                }
            }
            catch
            {
                DispatchQueue.main.async()
                {
                    let error = NSError.init(domain: "", code: 400, userInfo: ["message": NSLocalizedString("Unable to get score response", comment: "Server error message")])
                    failure(error)
                }
            }
        }
        onFailure:
        { error in
            DispatchQueue.main.async()
            {
                failure(error)
            }
        }
    }
}

