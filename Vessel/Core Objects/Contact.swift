//
// Contact.swift
//



var SavedEmail: String?

struct Contact: CoreObjectProtocol, Codable
{
    static var MainID: Int = 0
    var id: Int
    var first_name: String
    var last_name: String
    var email: String?          //can be nil if they signed in with social and didn't share e-mail
    var gender: String?
    var height: Double?         
    var weight: Double?
    var birth_date: String?     //in yyyy-mm-dd format
    //var diets: [Lookup]?      //needs to be an array of dietIDs (Int)
    //var allergies: [Lookup]?  //needs to be an array of allergyIDs (Int)
    //var goals: [GoalElement]? //array of 3 goal IDs (Int). First one is the focus goal
    
    var is_verified: Bool
    
    //things to add
//    var tutorialVersion: Int    //version of latest tutorial they've seen
    
    //discuss whether or not these should be included
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
    var main_goal_id: Int?
    var has_samples: Bool?
    
    static func main() -> Contact?
    {
        return ObjectStore.shared.getContact(id: Contact.MainID) 
    }
    
    init(id: Int = 0,
         firstName: String = "",
         lastName: String = "",
         gender: String = "",
         height: Double? = nil,
         weight: Double? = nil,
         birthDate: String? = nil,
         //diets: [Lookup]? = nil,
         //allergies: [Lookup]? = nil,
         //goals: [GoalElement]? = nil,
         email: String? = nil,
         is_verified: Bool  = false,
         
 //        tutorialVersion: Int = 0,
         
         lastLogin: String? = nil,
         insert_date:String? = nil,
         password: String? = nil,
         image_url: String? = nil,
         occupation: String? = nil,
         location_description: String? = nil,
         tests_taken: Int? = nil,
         //tips: [Tip]?  = nil,
         description: String? = nil,
         time_zone: String? = nil,
         //programs: [Program]? = nil,
         main_goal_id: Int? = nil,
         has_samples: Bool? = nil)
    {
        self.id = id
        self.first_name = firstName
        self.last_name = lastName
        self.gender = gender
        self.height = height
        self.weight = weight
        self.birth_date = birthDate
        //self.diets = diets
        //self.allergies = allergies
        //self.goals = goals
        self.email = email
        self.is_verified = is_verified
        
 //       self.tutorialVersion = tutorialVersion
        
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
        if first_name.count == 0 &&
            last_name.count == 0 &&
            ((gender == nil) || (gender == ""))
        {
            return true
        }
        return false
    }
}

