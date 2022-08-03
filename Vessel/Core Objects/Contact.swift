//
// Contact.swift
//  Vessel
//
//  Created by Carson Whitsett on 3/25/22.
//
import Foundation

class Contact: CoreObjectProtocol
{
    static var MainID: Int = 0
    static var SavedEmail: String? //temporary place to hold e-mail during account creation
    
    var id: Int
    var lastUpdated: Int = 0
    var first_name: String
    var last_name: String
    var gender: String?
    var height: Double?
    var weight: Double?
    var birth_date: String?     //in yyyy-mm-dd format
    var email: String?          //can be nil if they signed in with social and didn't share e-mail
    var flags: Int              //object is not returned from server yet so we mock it with a private var _flags
    {
        get
        {
            _flags ?? 0
        }
        set
        {
            _flags = newValue
        }
    }
    var expert_id: Int?
    var diet_ids: [Int]
    var allergy_ids: [Int]
    var goal_ids: [Int]
    var main_goal_id: Int?
    
    //things to add
//    var tutorialVersion: Int    //version of latest tutorial they've seen
    
    //discuss whether or not these should be included
    var is_verified: Bool
    var last_login: String?
    var insert_date: String?
    var password: String?       //shouldn't store this in the app
    var image_url: String?
    var occupation: String?
    var location_description: String?
    var tests_taken: Int?
    //var tips: [Tip]?
    var description: String?
    var time_zone: String?
    //var programs: [Program]?
    var has_samples: Bool?
    
    private var _flags: Int?
    
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
                       expert_id: nil,
                       diet_ids: [],
                       allergy_ids: [],
                       goal_ids: [],
                       main_goal_id: 0,
                       is_verified: true,
                       lastLogin: nil,
                       insert_date: nil,
                       password: nil,
                       image_url: nil,
                       occupation: nil,
                       location_description: nil,
                       tests_taken: nil,
                       description: nil,
                       time_zone: nil,
                       has_samples: nil)
    }
    
    //call when logging out
    static func reset()
    {
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
         expert_id: Int? = nil,
         diet_ids: [Int] = [],
         allergy_ids: [Int] = [],
         goal_ids: [Int] = [],
         main_goal_id: Int? = nil,
         
         is_verified: Bool = false,
         lastLogin: String? = nil,
         insert_date: String? = nil,
         password: String? = nil,
         image_url: String? = nil,
         occupation: String? = nil,
         location_description: String? = nil,
         tests_taken: Int? = nil,
         //tips: [Tip]?  = nil,
         description: String? = nil,
         time_zone: String? = nil,
         //programs: [Program]? = nil,
         has_samples: Bool? = nil)
    {
        self.id = id
        self.lastUpdated = lastUpdated
        self.first_name = firstName
        self.last_name = lastName
        self.gender = gender
        self.height = height
        self.weight = weight
        self.birth_date = birthDate
        self.diet_ids = diet_ids
        self.allergy_ids = allergy_ids
        self.goal_ids = goal_ids
        self.main_goal_id = main_goal_id
        _flags = flags
        self.email = email
        self.is_verified = is_verified
        
        self.last_login = lastLogin
        self.insert_date = insert_date
        self.password = password
        self.image_url = image_url
        self.occupation = occupation
        self.location_description = location_description
        self.tests_taken = tests_taken
        //self.tips = tips
        self.description = description
        self.time_zone = time_zone
        //self.programs = programs
        self.main_goal_id = main_goal_id
        self.has_samples = has_samples
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
        //case lastUpdated = "last_updated"
        case first_name
        case last_name
        case _flags = "flags"
        case diet_ids
        case allergy_ids
        case goal_ids
        case main_goal_id
        case is_verified
    }
}

