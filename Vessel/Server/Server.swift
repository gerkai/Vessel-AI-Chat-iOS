//
//  Server.swift
//  Vessel
//
//  Created by Carson Whitsett on 2/26/22.
//
//  All back end communication goes through here.
//  All callbacks are dispatched on MainQueue

import Foundation
import Security

//set this to a valid contact ID to login as that contact ID
let contact_id_override = 0

// MARK: - PATHS
let ENDPOINT_ROOT = "v3/"

//Environment Constants
let DEV_API = "https://dev-api.vesselhealth.com/" + ENDPOINT_ROOT
//let DEV_ORDER_CARDS_URL = "https://dev.vesselhealth.com/membership-dev"
let DEV_QUIZ_URL = "https://vesselhealth.com/pages/new-quiz"
let DEV_S3_BUCKET_NAME = "vessel-ips-dev-sample-images"
let DEV_S3_ACCESSS_KEY = "AKIAW42KY3LBQXWJLT6K"
let DEV_S3_SECRET_KEY = "r/h1g6XYMqFz5CkxroXUK0XS9mDV+QZWDzUr5umg"
let DEV_FUEL_QUIZ_PATH = "pages/fuel-landing?preview_theme_id=131922690234"
let DEV_FUEL_FORMULATION_PATH = "pages/fuel-formulation?preview_theme_id=132393566394"

let STAGING_API = "https://staging-api.vesselhealth.com/" + ENDPOINT_ROOT
//let STAGING_ORDER_CARDS_URL = "https://stage.vesselhealth.com/membership"
let STAGING_QUIZ_URL = "https://vesselhealth.com/pages/new-quiz"
let STAGING_S3_BUCKET_NAME = "vessel-ips-staging-sample-images"
let STAGING_S3_ACCESS_KEY = "AKIAYPGAXRLX7ZBTCRY2"
let STAGING_S3_SECRET_KEY = "cFSKNkJyyAG1Vr/wQdGDWzay8910p2h08Zdt1YxW"
let STAGING_FUEL_QUIZ_PATH = "pages/fuel-landing?preview_theme_id=131922690234"
let STAGING_FUEL_FORMULATION_PATH = "pages/fuel-formulation/?preview_theme_id=132445077690"

let PROD_API = "https://api.vesselhealth.com/" + ENDPOINT_ROOT
//let PROD_ORDER_CARDS_URL = "https://vesselhealth.com/membership"
let PROD_QUIZ_URL = "https://vesselhealth.com/pages/new-quiz"
let PROD_S3_BUCKET_NAME = "vessel-ips-production-sample-images"
let PROD_S3_ACCESS_KEY = "AKIAYPGAXRLX7ZBTCRY2"
let PROD_S3_SECRET_KEY = "cFSKNkJyyAG1Vr/wQdGDWzay8910p2h08Zdt1YxW"
let PROD_FUEL_QUIZ_PATH = "pages/fuel-landing"
let PROD_FUEL_FORMULATION_PATH = "pages/fuel-formulation"

//Security strings
let AUTH_PREFIX = "Bearer"
let AUTH_KEY = "Authorization"
let ACCESS_TOKEN_KEY = "access_token"
let REFRESH_TOKEN_KEY = "refresh_token"
let CONTACT_ID_KEY = "contact_id"
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
let MULTIPASS_PATH = "auth/multipass"
let CONTACT_PATH = "contact"
let CONTACT_CREATE_PATH = "contact/create"
let CONTACT_EXISTS_PATH = "contact/exists"
let DELETE_ACCOUNT_PATH = "contact"
let CHANGE_PASSWORD_PATH = "contact/change-password"
let SAMPLE_PATH = "sample"
let GET_SCORE_PATH = "sample/{sample_uuid}/super"
let OBJECT_SAVE_PATH = "objects/save"
let OBJECT_GET_PATH = "objects/get"
let OBJECT_ALL_PATH = "objects/all"
let REAGENT_FOOD_RECOMMENDATIONS_PATH = "recommendations/food/reagent"
let GET_PLANS_PATH = "plan"
let ADD_NEW_SINGLE_PLAN_PATH = "plan"
let REMOVE_SINGLE_PLAN_PATH = "plan/{plan_id}"
let ADD_NEW_MULTIPLE_PLAN_PATH = "plan/build"
let TOGGLE_PLAN_PATH = "plan/{plan_id}/toggle"
let GET_LESSON_PATH = "lesson/{lesson_id}"
let GET_LESSON_QUESTION_PATH = "lesson-question-response/{lesson_question_response_id}"
let USER_HAS_FUEL_PATH = "fuel"
let LIFESTYLE_RECOMMENDATION_PATH = "lifestyle-recommendation"
let GET_EXPERT_PATH = "fuel/expert"
let GET_ALL_EXPERTS_PATH = "experts"

// MARK: - Structs
struct CardAssociation
{
    var cardBatchID: String?
    var cardCalibrationMode: String?
    var orcaSheetName: String?
}

struct ServerError
{
    var code: Int
    var description: String
    var moreInfo: String?
}

// MARK: - Server Class
class Server: NSObject
{
    @Resolved private var analytics: Analytics
    static let shared = Server()
    //TODO: Move access and refresh tokens to secure storage
    var accessToken: String?
    var refreshToken: String?
    
    // MARK: - URLs and Keys
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
    
    func FuelQuizURL() -> String
    {
        let index = UserDefaults.standard.integer(forKey: Constants.environmentKey)
        switch index
        {
            case Constants.DEV_INDEX:
                return DEV_FUEL_QUIZ_PATH
            case Constants.STAGING_INDEX:
                return STAGING_FUEL_QUIZ_PATH
            default:
                return PROD_FUEL_QUIZ_PATH
        }
    }
    
    func FuelFormulationURL() -> String
    {
        let index = UserDefaults.standard.integer(forKey: Constants.environmentKey)
        switch index
        {
            case Constants.DEV_INDEX:
                return DEV_FUEL_FORMULATION_PATH
            case Constants.STAGING_INDEX:
                return STAGING_FUEL_FORMULATION_PATH
            default:
                return PROD_FUEL_FORMULATION_PATH
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
    
    //MARK: - Authentication
    func isLoggedIn() -> Bool
    {
        //if we have a stored access token, then we're assumed to be logged in
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
            if let stringID = KeychainHelper.standard.read(service: CONTACT_ID_KEY, account: KEYCHAIN_ACCOUNT, type: String.self)
            {
                if let id = Int(stringID)
                {
                    Contact.MainID = id
                }
                else
                {
                    print("Couldn't convert main ID: \(stringID)")
                }
            }
        }
        return (accessToken != nil) && (Contact.MainID != 0)
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
        var dictPostBody = [String: Any]()
        dictPostBody["email"] = email
        dictPostBody["password"] = password
        if contact_id_override != 0
        {
            dictPostBody["contact_id_override"] = contact_id_override
        }
        
        postToServer(dictBody: dictPostBody, url: "\(API())\(SERVER_LOGIN_PATH)")
        { object in
            if let accessToken = object[ACCESS_TOKEN_KEY] as? String,
                let refreshToken = object[REFRESH_TOKEN_KEY] as? String
                
            {
                if let mainContactID = object[CONTACT_ID_KEY] as? Int
                {
                    Contact.MainID = mainContactID
                }
                else
                {
                    Contact.MainID = dictPostBody["contact_id_override"] as! Int
                }
                
                self.accessToken = accessToken
                self.refreshToken = refreshToken
                //save tokens to keychain
                let accessData = Data(accessToken.utf8)
                KeychainHelper.standard.save(accessData, service: ACCESS_TOKEN_KEY, account: KEYCHAIN_ACCOUNT)
                let refreshData = Data(refreshToken.utf8)
                KeychainHelper.standard.save(refreshData, service: REFRESH_TOKEN_KEY, account: KEYCHAIN_ACCOUNT)
                let string = "\(Contact.MainID)"
                KeychainHelper.standard.save(string, service: CONTACT_ID_KEY, account: KEYCHAIN_ACCOUNT)
                
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
    
    //call this after successful Google / Apple SSO sign-in. This will establish access and refresh tokens
    func getTokens(isGoogle: Bool, onSuccess success: @escaping () -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let url = isGoogle ? googleRetrieveURL() : appleRetrieveURL()
        let request = Server.shared.GenerateRequest(urlString: url)!
        serverGet(request: request)
        { data in
            do
            {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any]
                {
                    if let accessToken = object[ACCESS_TOKEN_KEY] as? String,
                        let refreshToken = object[REFRESH_TOKEN_KEY] as? String,
                       let mainContactID = object[CONTACT_ID_KEY] as? Int
                    {
                        Contact.MainID = mainContactID
                        
                        self.accessToken = accessToken
                        self.refreshToken = refreshToken
                        
                        let accessData = Data(accessToken.utf8)
                        KeychainHelper.standard.save(accessData, service: ACCESS_TOKEN_KEY, account: KEYCHAIN_ACCOUNT)
                        let refreshData = Data(refreshToken.utf8)
                        KeychainHelper.standard.save(refreshData, service: REFRESH_TOKEN_KEY, account: KEYCHAIN_ACCOUNT)
                        let string = "\(mainContactID)"
                        KeychainHelper.standard.save(string, service: CONTACT_ID_KEY, account: KEYCHAIN_ACCOUNT)
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
    
    /* send the refresh token, get back a new access and refresh token */
    func refreshTokens(onSuccess success: @escaping () -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        guard let url = URL(string: "\(API())\(REFRESH_TOKEN_PATH)") else { return }
        let request = URLRequest(url: url)
        
        var mutableRequest = request
        mutableRequest.httpMethod = "POST"
        mutableRequest.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        mutableRequest.setValue("vessel-ios", forHTTPHeaderField: "User-Agent")
        mutableRequest.setValue("\(AUTH_PREFIX) \(refreshToken!)", forHTTPHeaderField: AUTH_KEY)
        
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
    
    func invalidateAccessToken()
    {
        accessToken = "Bogus Token"
        let accessData = Data(accessToken!.utf8)
        KeychainHelper.standard.save(accessData, service: ACCESS_TOKEN_KEY, account: KEYCHAIN_ACCOUNT)
        print("Invalidated access token")
    }
    
    func logOut()
    {
        analytics.log(event: .logOut)
        ObjectStore.shared.clearCache()
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
        
        Contact.reset()
        PlansManager.shared.plans = []
        LessonsManager.shared.clearLessons()
    }
    
    func changePassword(oldPassword: String, newPassword: String, onSuccess success: @escaping () -> Void, onFailure failure: @escaping (_ error: String) -> Void)
    {
        let url = "\(API())\(CHANGE_PASSWORD_PATH)"

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let params = [
            "current_password": oldPassword,
            "new_password": newPassword
        ]
        let data = try! encoder.encode(params)
        
        let Url = String(format: url)
        guard let serviceUrl = URL(string: Url) else { return }
        var request = URLRequest(url: serviceUrl)
        request.httpBody = data
        
        //send it to server
        serverPost(request: request, onSuccess:
        { (object) in
            if let message = ((object["schema_errors"] as? [String: Any])?["new_password"] as? [String])?[safe: 0]
            {
                DispatchQueue.main.async()
                    {
                        failure(message)
                    }
            }
            if let message = ((object["schema_errors"] as? [String: Any])?["current_password"] as? [String])?[safe: 0]
            {
                DispatchQueue.main.async()
                    {
                        failure(message)
                    }
            }
            guard let message = object["message"] as? String else { return }
            if message == "Updated."
            {
                DispatchQueue.main.async()
                {
                    success()
                }
            }
            else
            {   DispatchQueue.main.async()
                {
                    failure(message)
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
    
    func multipassURL(path: String, onSuccess success: @escaping (_ url: String) -> Void, onFailure failure: @escaping (_ string: String) -> Void)
    {
        var dictPostBody = [String: String]()
        var scaRef = ""
        if let urlCode = Contact.FuelInfo?.url_code
        {
            scaRef = "&" + urlCode
        }
        dictPostBody["path"] = path + "?token=\(accessToken!)" + scaRef
        
        postToServer(dictBody: dictPostBody, url: "\(API())\(MULTIPASS_PATH)")
        { object in
            if let multipass_url = object["multipass_url"] as? String
            {
                success(multipass_url)
            }
            else
            {
                failure("\(object)")
            }
        }
        onFailure:
        { message in
            print("Multipass server error: \(message)")
            failure(message)
        }
    }
    
    //MARK: Contact
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
    
    func createContact(contact: Contact, password: String, onSuccess success: @escaping () -> Void, onFailure failure: @escaping (_ error: String) -> Void)
    {
        let url = "\(API())\(CONTACT_CREATE_PATH)"
        
        if var contactDict = contact.dictionary
        {
            contactDict.removeValue(forKey: "id")
            contactDict["password"] = password
            do
            {
                let jsonData = try JSONSerialization.data(withJSONObject: contactDict, options: .prettyPrinted)
                
                let Url = String(format: url)
                guard let serviceUrl = URL(string: Url) else { return }
                var request = URLRequest(url: serviceUrl)
                request.httpBody = jsonData
                
                //send it to server
                serverPost(request: request, onSuccess:
                { (object) in
                    if let accessToken = object[ACCESS_TOKEN_KEY] as? String,
                        let refreshToken = object[REFRESH_TOKEN_KEY] as? String,
                       let mainContactID = object[CONTACT_ID_KEY] as? Int
                    {
                        self.accessToken = accessToken
                        self.refreshToken = refreshToken
                        Contact.MainID = mainContactID

                        let accessData = Data(accessToken.utf8)
                        KeychainHelper.standard.save(accessData, service: ACCESS_TOKEN_KEY, account: "vessel")
                        let refreshData = Data(refreshToken.utf8)
                        KeychainHelper.standard.save(refreshData, service: REFRESH_TOKEN_KEY, account: "vessel")
                        let string = "\(mainContactID)"
                        KeychainHelper.standard.save(string, service: CONTACT_ID_KEY, account: KEYCHAIN_ACCOUNT)

                        DispatchQueue.main.async()
                        {
                            success()
                        }
                    }
                    else
                    {
                        DispatchQueue.main.async()
                        {
                            failure(NSLocalizedString(object["message"] as? String ?? "Error creating new user", comment: ""))
                        }
                    }
                },
                onFailure:
                { (serverError) in
                    DispatchQueue.main.async()
                    {
                        failure(serverError.description)
                    }
                })
            }
            catch
            {
                DispatchQueue.main.async()
                {
                    failure(error.localizedDescription)
                }
            }
        }
    }
    
    func deleteAccount(onSuccess success: @escaping () -> Void, onFailure failure: @escaping (_ error: String) -> Void)
    {
        let url = "\(API())\(DELETE_ACCOUNT_PATH)"
        
        let Url = String(format: url)
        guard let serviceUrl = URL(string: Url) else { return }
        let request = URLRequest(url: serviceUrl)
        
        //send it to server
        serverDelete(request: request, onSuccess:
        {
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
    
    //MARK: Foods
    func getAllFoods(lastUpdated: Int, onSuccess success: @escaping ([Food]) -> Void, onFailure failure: @escaping (_ error: String) -> Void)
    {
        getAllObjects(objects: [AllObjectReq(type: "food", last_updated: lastUpdated)])
        { dict in
            do
            {
                guard let foodDict = dict["food"] as? [[String: Any]] else { return }
                let json = try JSONSerialization.data(withJSONObject: foodDict)
                let decoder = JSONDecoder()
                let decodedFoods = try decoder.decode([Food].self, from: json)
                DispatchQueue.main.async()
                {
                    success(decodedFoods)
                }
            }
            catch
            {
                DispatchQueue.main.async()
                {
                    let error = NSError.init(domain: "", code: 400, userInfo: ["message": NSLocalizedString("Unable to get all foods response", comment: "Server error message")])
                    failure(error.localizedDescription)
                }
            }
        } onFailure: { error in
            failure(error)
        }
    }
    
    func getFoodsForReagent(reagentId: Int, onSuccess success: @escaping ([ReagentFood]) -> Void, onFailure failure: @escaping (_ error: String) -> Void)
    {
        let urlString = "\(API())\(REAGENT_FOOD_RECOMMENDATIONS_PATH)"
        guard let request = Server.shared.GenerateRequest(urlString: urlString, withParams: ["reagent_id": "\(reagentId)"]) else
        {
            let error = NSError.init(domain: "", code: 400, userInfo: ["message": NSLocalizedString("Unable to get reagent foods response", comment: "Server error message")])
            failure(error.localizedDescription)
            return
        }
        
        serverGet(request: request) { data in
            do
            {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                if let foodResult = try? decoder.decode(ReagentFoodResponse.self, from: data)
                {
                    DispatchQueue.main.async()
                    {
                        success(foodResult.foodResponse)
                    }
                }
                else if let object = json as? [String: Any]
                {
                    DispatchQueue.main.async()
                    {
                        if let message = object["message"] as? String
                        {
                            if let errorArray = object["errors"] as? [[String: Any]]
                            {
                                if let firstErrorArray = errorArray.first
                                {
                                    let code = firstErrorArray["code"] as? Int
                                    let label = firstErrorArray["label"] as? String
                                    let error = NSError.init(domain: "", code: code ?? 0, userInfo: ["message": label ?? "unknonwn"])
                                    failure(error.localizedDescription)
                                }
                            }
                            else
                            {
                                let error = NSError.init(domain: "", code: 404, userInfo: ["message": message])
                                failure(error.localizedDescription)
                            }
                        }
                        else
                        {
                            let error = NSError.init(domain: "", code: 400, userInfo: ["message": NSLocalizedString("Unable to decode reagent foods response", comment: "Server error message")])
                            failure(error.localizedDescription)
                        }
                    }
                }
                else
                {
                    DispatchQueue.main.async()
                    {
                        let error = NSError.init(domain: "", code: 400, userInfo: ["message": NSLocalizedString("Unable to decode reagent foods response", comment: "Server error message")])
                        failure(error.localizedDescription)
                    }
                }
            }
            catch
            {
                DispatchQueue.main.async()
                {
                    let error = NSError.init(domain: "", code: 400, userInfo: ["message": NSLocalizedString("Unable to get reagent foods response", comment: "Server error message")])
                    failure(error.localizedDescription)
                }
            }
        } onFailure: { error in
            failure(error?.localizedDescription ?? "")
        }
    }
    
    func saveObjects<Value>(objects: [String: Value], onSuccess success: @escaping () -> Void, onFailure failure: @escaping (_ error: String) -> Void) where Value: Encodable
    {
        let url = "\(API())\(OBJECT_SAVE_PATH)"

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try! encoder.encode(objects)
        
        let Url = String(format: url)
        guard let serviceUrl = URL(string: Url) else { return }
        var request = URLRequest(url: serviceUrl)
        request.httpBody = data
        
        //send it to server
        serverPost(request: request, onSuccess:
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
    
    // MARK: Plan
    func getPlans(lastUpdated: Int, onSuccess success: @escaping ([Plan]) -> Void, onFailure failure: @escaping (_ error: ServerError) -> Void)
    {
        getAllObjects(objects: [AllObjectReq(type: "plan", last_updated: lastUpdated)])
        { dict in
            do
            {
                guard let planDict = dict["plan"] as? [[String: Any]] else { return }
                let json = try JSONSerialization.data(withJSONObject: planDict)
                let decoder = JSONDecoder()
                let decodedServerPlans = try decoder.decode([ServerPlan].self, from: json) //change to Plan once back end is updated
                DispatchQueue.main.async()
                {
                    let decodedPlans = ServerPlan.convert(serverPlans: decodedServerPlans) //delete this line once back end is updated
                    success(decodedPlans)
                }
            }
            catch
            {
                DispatchQueue.main.async()
                {
                    let error = ServerError(code: 400, description: NSLocalizedString("Unable to get all plans response", comment: ""))
                    failure(error)
                }
            }
        } onFailure: { error in
            let serverError = ServerError(code: 400, description: error)
            failure(serverError)
        }
    }
    
    func addSinglePlan(plan: Plan, onSuccess success: @escaping (_ plan: Plan) -> Void, onFailure failure: @escaping (_ error: ServerError) -> Void)
    {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let data = try! encoder.encode(ServerPlan.convert(plan: plan))
        
        let urlString = "\(API())\(ADD_NEW_SINGLE_PLAN_PATH)"
        
        guard let url = URL(string: urlString) else
        {
            let error = ServerError(code: 400, description: NSLocalizedString("Unable to add new plan to contact", comment: "Server error message"))
            failure(error)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpBody = data
        //send it to server
        serverPost(request: request, onSuccess:
        { (planDict) in
            do
            {
                let json = try JSONSerialization.data(withJSONObject: planDict)
                let decoder = JSONDecoder()
                let decodedPlan = try decoder.decode(ServerPlan.self, from: json)
                DispatchQueue.main.async()
                {
                    success(ServerPlan.convert(serverPlan: decodedPlan))
                }
            }
            catch
            {
                DispatchQueue.main.async()
                {
                    let error = ServerError(code: 400, description: NSLocalizedString("Unable to decode plans response", comment: "Server error message"))
                    failure(error)
                }
            }
        },
        onFailure:
        { (error) in
            DispatchQueue.main.async()
            {
                failure(error)
            }
        })
    }
    
    func removeSinglePlan(planId: Int, onSuccess success: @escaping () -> Void, onFailure failure: @escaping (_ error: ServerError) -> Void)
    {
//        let encoder = JSONEncoder()
//        encoder.outputFormatting = .prettyPrinted
//        encoder.keyEncodingStrategy = .convertToSnakeCase
//        let data = try! encoder.encode(plan.id)
        
        let urlString = "\(API())\(REMOVE_SINGLE_PLAN_PATH)"
        let finalUrlString = urlString.replacingOccurrences(of: "{plan_id}", with: "\(planId)")
        
        guard let url = URL(string: finalUrlString) else
        {
            let error = ServerError(code: 400, description: NSLocalizedString("Unable to remove plan from contact", comment: "Server error message"))
            failure(error)
            return
        }
        
        let request = URLRequest(url: url)
//        request.httpBody = data
        //send it to server
        serverDelete(request: request)
        {
            print("SUCCESS")
            DispatchQueue.main.async()
            {
                success()
            }
        } onFailure: { string in
            print("ERROR: \(string)")
            DispatchQueue.main.async()
            {
                failure(string)
            }
        }
    }
    
    func addMultiplePlans(plans: MultiplePlans, onSuccess success: @escaping (_ plans: [Plan]) -> Void, onFailure failure: @escaping (_ error: ServerError) -> Void)
    {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let data = try! encoder.encode(plans)
        
        let urlString = "\(API())\(ADD_NEW_MULTIPLE_PLAN_PATH)"
        
        guard let url = URL(string: urlString) else
        {
            let error = ServerError(code: 400, description: NSLocalizedString("Unable to add new plan to contact", comment: "Server error message"))
            failure(error)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpBody = data
        //send it to server
        serverPost(request: request, onSuccess:
        { (plansDict) in
            do
            {
                let json = try JSONSerialization.data(withJSONObject: plansDict)
                let decoder = JSONDecoder()
                let multiplePlansResponse = try decoder.decode(PlanResponse.self, from: json)
                
                DispatchQueue.main.async()
                {
                    success(ServerPlan.convert(serverPlans: multiplePlansResponse.plans))
                }
            }
            catch
            {
                DispatchQueue.main.async()
                {
                    let error = ServerError(code: 400, description: NSLocalizedString("Unable to decode multiple plans response", comment: "Server error message"))
                    failure(error)
                }
            }
        },
        onFailure:
        { (error) in
            DispatchQueue.main.async()
            {
                failure(error)
            }
        })
    }
    
    func completePlan(planId: Int, toggleData: TogglePlanData, onSuccess success: @escaping (_ togglePlanData: TogglePlanData) -> Void, onFailure failure: @escaping (_ error: ServerError) -> Void)
    {
        let urlString = "\(API())\(TOGGLE_PLAN_PATH)"
        let finalUrlString = urlString.replacingOccurrences(of: "{plan_id}", with: "\(planId)")

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let data = try! encoder.encode(toggleData)
        let Url = String(format: finalUrlString)
        
        guard let serviceUrl = URL(string: Url) else { return }
        var request = URLRequest(url: serviceUrl)
        request.httpBody = data
        
        serverPost(request: request, onSuccess:
        { (object) in
            do
            {
                let json = try JSONSerialization.data(withJSONObject: object)
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let togglePlanData = try decoder.decode(TogglePlanData.self, from: json)
                
                DispatchQueue.main.async()
                {
                    success(togglePlanData)
                }
            }
            catch
            {
                DispatchQueue.main.async()
                {
                    let error = ServerError(code: 400, description: NSLocalizedString("Unable to decode multiple plans response", comment: "Server error message"))
                    failure(error)
                }
            }
        },
        onFailure:
        { (error) in
            DispatchQueue.main.async()
            {
                failure(error)
            }
        })
    }
    
    //MARK:  Sample
    func associateTestUUID(parameters: TestUUID, onSuccess success: @escaping (_ object: CardAssociation) -> Void, onFailure failure: @escaping (_ error: ServerError) -> Void)
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
            DispatchQueue.main.async()
            {
                let cardAssociation = CardAssociation(cardBatchID: object["wellness_card_batch_id"] as? String, cardCalibrationMode: object["wellness_card_calibration_mode"] as? String, orcaSheetName: object["orca_sheet_name"] as? String)
                success(cardAssociation)
            }
        },
        onFailure:
        { (error) in
            DispatchQueue.main.async()
            {
                failure(error)
            }
        })
    }
    
    func getScore(sampleID: String, onSuccess success: @escaping (_ result: Result) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let urlString = "\(API())\(GET_SCORE_PATH)"
        let finalUrlString = urlString.replacingOccurrences(of: "{sample_uuid}", with: sampleID)
        let request = Server.shared.GenerateRequest(urlString: finalUrlString)!
        serverGet(request: request)
        { data in
            do
            {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                
                if let testResult = try? JSONDecoder().decode(Result.self, from: data)
                {
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
    
    //MARK:  Fuel
    func getFuel(onSuccess success: @escaping (_ fuelObject: Fuel) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let urlString = "\(API())\(USER_HAS_FUEL_PATH)"
        let request = Server.shared.GenerateRequest(urlString: urlString)!
        
        serverGet(request: request)
        { data in
            do
            {
                let decoder = JSONDecoder()
                let decodedFuel = try decoder.decode(Fuel.self, from: data)
                //print("Decoded Fuel: \(decodedFuel)")
                success(decodedFuel)
            }
            catch
            {
                Log_Add("get fuel error: \(error)")
                DispatchQueue.main.async()
                {
                    failure(self.fuelError())
                }
            }
        }
        onFailure:
        { error in
            DispatchQueue.main.async()
            {
                //print("get fuel error2: \(String(describing: error))")
                failure(error)
            }
        }
    }
    
    func fuelError() -> NSError
    {
        let error = NSError.init(domain: "", code: 1000, userInfo: ["message": NSLocalizedString("Unable to get fuel", comment: "Server error message")])
        return error
    }
    
    // MARK: - Expert
    func getExpert(id: Int, onSuccess success: @escaping (_ expert: Expert) -> Void, onFailure failure: @escaping (_ message: String?) -> Void)
    {
        var dictPostBody = [String: Int]()
        dictPostBody["expert_id"] = id
        
        postToServer(dictBody: dictPostBody, url: "\(API())\(GET_EXPERT_PATH)")
        { object in
            do
            {
                let json = try JSONSerialization.data(withJSONObject: object)
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let expert = try decoder.decode(Expert.self, from: json)
                
                DispatchQueue.main.async()
                {
                    success(expert)
                }
            }
            catch
            {
                print(error)
                DispatchQueue.main.async()
                {
                    //let error = ServerError(code: 400, description: NSLocalizedString("Unable to decode multiple plans response", comment: "Server error message"))
                    failure(error.localizedDescription)
                }
            }
        }
        onFailure:
        { message in
            print("Got server failure: \(message)")
            failure(message)
        }
    }
    
    func getAllExperts(onSuccess success: @escaping (_ experts: [Expert]) -> Void, onFailure failure: @escaping (_ message: String?) -> Void)
    {
        var objectDict: [String: [String: Int]] = [:]
        var experts: [Expert] = []

        //last_updated of 0 will fetch all experts in database
        objectDict["expert"] = ["last_updated": 0]
        
        let url = "\(API())\(GET_ALL_EXPERTS_PATH)"
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try! encoder.encode(objectDict)
        let Url = String(format: url)
        guard let serviceUrl = URL(string: Url) else { return }
        var request = URLRequest(url: serviceUrl)
        request.httpBody = data
        
        //send it to server
        serverPost(request: request, onSuccess:
        { (data) in
            if let objects = data["expert"]
            {
                for singleObjectDict in objects as! [[String: Any]]
                {
                    do
                    {
                        let json = try JSONSerialization.data(withJSONObject: singleObjectDict)
                        let decoder = JSONDecoder()
                        
                        let object = try decoder.decode(Expert.self, from: json)
                        experts.append(object)
                    }
                    catch
                    {
                        print(error)
                    }
                }
            }
            
            DispatchQueue.main.async()
            {
                success(experts)
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
    
    // MARK: - Lifestyle Recommendation
    //Tech Debt: THIS IS TEMPORARY CODE. STOP USING THIS ONCE WE CAN LOAD LIFESTYLE RECOMMENDATIONS USING OBJECT STORE
    //Consider baking in the lifestyle recommendations
    func getLifestyleRecommendation(id: Int, onSuccess success: @escaping (_ result: LifestyleRecommendation) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let urlString = API() + "lifestyle-recommendation/\(id)"
        let modifiedURLString = urlString.replacingOccurrences(of: "v3", with: "v2")
        let request = Server.shared.GenerateRequest(urlString: modifiedURLString)!
        
        serverGet(request: request)
        { data in
            do
            {
                let decoder = JSONDecoder()

                let object = try decoder.decode(LifestyleRecommendation.self, from: data)
                
                DispatchQueue.main.async()
                {
                    success(object)
                }
            }
            catch
            {
                print("ERROR: \(error)")
                DispatchQueue.main.async()
                {
                    failure(self.fuelError())
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
    
    // MARK: - Utils
    func allowDebugPrint() -> Bool
    {
        return UserDefaults.standard.bool(forKey: Constants.KEY_PRINT_NETWORK_TRAFFIC)
    }
    
    func GenerateRequest(urlString: String) -> URLRequest?
    {
        guard let serviceUrl = URL(string: urlString) else { return nil }
        return URLRequest(url: serviceUrl)
    }
    
    func GenerateRequest(urlString: String, withParams params: [String: String]) -> URLRequest?
    {
        guard var components = URLComponents(string: urlString) else { return nil }
        components.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        guard let url = components.url else { return nil }
        return URLRequest(url: url)
    }
    
    private func serverGet(request: URLRequest, onSuccess success: @escaping (_ data: Data) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        var mutableRequest = request
        let allowPrint = allowDebugPrint()
        mutableRequest.httpMethod = "GET"
        mutableRequest.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        if accessToken != nil
        {
            mutableRequest.setValue("\(AUTH_PREFIX) \(accessToken!)", forHTTPHeaderField: AUTH_KEY)
        }
        mutableRequest.setValue("vessel-ios", forHTTPHeaderField: "User-Agent")
        
        if allowPrint
        {
            if let url = request.url
            {
                print("GET: \(url)")
            }
        }
        
        let session = URLSession.shared
        session.dataTask(with: mutableRequest)
        { (data, response, error) in
            if let data = data //unwrap data
            {
                if allowPrint
                {
                    self.debugJSONResponse(data: data)
                }
                success(data)
            }
            else
            {
                failure(error)
            }
        }.resume()
    }
    
    private func serverPost(request: URLRequest, onSuccess success: @escaping (_ json: [String: Any]) -> Void, onFailure failure: @escaping (_ error: ServerError) -> Void)
    {
        serverWrite(request: request, requestType: "POST", onSuccess: success, onFailure: failure)
    }
    
    private func serverPut(request: URLRequest, onSuccess success: @escaping (_ json: [String: Any]) -> Void, onFailure failure: @escaping (_ error: ServerError) -> Void)
    {
        serverWrite(request: request, requestType: "PUT", onSuccess: success, onFailure: failure)
    }
    
    private func serverDelete(request: URLRequest, onSuccess success: @escaping () -> Void, onFailure failure: @escaping (_ string: ServerError) -> Void)
    {
        var mutableRequest = request
        let allowPrint = allowDebugPrint()
        mutableRequest.httpMethod = "DELETE"
        mutableRequest.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        if accessToken != nil
        {
            mutableRequest.setValue("\(AUTH_PREFIX) \(accessToken!)", forHTTPHeaderField: AUTH_KEY)
        }
        mutableRequest.setValue("vessel-ios", forHTTPHeaderField: "User-Agent")
        
        if allowPrint
        {
            if let url = request.url
            {
                print("DELETE: \(url)")
            }
        }
        let session = URLSession.shared
        session.dataTask(with: mutableRequest)
        { (data, response, error) in
            if let response = response as? HTTPURLResponse //unwrap response
            {
                if response.statusCode == 200
                {
                    if allowPrint
                    {
                        print("SUCCESS")
                    }
                    success()
                }
                else
                {
                    let string = "Unable to delete object from server"
                    if allowPrint
                    {
                        print(string)
                    }
                    let error = ServerError(code: 400, description: NSLocalizedString(string, comment: "Server error message"))
                    failure(error)
                }
            }
        }.resume()
    }
    
    private func serverWrite(request: URLRequest, requestType: String, onSuccess success: @escaping (_ json: [String: Any]) -> Void, onFailure failure: @escaping (_ error: ServerError) -> Void)
    {
        var mutableRequest = request
        mutableRequest.httpMethod = requestType
        mutableRequest.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        if accessToken != nil
        {
            mutableRequest.setValue("\(AUTH_PREFIX) \(accessToken!)", forHTTPHeaderField: AUTH_KEY)
        }
        mutableRequest.setValue("vessel-ios", forHTTPHeaderField: "User-Agent")
        if allowDebugPrint()
        {
            if let url = request.url
            {
                print("\(requestType): \(url)")
                if request.httpBody != nil
                {
                    if let jsonData = request.httpBody
                    {
                        let jsonString = String(data: jsonData, encoding: .utf8)!
                        print(jsonString)
                    }
                }
            }
        }
        let session = URLSession.shared
        session.dataTask(with: mutableRequest)
        { (data, response, error) in
            if let data = data //unwrap data
            {
                do
                {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if self.allowDebugPrint()
                    {
                        print("Server Response:\n\(json)\n")
                    }
//CW: Put a breakpoint here to see json response from server
                    if let object = json as? [String: Any]
                    {
                        if let schemaErrors = object["schema_errors"]
                        {
                            let error = ServerError(code: 400, description: NSLocalizedString("Unable to parse response from server: \(schemaErrors)", comment: "Server error message"))
                            failure(error)
                        }
                        else
                        {
                            if let message = object["message"] as? String
                            {
                                if message == "Card already scanned successfully"
                                {
                                    failure(ServerError(code: 405, description: NSLocalizedString("Card has already been scanned", comment: "")))
                                }
                                else if message == "Updated."
                                {
                                    //happens when user changes password in ChangePasswordViewController
                                    success(object)
                                }
                                else if message == "An email will be sent if an associated account exists."
                                {
                                    //happens when user does forgot password flow
                                    success(object)
                                }
                                else
                                {
                                    let error = ServerError(code: 404, description: message)
                                    failure(error)
                                }
                            }
                            else
                            {
                                success(object)
                            }
                        }
                    }
                    else
                    {
                        let error = ServerError(code: 400, description: NSLocalizedString("Unable to parse response from server: \(json)", comment: "Server error message"))
                        failure(error)
                    }
                }
                catch
                {
                    var errorCode = 0
                    let err = error as NSError
                    errorCode = err.code
                    let string = String.init(data: data, encoding: .utf8)
                    let result = ServerError(code: errorCode, description: error.localizedDescription, moreInfo: string)
                    //print("ERROR: \(string ?? "Unknown")")
                    failure(result)
                }
            }
        }.resume()
    }
    
    private func postToServer(dictBody: [String: Any], url: String, onSuccess success: @escaping (_ object: [String: Any]) -> Void, onFailure failure: @escaping (_ message: String) -> Void)
    {
        do
        {
            let jsonData = try JSONSerialization.data(withJSONObject: dictBody, options: .prettyPrinted)

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
    
    private func debugJSONResponse(data: Data)
    {
        do
        {
            let jsonString = String(data: data, encoding: .utf8)!
            print("SUCCESS: \(jsonString)")
        }
    }
    
    //MARK: Object get / save
    func getObjects(objects: [SpecificObjectReq], onSuccess success: @escaping ([String: Any]) -> Void, onFailure failure: @escaping (_ error: String) -> Void)
    {
        var objectDict: [String: [ObjectReq]] = [:]
        for req in objects
        {
            if var array = objectDict[req.type]
            {
                array.append(ObjectReq(id: req.id, last_updated: req.last_updated))
                objectDict[req.type] = array
            }
            else
            {
                objectDict[req.type] = [ObjectReq(id: req.id, last_updated: req.last_updated)]
            }
        }
        
        let url = "\(API())\(OBJECT_GET_PATH)"
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try! encoder.encode(objectDict)
        let Url = String(format: url)
        guard let serviceUrl = URL(string: Url) else { return }
        var request = URLRequest(url: serviceUrl)
        request.httpBody = data
        
        //send it to server
        serverPost(request: request, onSuccess:
        { (dict) in
            DispatchQueue.main.async()
            {
                success(dict)
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
    
    func getAllObjects(objects: [AllObjectReq], onSuccess success: @escaping ([String: Any]) -> Void, onFailure failure: @escaping (_ error: String) -> Void)
    {
        var objectDict: [String: [String: Int]] = [:]
        for object in objects
        {
            objectDict[object.type] = ["last_updated": object.last_updated]
        }
        let url = "\(API())\(OBJECT_ALL_PATH)"
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try! encoder.encode(objectDict)
        let Url = String(format: url)
        guard let serviceUrl = URL(string: Url) else { return }
        var request = URLRequest(url: serviceUrl)
        request.httpBody = data
        
        //send it to server
        serverPost(request: request, onSuccess:
        { (data) in
            DispatchQueue.main.async()
            {
                success(data)
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
