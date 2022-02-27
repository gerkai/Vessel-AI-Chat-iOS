//
// Contact.swift
//

struct Contact: Codable
{
    var id: Int?                //make non optional
    var first_name: String?     //make non optional
    var last_name: String?      //make non optional
    var gender: String?         //make non optional
    var height: Double?         //make non optional
    var weight: Double?         //make non optional
    var birth_date: String?     //make non optional
    //var diets: [Lookup]?      //needs to be an array of dietIDs (Int)
    //var allergies: [Lookup]?  //needs to be an array of allergyIDs (Int)
    //var goals: [GoalElement]? //array of 3 goal IDs (Int). First one is the focus goal
    var email: String?          //can be nil if they signed in with social and didn't share e-mail
    var is_verified: Bool?      //make non optional
    
    //things to add
    var tutorialVersion: Int    //version of latest tutorial they've seen
    
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
    
    init(lastLogin: String? = nil,
         birthDate: String? = nil,
         email: String? = nil,
         password: String? = nil,
         gender: String? = nil,
         id: Int? = nil,
         weight: Double? = nil,
         firstName: String? = nil,
         lastName: String? = nil,
         height: Double? = nil,
         //diets: [Lookup]? = nil,
         //allergies: [Lookup]? = nil,
         //goals: [GoalElement]? = nil,
         tutorialVersion: Int = 0,
         insert_date:String? = nil,
         image_url: String? = nil,
         is_verified: Bool?  = false,
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
        self.last_login = lastLogin
        self.birth_date = birthDate
        self.email = email
        self.password = password
        self.gender = gender
        self.id = id
        self.weight = weight
        self.first_name = firstName
        self.last_name = lastName
        self.height = height
        self.tutorialVersion = tutorialVersion
        //self.diets = diets
        //self.allergies = allergies
        //self.goals = goals
        self.insert_date = insert_date
        self.image_url = image_url
        self.is_verified = is_verified
        self.occupation = occupation
        self.location_description = location_description
        self.tests_taken = tests_taken
       // self.tips = tips
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
}

