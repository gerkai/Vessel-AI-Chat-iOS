//
//  Result.swift
//  Vessel
//
//  Created by Carson Whitsett on 7/27/22.
//

import Foundation

struct Result: CoreObjectProtocol, Codable
{
    var id: Int
    var last_updated: Int 
    var card_uuid: String
    var insert_date: String
    {
        get
        {
            _insert_date ?? ""
        }
        set
        {
            _insert_date = newValue
        }
    }

    private var _insert_date: String?
    
    var storage: StorageType = .disk
    
    var wellnessScore: Double
    
    let reagentResults: [ReagentResult]
    let errors: [ReagentError]
    
    enum CodingKeys: String, CodingKey
    {
        case id
        case last_updated
        case card_uuid
        case wellnessScore = "wellness_score"
        case reagentResults = "reagents" //should change this to reagentResults on back end
        case errors
    }
    
    init(id: Int = 0,
         last_updated: Int = 0, storage: StorageType = .cache, card_uuid: String = "12345", wellnessScore: Double = 0.85, insert_date: String = "", reagentResults: [ReagentResult] = [], errors: [ReagentError] = [])
         
    {
        self.storage = storage
        self.wellnessScore = wellnessScore
        self.reagentResults = reagentResults
        self.last_updated = last_updated
        self.id = id
        self.card_uuid = card_uuid
        self.errors = errors
        self.insert_date = insert_date
    }
    
    func isEvaluatedTo(id: Reagent.ID, evaluation: Evaluation) -> Bool
    {
        var result = false
        if let reagentResult = getResult(id: id)
        {
            let reagentEval = Reagent.evaluation(id: id, value: reagentResult.value)
            if reagentEval == evaluation
            {
                result = true
            }
        }
        return result
    }
    
    func getResult(id: Reagent.ID) -> ReagentResult?
    {
        var reagentResult: ReagentResult?
        for result in reagentResults
        {
            if id.rawValue == result.id
            {
                reagentResult = result
                break
            }
        }
        return reagentResult
    }
    
    /*func reagentWith(id: Int) -> Reagent
    {
        for result in reagentResults
        {
            
        }
    }*/
}

//These are what the reagents[] array in the Result holds
struct ReagentResult: Codable
{
    let id: Int //the id of the reagent
    //let score: Double //cw: Deprecated. Score is retrieved directly from reagent now based on value
    var value: Double? //cw: server returns null if there was an error with this reagent
    var errorCodes: [Int]
    {
        get
        {
            _error_codes ?? []
        }
        set
        {
            _error_codes = newValue
        }
    }
    private var _error_codes: [Int]?
    
    init(id: Int = 0,
         score: Double = 0.0, value: Double = 0.0, errorCodes: [Int] = [])
         
    {
        self.id = id
        //self.score = score
        self.value = value
        self.errorCodes = errorCodes
    }
    
    enum CodingKeys: String, CodingKey
    {
        case id = "reagent_id"
        //case score
        case value
        //case errorCodes = "error_codes"
    }
    
    func getScore() -> Double
    {
        if let value = value
        {
            let reagent = Reagents[Reagent.ID(rawValue: id)!]
            return reagent!.getScore(value: value)
        }
        else
        {
            return 0
        }
    }
}

struct ReagentError: Codable
{
    let slot_name: String
    let reagent: ReagentErrorReagentInfo
    let reagent_id: Int
    let error_code: Int
    let sample_error: SampleError
}

struct ReagentErrorReagentInfo: Codable
{
    let name: String
    let id: Int
}

struct SampleError: Codable
{
    let error_type: String
    let insert_date: String
    let label: String
    let error_code: Int
}

