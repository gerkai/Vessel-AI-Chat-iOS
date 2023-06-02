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
    static var PractitionerID: Int? //temporary place to hold pa_id after app starts up but before user logged in. Set by app delegate
    {
        get
        {
            return UserDefaults.standard.object(forKey: Constants.KEY_PRACTITIONER_ID) as? Int
        }
        set
        {
            if newValue == nil
            {
                UserDefaults.standard.removeObject(forKey: Constants.KEY_PRACTITIONER_ID)
            }
            else
            {
                UserDefaults.standard.set(newValue, forKey: Constants.KEY_PRACTITIONER_ID)
            }
        }
    }
    
    static var FuelInfo: Fuel? //the fuel data for the current Contact
    
    var id: Int
    var last_updated: Int = 0
    var storage: StorageType = .cache
    
    @NullCodable var first_name: String?
    @NullCodable var last_name: String?
    @NullCodable var gender: String?
    var createdDate: String?
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
    var staff_id: Int?
    var pa_id: Int?
    var loginType: LoginType?
    private var _enrolled_program_ids: [Int]?
    var dailyWaterIntake: Int?
    
    lazy var suggestedFood: [Food] =
    {
        let storedFood = Storage.retrieve(as: Food.self)
        
        let foodIds: [Int]
        let foodPlans = PlansManager.shared.getFoodPlans(shouldFilterForToday: true)
        foodIds = foodPlans.map({ $0.typeId })
        
        let food: [Food] = foodIds.compactMap({ foodId in
            return storedFood.first(where: { $0.id == foodId })
        })
        return food.sorted(by: { $0.id < $1.id })
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
    
    //call when logging out
    static func reset()
    {
        KeychainHelper.standard.delete(service: CONTACT_ID_KEY, account: KEYCHAIN_ACCOUNT)
        MainID = 0
        SavedEmail = nil
        FuelInfo = nil
    }
    
    init(id: Int = 0,
         lastUpdated: Int = 0,
         firstName: String = "",
         lastName: String = "",
         gender: String = "",
         createdDate: String? = nil,
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
         staff_id: Int? = nil,
         pa_id: Int? = nil,
         loginType: LoginType? = nil,
         dailyWaterIntake: Int? = nil
    )
    {
        self.id = id
        last_updated = lastUpdated
        self.first_name = firstName
        self.last_name = lastName
        self.gender = gender
        self.createdDate = createdDate
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
        self.staff_id = staff_id
        self.pa_id = pa_id
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
        self.createdDate = contact.createdDate
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
        self.staff_id = contact.staff_id
        self.pa_id = contact.pa_id
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
    
    func getFuel(onDone done: @escaping () -> Void)
    {
        //print("Get Fuel Status:")
        Server.shared.getFuel()
        { fuel in
            Contact.FuelInfo = fuel
            if UserDefaults.standard.bool(forKey: Constants.KEY_ENABLE_FUEL)
            {
                Contact.FuelInfo?.is_active = true
            }
            
            DispatchQueue.main.async()
            {
                done()
            }
        }
        onFailure:
        { error in
            Log_Add("getFuel error: \(String(describing: error))")
        }
    }
    
    enum CodingKeys: String, CodingKey
    {
        case id
        //case last_updated
        case first_name
        case last_name
        case gender
        case createdDate = "created_date"
        case height
        case weight
        case birth_date
        case email
        case flags = "app_flags"
        case _enrolled_program_ids = "enrolled_program_ids"
        case diet_ids
        case allergy_ids
        case goal_ids
        case expert_id
        case pa_id
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
    
    // MARK: - Suggested Food
    func refreshSuggestedFood(selectedDate: String, isToday: Bool)
    {
        suggestedFood =
        {
            let storedFood = Storage.retrieve(as: Food.self)
            let foodIds: [Int]
            
            let foodPlans = PlansManager.shared.getFoodPlans(shouldFilterForToday: isToday, shouldFilterForSelectedDay: selectedDate)
                
            foodIds = foodPlans.map({ $0.typeId })
            
            let food: [Food] = foodIds.compactMap({ foodId in
                return storedFood.first(where: { $0.id == foodId })
            })
            return food.sorted(by: { $0.id < $1.id })
        }()
    }
    
    // MARK: - Strings
    func getDietsNames() -> [String]
    {
        return diet_ids.compactMap({ id in
            guard let dietID = Diet.ID(rawValue: id) else
            {
                assertionFailure("Contact-getDietsNames: Diet not available for id: \(id)")
                return nil
            }
            return Diets[dietID]?.name.capitalized
        })
    }
    
    func getAllergiesListedString() -> String
    {
        let allergiesString: [String] = allergy_ids.compactMap({ id in
            guard let allergyID = Allergy.ID(rawValue: id) else
            {
                assertionFailure("Contact-getAllergiesListedString: Allergy not available for id: \(id)")
                return nil
            }
            return Allergies[allergyID]?.name.capitalized
        })
        return allergiesString.joined(separator: ", ")
    }
    
    func getGoals() -> [String]
    {
        return goal_ids.compactMap({ id in
            guard let goalID = Goal.ID(rawValue: id) else
            {
                assertionFailure("Contact-getGoals: Goal not available for id: \(id)")
                return nil
            }
            return Goals[goalID]?.name.capitalized
        })
    }
    
    // MARK: - Analytics
    func identifyAnalytics()
    {
        guard let email = email else
        {
            assertionFailure("Contact-identifyAnalytics: Email doesn't exists")
            return
        }
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

