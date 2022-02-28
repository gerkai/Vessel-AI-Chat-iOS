//
// Contact.swift
//
/*
//MARK: - Goals
struct Lookup: Codable
{
    var title: String
}

struct GoalElement: Codable, Hashable, Equatable
{
    let name: String?
    let id: Int?
    let smallImageURL: String?
    let tipCount: Int?
    var reagents: [GoalReagent]?
    var isSelected: Bool = false
    var impact: Int32? = 0
    
    enum CodingKeys: String, CodingKey
    {
        case id, name
        case smallImageURL = "image_small_url"
        case tipCount = "tip_count"
        case reagents
        case impact
    }
    
    static func == (lhs: GoalElement, rhs: GoalElement) -> Bool
    {
        return lhs.id == rhs.id
    }
}

struct GoalReagent: Codable,Hashable
{
    var reagentType: String? = ""
    var name: String? = ""
    var recommendedDailyAllowance: Int? = 0
    var id: Int? = 0
    var state: String? = ""
    var impact: Int? = 0
    var consumptionUnit: String? = ""
    var info: [Info]? = []
    var unit: String? = ""
    var supplementID: Int? = 0
}

struct Info: Codable,Hashable {
    var infoType: String?
    var reagentID: Int?
    var title, infoDescription: String?
    var comingSoonImage: String?
    var id: Int?
    var comingSoonTagItems: [String]?
}

//MARK: - Tips
enum LikeStatus: String, Codable {
    case like
    case dislike
    case NA = "N/A"
}


struct Tip: Codable {
    let id: Int?
    var totalLikes: Int?
    var likeStatus: LikeStatus?
    let sources: [Source]?
    let contact: Contact?
    let goals: [GoalElement]?
    let tipID: Int?
    let tipDescription, frequency: String?
    let imageURL: String?
    let tipTags: [TipTag]?
    let contactID: Int?
    let title: String?
    let timeOption: String?
    var mainGoalId: Int?
    var isSelected: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id
        case totalLikes = "total_likes"
        case likeStatus = "like_status"
        case sources
        case contact, goals
        case tipID = "tip_id"
        case tipDescription = "description"
        case frequency
        case imageURL = "image_url"
        case tipTags = "tip_tags"
        case contactID = "contact_id"
        case title
        case timeOption = "time_option"
        case mainGoalId = "main_goal_id"
    }
}

// MARK: - Source
struct Source: Codable {
    let author: String?
    let id, tipID: Int?
    let sourceDescription: String?
    let reagentID: Int?
    let sourceURL: String?
    let imageURL: String?
    let title: String?
    
    enum CodingKeys: String, CodingKey {
        case author, id
        case tipID = "tip_id"
        case sourceDescription = "description"
        case reagentID = "reagent_id"
        case sourceURL = "source_url"
        case imageURL = "image_url"
        case title
    }
}

// MARK: - TipTag
struct TipTag: Codable {
    let id: Int?
    let title: String?
}
//MARK: - Plan
struct Plan: Codable //, Equatable
{
    var timeOfDay: String?
    var weekDays: [Int]?
    var multiple: Int?
    var id: Int?
    var isSupplement: Bool?
    var notificationEnabled: Bool?
    var foodId: Int?
    var lifestyleRecommendation: LifestyleRecommendation?
    var lifestyleRecommendationId: Int?
    var food: FoodResponse?
    var planRecords: [PlanRecord]?
    var supplementId: Int = -1
   // var timeDate: Date? = nil
    var goals: [GoalElement]?
    var supplements: [Supplement]?
    var tipId: Int?
    var tip: Tip?
    var contact: Contact?
    var programId: Int?
    var program: Program?
    var programDates: [String]?
    var programDays: [Int]?
    
    var isExpanded: Bool = false
}

struct SupplementAssociation: Codable, Hashable {

    let aSupplementId: Int?
    let bSupplementId: Int?
    let associationType: String?

    enum CodingKeys: String, CodingKey {
        case associationType = "association_type"
        case aSupplementId = "supplement_id_a"
        case bSupplementId = "supplement_id_b"
    }
}

struct Supplement: Codable, Hashable {
    
    var id: Int?
    var dosage: Double?
    var price: Double?
    var volume: Double?
    var name: String?
    var dosageUnit: String?
    var description: String?
    var warningDescription: String?
    var goals: [GoalElement]?
    var goalsSupplement: [GoalInfo]?
    var isMultiVitamin: Bool? = false
    var isAdded: Bool? = false
    var isFree: Bool? = true
    var isRecommended: Bool? = false
    var supplementAssociation: [SupplementAssociation]?
    
   /* mutating func toggleIsAdded() {
        self.isAdded = !(self.isAdded ?? false)
    }
    
    mutating func setFree() {
        self.isFree = true
    }
    
    mutating func setNotFree() {
        self.isFree = false
    }*/
    
    /*func toRecommendation() -> Recommendation {
        return Recommendation(id: id,
                              quantity: Int(self.dosage ?? 0.0),
                              name: name,
                              isAdded: isAdded,
                              price: price,
                              dosageUnit: self.dosageUnit,
                              isRecommended: self.isRecommended,
                              isMultiVitamin: self.isMultiVitamin)
    }*/
    /*
    var concatenatedQuantity: String {
        return [Float(dosage ?? 0.0).removeZerosFromEnd(), dosageUnit ?? ""].joined(separator: " ")
    }*/
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case dosage = "dosage"
        case price = "price"
        case volume = "volume"
        case dosageUnit = "dosage_unit"
        case warningDescription = "warning_description"
        case goalsSupplement = "goals_supplement"
        case goals
        case description = "description"
        case name = "name"
        case isMultiVitamin = "is_multivitamin"
        case supplementAssociation = "supplement_association"
        case isAdded = "in_plan"
    }
}

struct GoalInfo : Codable, Hashable {
    
    var id: Int
    var impact: Int?
    var goal: GoalElement?
    
    enum CodingKeys: String, CodingKey {
        case id = "goal_id"
        case impact
        case goal
    }
}


struct PlanRecord: Codable, Equatable, Hashable {
    var id: Int?
    var date: String? // in "yyyy-MM-dd" format
    var completed: Bool?
    var planId: Int
    var is_deleted: Bool?
    
    
    enum CodingKeys: String, CodingKey {
        case id ,date ,completed, is_deleted
        case planId = "plan_id"
    }
    /*
    static func == (lhs: PlanRecord, rhs: PlanRecord) -> Bool {
        return lhs.date == rhs.date && lhs.id == rhs.id
    }*/
}

public struct FoodResponse: Codable, Equatable, Hashable {
    
    let id: Int
    let foodTitle: String
    let servingQuantity: Double?
    let servingUnit: String?
    let servingGrams, popularity: Double?
    let imageURL: String?
    let usdaNdbNumber: Int?
    let nutrientMagnesium: Double?
    let nutrientVitaminC, nutrientVitaminB9, nutrientTryptophan: Double?
    let allergySeeds, dietPaleo, dietVegan, dietLowSugar: Bool?
    let dietVegetarian, dietKeto, dietLowCarb: Bool?
    let nutrientVitaminB7, nutrientVitaminB12: Double?
    let allergyEggs, dietLowCalorie, dietLowFat, allergyPeanuts: Bool?
    let allergyMilk, allergyFish, allergyCrustacean, allergyWheat: Bool?
    let allergyGluten: Bool?
    let nutrients: [Nutrient]?
    let goals: [GoalElement]?
    var recommendation: FoodRecommendation? = nil
    var isAdded: Bool? = false
    var multiple: Int?
    let multiplicationLimit: Int = 3
    var totalLikes: Int?
    var likeStatus: LikeStatus?

    init(
        id: Int,
        foodTitle: String,
        servingQuantity: Double? = nil,
        servingUnit: String? = nil,
        servingGrams: Double? = nil,
        popularity: Double? = nil,
        imageURL: String? = nil,
        usdaNdbNumber: Int? = nil,
        nutrientMagnesium: Double? = nil,
        nutrientVitaminC: Double? = nil,
        nutrientVitaminB9: Double? = nil,
        nutrientTryptophan: Double? = nil,
        allergySeeds: Bool? = nil,
        dietPaleo: Bool? = nil,
        dietVegan: Bool? = nil,
        dietLowSugar: Bool? = nil,
        dietVegetarian: Bool? = nil,
        dietKeto: Bool? = nil,
        dietLowCarb: Bool? = nil,
        nutrientVitaminB7: Double? = nil,
        nutrientVitaminB12: Double? = nil,
        allergyEggs: Bool? = nil,
        dietLowCalorie: Bool? = nil,
        dietLowFat: Bool? = nil,
        allergyPeanuts: Bool? = nil,
        allergyMilk: Bool? = nil,
        allergyFish: Bool? = nil,
        allergyCrustacean: Bool? = nil,
        allergyWheat: Bool? = nil,
        allergyGluten: Bool? = nil,
        nutrients: [Nutrient]? = nil,
        goals: [GoalElement]? = nil,
        recommendation: FoodRecommendation? = nil,
        isAdded: Bool? = false,
        totalLikes: Int? = nil,
        likeStatus: LikeStatus? = nil
    ) {
        
        self.id = id
        self.foodTitle = foodTitle
        self.servingQuantity = servingQuantity
        self.servingUnit = servingUnit
        self.servingGrams = servingGrams
        self.popularity = popularity
        self.imageURL = imageURL
        self.usdaNdbNumber = usdaNdbNumber
        self.nutrientMagnesium = nutrientMagnesium
        self.nutrientVitaminC = nutrientVitaminC
        self.nutrientVitaminB9 = nutrientVitaminB9
        self.nutrientTryptophan = nutrientTryptophan
        self.allergySeeds = allergySeeds
        self.dietPaleo = dietPaleo
        self.dietVegan = dietVegan
        self.dietLowSugar = dietLowSugar
        self.dietVegetarian = dietVegetarian
        self.dietKeto = dietKeto
        self.dietLowCarb = dietLowCarb
        self.nutrientVitaminB7 = nutrientVitaminB7
        self.nutrientVitaminB12 = nutrientVitaminB12
        self.allergyEggs = allergyEggs
        self.dietLowCalorie = dietLowCalorie
        self.dietLowFat = dietLowFat
        self.allergyPeanuts = allergyPeanuts
        self.allergyMilk = allergyMilk
        self.allergyFish = allergyFish
        self.allergyCrustacean = allergyCrustacean
        self.allergyWheat = allergyWheat
        self.allergyGluten = allergyGluten
        self.nutrients = nutrients
        self.goals = goals
        self.recommendation = recommendation
        self.isAdded = isAdded
        self.totalLikes = totalLikes
        self.likeStatus = likeStatus
    }
    
    enum CodingKeys: String, CodingKey {
        case id, nutrients, goals
        case foodTitle = "food_title"
        case servingQuantity = "serving_quantity"
        case servingUnit = "serving_unit"
        case servingGrams = "serving_grams"
        case popularity
        case imageURL = "image_url"
        case usdaNdbNumber = "usda_ndb_number"
        case nutrientMagnesium = "nutrient_Magnesium"
        case nutrientVitaminC = "nutrient_VitaminC"
        case nutrientVitaminB9 = "nutrient_VitaminB9"
        case nutrientTryptophan = "nutrient_Tryptophan"
        case allergySeeds = "allergy_Seeds"
        case dietPaleo = "diet_Paleo"
        case dietVegan = "diet_Vegan"
        case dietLowSugar = "diet_LowSugar"
        case dietVegetarian = "diet_Vegetarian"
        case dietKeto = "diet_Keto"
        case dietLowCarb = "diet_LowCarb"
        case nutrientVitaminB7 = "nutrient_VitaminB7"
        case nutrientVitaminB12 = "nutrient_VitaminB12"
        case allergyEggs = "allergy_Eggs"
        case dietLowCalorie = "diet_LowCalorie"
        case dietLowFat = "diet_LowFat"
        case allergyPeanuts = "allergy_Peanuts"
        case allergyMilk = "allergy_Milk"
        case allergyFish = "allergy_Fish"
        case allergyCrustacean = "allergy_Crustacean"
        case allergyWheat = "allergy_Wheat"
        case allergyGluten = "allergy_Gluten"
        case recommendation
        case isAdded
        case totalLikes = "total_likes"
        case likeStatus = "like_status"
    }
}

struct FoodServingSize: Codable, Hashable {

    var display_quantity: String?
    var quantity: Double?
    var unit: String?

    init(display_quantity: String?, quantity: Double?, unit: String?) {
        self.display_quantity = display_quantity
        self.quantity = quantity
        self.unit = unit
    }
}

struct FoodRecommendation: Codable, Hashable, Equatable {

    var ndbNo: Double?
    var b7: Double?
    var b9: Double?
    var vitaminC: Double?
    var calcium: Double?
    var magnesium: Double?
    var quantity: Double? // deprecated quantity
    var name: String?
    var servingSize: FoodServingSize?
    var nutrients: [Nutrient]?
    

    init(ndbNo: Double?, b7: Double?, b9: Double?, vitaminC: Double?, calcium: Double?, magnesium: Double?, salesWeight: Double?, quantity: Double?, name: String?, servingSize: FoodServingSize?, nutrients: [Nutrient]?) {
        self.ndbNo = ndbNo
        self.b7 = b7
        self.b9 = b9
        self.vitaminC = vitaminC
        self.calcium = calcium
        self.magnesium = magnesium
        self.quantity = quantity
        self.name = name
        self.servingSize = servingSize
        self.nutrients = nutrients
    }
    
    enum CodingKeys: String, CodingKey {
        case ndbNo = "usda_ndb_number"
        case b7
        case b9
        case vitaminC = "vitamin_c"
        case calcium
        case magnesium
        case quantity
        case name
        case servingSize = "serving_size"
        case nutrients = "nutrient_data"
    }
}
struct Nutrient: Codable, Hashable {
    var id: Int?
    var name: String?
    var quantity: Double?
    var foodId: Int?
    var reagentId: Int?
    var servingGrams: Double?
    
    enum CodingKeys: String, CodingKey {
        case id, name, quantity
        case foodId = "food_id"
        case reagentId = "reagent_id"
        case servingGrams = "serving_grams"
    }
    
}


struct LifestyleRecommendation: Codable, Hashable {
    var quantity: String?
    var lifestyleId: Int?
    var name: String?
    var bucketId: Int?
    var id: Int?
    var unit: String?
    var imageURL: String?
    var isAdded: Bool = false
    var goals: [GoalElement]?
    var frequency: String?
    var extraImages: [String]?
    var description: String?
    var totalLikes: Int?
    var likeStatus: LikeStatus?
    
    var concatenatedQuantityUnit: String {
        var content = "\(quantity ?? "") \(unit ?? "")"
        if let frequency = frequency, !frequency.isEmpty {
            content.append(", \(frequency)")
        }
        return content
    }
    
    var reminderQuantityString: String {
        return "\(quantity ?? "") \(unit ?? "")"
    }
    
    enum CodingKeys: String, CodingKey {
        case quantity
        case lifestyleId = "lifestyle_recommendation_id"
        case name = "activity_name"
        case bucketId = "reagent_bucket_id"
        case id, unit
        case imageURL = "image_url"
        case goals, frequency, description
        case extraImages = "extra_images"
        case totalLikes = "total_likes"
        case likeStatus = "like_status"
    }
}

//MARK: - Program
enum ProgramDiffculty: String, Codable
{
    case easy = "EASY"
    case medium = "MED"
    case hard = "HARD"
    
    var title: String
    {
        switch self
        {
            case .medium:
                return "\(self)".capitalized
            
            default:
                return self.rawValue.capitalized
        }
    }
}

struct ScheduleResponse: Codable
{
    let day: Int
    let planIDs: [Int]
    
    enum CodingKeys: String, CodingKey
    {
        case day
        case planIDs = "plan_ids"
    }
}

struct ProgramSchedule: Codable
{
    let program_id: Int
    let enrolled_date: String
    var schedule: [ScheduleEntry]
}

struct ScheduleEntry: Codable
{
    var plans: [PlanScheduleItem]
    let day: Int
}

struct PlanScheduleItem: Codable
{
    let title: String
    let plan_id: Int
    var time_of_day: String?
    var completed: Bool
}

struct Essential: Codable
{
    var title: String?
    var link_url: String?
    var link_text: String?
    var description: String?
    var days: [Int]? = []
    var id : Int?
    var essential_record : [EssentialRecord]?
}

struct EssentialRecord: Codable, Equatable, Hashable {
    var id: Int?
    var date: String? // in "yyyy-MM-dd" format
    var completed: Bool?
    var program_day: Int
    var essential_id: Int
    var contact_id : Int
    
    
    enum CodingKeys: String, CodingKey {
        case id , date, completed, program_day, essential_id, contact_id
        
    }
    
    static func == (lhs: EssentialRecord, rhs: EssentialRecord) -> Bool {
        return lhs.date == rhs.date && lhs.id == rhs.id && lhs.completed == rhs.completed && lhs.program_day == rhs.program_day && lhs.essential_id == rhs.essential_id && lhs.contact_id == rhs.contact_id
    }
}

class Program: Codable {
    let id: Int
    var isLifestyleProgram: Bool?
    var description: String?
    var contact: Contact?
    var createdAt: String?
    var durationDays: Int?
    var title: String?
    var mainGoalId: Int?
    var contactId: Int?
    var totalLikes: Int?
    var isEnrolled: Bool?
    var difficulty: ProgramDiffculty?
    var likeStatus: LikeStatus?
    var plans: [Plan]?
    var reviewedContactIds: [Int]?
    var reviewers: [Contact?]?
    var frequency: Int?
    var goal: GoalElement?
    var sources: [Source]?
    var enrolledDate: String?
    var schedule: [ScheduleResponse]?
    var programSchedule: ProgramSchedule? = nil
    var image: String?
    var essentials: [Essential]?
    var timePerDay: Int?

    var imageURL: String? {
        return image ?? goal?.smallImageURL
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case description
        case contact
        case createdAt = "created_at"
        case durationDays = "duration_days"
        case title
        case mainGoalId = "main_goal_id"
        case contactId = "contact_id"
        case totalLikes = "total_likes"
        case isEnrolled = "is_enrolled"
        case difficulty
        case likeStatus = "like_status"
        case plans
        case reviewedContactIds = "reviewed_contact_ids"
        case reviewers
        case frequency
        case goal = "goals"
        case sources
        case schedule
        case programSchedule
        case enrolledDate = "enrolled_date"
        case image = "image_url"
        case essentials
        case timePerDay = "time_per_day"
        case isLifestyleProgram = "is_lifestyle_program"
    }
    
}*/
//MARK: - Contact
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
    
    init(id: Int? = nil,
         firstName: String? = nil,
         lastName: String? = nil,
         gender: String? = nil,
         height: Double? = nil,
         weight: Double? = nil,
         birthDate: String? = nil,
         //diets: [Lookup]? = nil,
         //allergies: [Lookup]? = nil,
         //goals: [GoalElement]? = nil,
         email: String? = nil,
         is_verified: Bool?  = false,
         
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
    
    /*private enum CodingKeys: String, CodingKey
    {
        case id, first_name, last_name
    }*/
    

    /*
    var fullName: String
    {
        return [first_name, last_name].compactMap { $0 }.filter { !$0.isEmpty }.joined(separator: " ")
    }*/
}

