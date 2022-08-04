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
    var last_updated: Int = 0
    var first_name: String
    var last_name: String
    var gender: String?
    var height: Double?
    var weight: Double?
    var birth_date: String?     //in yyyy-mm-dd format
    var email: String?          //can be nil if they signed in with social and didn't share e-mail
    var flags: Int
    /*_flags
    {
        get
        {
            _flags ?? 0
        }
        set
        {
            _flags = newValue
        }
    }*/
    var enrolled_program_ids: [Int]
    var diet_ids: [Int]
    var allergy_ids: [Int]
    var goal_ids: [Int]
    var main_goal_id: Int?
    var expert_id: Int?
    //private var _flags: Int?
    
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
                       main_goal_id: 0,
                       expert_id: 0)
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
         enrolled_program_ids: [Int] = [],
         diet_ids: [Int] = [],
         allergy_ids: [Int] = [],
         goal_ids: [Int] = [],
         main_goal_id: Int? = nil,
         expert_id: Int? = nil)
    {
        self.id = id
        self.last_updated = lastUpdated
        self.first_name = firstName
        self.last_name = lastName
        self.gender = gender
        self.height = height
        self.weight = weight
        self.birth_date = birthDate
        self.email = email
        self.flags = flags
        self.enrolled_program_ids = enrolled_program_ids
        self.diet_ids = diet_ids
        self.allergy_ids = allergy_ids
        self.goal_ids = goal_ids
        self.main_goal_id = main_goal_id
        self.expert_id = expert_id
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
        case last_updated
        case first_name
        case last_name
        case gender
        case height
        case weight
        case birth_date
        case email
        case flags = "app_flags"
        case enrolled_program_ids
        case diet_ids
        case allergy_ids
        case goal_ids
        case main_goal_id
        case expert_id
    }
}

