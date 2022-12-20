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
    var storage: StorageType = .cache
    
    @NullCodable var first_name: String?
    @NullCodable var last_name: String?
    @NullCodable var gender: String?
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
    var dailyWaterIntake: Int?
    
    lazy var suggestedFoods: [Food] =
    {
        let storedFoods = Storage.retrieve(as: Food.self)
        let dayOfWeek = Date().dayOfWeek
        
        let foodIds: [Int]
        let foodPlans = PlansManager.shared.getFoodPlans()
        foodIds = foodPlans.map({ $0.typeId })
        
        let foods: [Food] = foodIds.compactMap({ foodId in
            return storedFoods.first(where: { $0.id == foodId })
        })
        return foods
    }()
    
    @Resolved private var analytics: Analytics

    static func main() -> Contact?
    {
        guard let mainContact = ObjectStore.shared.getContact(id: Contact.MainID) else { return nil }
        if mainContact.diet_ids.isEmpty
        {
            mainContact.diet_ids = [Diet.ID.NONE.rawValue]
        }
        if mainContact.allergy_ids.isEmpty
        {
            mainContact.allergy_ids = [Allergy.ID.NONE.rawValue]
        }
        return mainContact
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
         loginType: LoginType? = nil,
         dailyWaterIntake: Int? = nil
    )
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
        self.dailyWaterIntake = dailyWaterIntake
    }
    
    init(_ contact: Contact)
    {
        self.id = contact.id
        self.last_updated = contact.last_updated
        self.first_name = contact.first_name
        self.last_name = contact.last_name
        self.gender = contact.gender
        self.height = contact.height
        self.weight = contact.weight
        self.birth_date = contact.birth_date
        self.email = contact.email
        self.flags = contact.flags
        _enrolled_program_ids = contact.enrolled_program_ids
        self.diet_ids = contact.diet_ids
        self.allergy_ids = contact.allergy_ids
        self.goal_ids = contact.goal_ids
        self.expert_id = contact.expert_id
        self.loginType = contact.loginType
        self.dailyWaterIntake = contact.dailyWaterIntake
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
        case dailyWaterIntake = "daily_water_intake_glasses"
    }
    
    func replaceEmptyDietsAndAllergies() -> Contact
    {
        let contact = Contact(self)
        let userDiets = self.diet_ids
        let userAllergies = self.allergy_ids
        
        if userDiets.contains(Diet.ID.NONE.rawValue)
        {
            contact.diet_ids = []
        }
        else
        {
            contact.diet_ids = userDiets
        }
        
        if userAllergies.contains(Allergy.ID.NONE.rawValue)
        {
            contact.allergy_ids = []
        }
        else
        {
            contact.allergy_ids = userAllergies
        }
        return contact
    }
    
    // MARK: - Suggested Foods
    func refreshSuggestedFoods()
    {
        suggestedFoods =
        {
            let storedFoods = Storage.retrieve(as: Food.self)
            let foodIds: [Int]
            
            let foodPlans = PlansManager.shared.getFoodPlans()
            foodIds = foodPlans.map({ $0.typeId })
            
            let foods: [Food] = foodIds.compactMap({ foodId in
                return storedFoods.first(where: { $0.id == foodId })
            })
            return foods
        }()
    }
    
    // MARK: - Strings
    func getDietsNames() -> [String]
    {
        return diet_ids.compactMap({ id in
            guard let dietID = Diet.ID(rawValue: id) else { return nil }
            return Diets[dietID]?.name.capitalized
        })
    }
    
    func getAllergiesListedString() -> String
    {
        let allergiesString: [String] = allergy_ids.compactMap({ id in
            guard let allergyID = Allergy.ID(rawValue: id) else { return nil }
            return Allergies[allergyID]?.name.capitalized
        })
        return allergiesString.joined(separator: ", ")
    }
    
    func getGoals() -> [String]
    {
        return goal_ids.compactMap({ id in
            guard let goalID = Goal.ID(rawValue: id) else { return nil }
            return Goals[goalID]?.name.capitalized
        })
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
        analytics.setUserProperty(property: "Diet", value: getDietsNames().joined(separator: ", "))
    }
    
    func setAllergiesAnalytics()
    {
        analytics.setUserProperty(property: "Allergies", value: getAllergiesListedString())
    }
    
    func setGoalsAnalytics()
    {
        analytics.setUserProperty(property: "Goals", value: getGoals().joined(separator: ", "))
    }
}

