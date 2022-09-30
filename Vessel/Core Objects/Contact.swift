//
// Contact.swift
//  Vessel
//
//  Created by Carson Whitsett on 3/25/22.
//
import Foundation

enum Gender: Int, CaseIterable
{
    case male
    case female
    case other
    
    init?(genderString: String)
    {
        switch genderString
        {
        case Constants.GENDER_MALE:
            self.init(rawValue: 0)
        case Constants.GENDER_FEMALE:
            self.init(rawValue: 1)
        case Constants.GENDER_OTHER:
            self.init(rawValue: 2)
        default:
            return nil
        }
    }
}

class Contact: CoreObjectProtocol
{
    static var MainID: Int = 0
    static var SavedEmail: String? //temporary place to hold e-mail during account creation
    
    var id: Int
    var last_updated: Int = 0
    var first_name: String
    var last_name: String
    var gender: String?
    var height: Double?
    var weight: Double?
    var birth_date: String?     //in yyyy-mm-dd format
    var email: String?          //can be nil if they signed in with social and didn't share e-mail
    var flags: Int
    var enrolled_program_ids: [Int] //object is not returned from server yet so we mock it with a private var
    {
        get
        {
            _enrolled_program_ids ?? []
        }
        set
        {
            _enrolled_program_ids = newValue
        }
    }
    var diet_ids: [Int]
    var allergy_ids: [Int]
    var goal_ids: [Int]
    var expert_id: Int?
    var loginType: LoginType?
    private var _enrolled_program_ids: [Int]?
    
    @Resolved private var analytics: Analytics

    static func main() -> Contact?
    {
        return ObjectStore.shared.getContact(id: Contact.MainID) 
    }
    
    static func mockContact() -> Contact
    {
        return Contact(id: 0,
                       lastUpdated: 0,
                       firstName: "Nicolas",
                       lastName: "Medina",
                       gender: "m",
                       height: 182,
                       weight: 155,
                       birthDate: "1991-10-31",
                       email: "nicolas@vesselhealth.com",
                       flags: 0,
                       enrolled_program_ids: [],
                       diet_ids: [],
                       allergy_ids: [],
                       goal_ids: [],
                       expert_id: 0)
    }
    
    //call when logging out
    static func reset()
    {
        KeychainHelper.standard.delete(service: CONTACT_ID_KEY, account: KEYCHAIN_ACCOUNT)
        MainID = 0
        SavedEmail = nil
    }
    
    init(id: Int = 0,
         lastUpdated: Int = 0,
         firstName: String = "",
         lastName: String = "",
         gender: String = "",
         height: Double? = nil,
         weight: Double? = nil,
         birthDate: String? = nil,
         email: String? = nil,
         flags: Int = 0,
         enrolled_program_ids: [Int] = [],
         diet_ids: [Int] = [],
         allergy_ids: [Int] = [],
         goal_ids: [Int] = [],
         expert_id: Int? = nil,
         loginType: LoginType? = nil)
    {
        self.id = id
        last_updated = lastUpdated
        self.first_name = firstName
        self.last_name = lastName
        self.gender = gender
        self.height = height
        self.weight = weight
        self.birth_date = birthDate
        self.email = email
        self.flags = flags
        _enrolled_program_ids = enrolled_program_ids
        self.diet_ids = diet_ids
        self.allergy_ids = allergy_ids
        self.goal_ids = goal_ids
        self.expert_id = expert_id
        self.loginType = loginType
    }
    
    var fullName: String
    {
        return [first_name, last_name].compactMap { $0 }.filter { !$0.isEmpty }.joined(separator: " ")
    }
    
    //if the contact doesn't have basic info filled out, then it's brand new
    func isBrandNew() -> Bool
    {
        if ((gender == nil) || (gender == ""))
        {
            return true
        }
        return false
    }
    
    func isOnDiet(_ diet: Diet.ID) -> Bool
    {
        for id in diet_ids
        {
            if id == diet.rawValue
            {
                return true
            }
        }
        return false
    }
    
    enum CodingKeys: String, CodingKey
    {
        case id
        //case last_updated
        case first_name
        case last_name
        case gender
        case height
        case weight
        case birth_date
        case flags = "app_flags"
        case _enrolled_program_ids = "enrolled_program_ids"
        case diet_ids
        case allergy_ids
        case goal_ids
        case email
        case expert_id
    }
    
    // MARK: - Strings
    func getDietsListedString() -> String
    {
        let dietsString: [String] = diet_ids.compactMap({ id in
            guard let dietID = Diet.ID(rawValue: id) else { return nil }
            return Diets[dietID]?.name.capitalized
        })
        return dietsString.joined(separator: ", ")
    }
    
    func getAllergiesListedString() -> String
    {
        let allergiesString: [String] = allergy_ids.compactMap({ id in
            guard let allergyID = Allergy.ID(rawValue: id) else { return nil }
            return Allergies[allergyID]?.name.capitalized
        })
        return allergiesString.joined(separator: ", ")
    }
    
    func getGoalsListedString() -> String
    {
        let goalsString: [String] = goal_ids.compactMap({ id in
            guard let goalID = Goal.ID(rawValue: id) else { return nil }
            return Goals[goalID]?.name.capitalized
        })
        return goalsString.joined(separator: ", ")
    }
    
    // MARK: - Analytics
    func identifyAnalytics()
    {
        guard let email = email else { return }
        analytics.identify(id: "\(id)")
        analytics.setUserProperties(properties: [
            "$name": fullName,
            "$email": email
        ])
    }
    
    func setDietsAnalytics()
    {
        analytics.setUserProperty(property: "Diet", value: getDietsListedString())
    }
    
    func setAllergiesAnalytics()
    {
        analytics.setUserProperty(property: "Allergies", value: getAllergiesListedString())
    }
    
    func setGoalsAnalytics()
    {
        analytics.setUserProperty(property: "Goals", value: getGoalsListedString())
    }
}

