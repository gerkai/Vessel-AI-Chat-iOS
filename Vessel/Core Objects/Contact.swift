//
// Contact.swift
//

struct Contact: Codable
{
    var last_login: String?
    var insert_date: String?
    var birth_date: String?
    var email: String?
    var password: String?
    var gender: String?
    var id: Int?
    var weight: Double?
    var first_name: String?
    var last_name: String?
    var height: Double?
    //var goals: [GoalElement]?
    //var diets: [Lookup]?
    //var allergies: [Lookup]?
    var image_url: String?
    var is_verified: Bool?
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

