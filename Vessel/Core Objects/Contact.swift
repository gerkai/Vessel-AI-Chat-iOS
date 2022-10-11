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
    var dailyWaterIntake: Int?
    var drinkedWaterGlasses: Int?
    var suggestedFoods: [Food]? = [
        Food(id: 0,
             last_updated: 0,
             title: "Avocado",
             serving_quantity: 1.0,
             serving_unit: "whole",
             serving_grams: 226.796,
             popularity: 0,
             usda_ndb_number: 0,
             categories: [],
             image_url: "https://i0.wp.com/homesteadandchill.com/wp-content/uploads/2020/05/how-to-grow-avocado-trees-ripe-fruit-1.jpeg?w=2048",
             reagents: [
                Reagents[Reagent.ID(rawValue: 11)!]!,
                Reagents[Reagent.ID(rawValue: 5)!]!,
                Reagents[Reagent.ID(rawValue: 4)!]!,
             ]),
        Food(id: 1,
             last_updated: 0,
             title: "Grapefruit",
             serving_quantity: 8.0,
             serving_unit: "oz",
             serving_grams: 226.796,
             popularity: 0,
             usda_ndb_number: 0,
             categories: [],
             image_url: "https://i.ibb.co/tq5kfzW/Grapefruit.png",
             reagents: [
                Reagents[Reagent.ID(rawValue: 3)!]!,
                Reagents[Reagent.ID(rawValue: 21)!]!,
                Reagents[Reagent.ID(rawValue: 2)!]!,
             ]),
        Food(id: 2,
             last_updated: 0,
             title: "Mushrooms",
             serving_quantity: 6.0,
             serving_unit: "oz",
             serving_grams: 226.796,
             popularity: 0,
             usda_ndb_number: 0,
             categories: [],
             image_url: "https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/stuffed-mushrooms-vertical-jpg-1525207616.jpg",
             reagents: [
                Reagents[Reagent.ID(rawValue: 1)!]!,
                Reagents[Reagent.ID(rawValue: 8)!]!,
                Reagents[Reagent.ID(rawValue: 22)!]!,
             ]),
        Food(id: 3,
             last_updated: 0,
             title: "Cabbage",
             serving_quantity: 8.0,
             serving_unit: "oz",
             serving_grams: 226.796,
             popularity: 0,
             usda_ndb_number: 0,
             categories: [],
             image_url: "https://cdn.greatlifepublishing.net/wp-content/uploads/sites/2/2021/05/03121529/Israeli-Red-Cabbage-Salad-Vertical-1-678x1024.jpg",
             reagents: [
                Reagents[Reagent.ID(rawValue: 3)!]!,
                Reagents[Reagent.ID(rawValue: 18)!]!,
             ]),
    ]
    
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
         dailyWaterIntake: Int? = nil,
         drinkedWaterGlasses: Int? = nil
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
        self.drinkedWaterGlasses = drinkedWaterGlasses
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
        // TODO: Uncomment when Hope adds this to the backend
        //case dailyWaterIntake
        //case drinkedWaterGlasses
        //case suggestedFoods
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

