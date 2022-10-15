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
    var last_updated: Int //object is not returned from server yet so we mock it with a private var
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
    
    //wellness score is the default focus unless reagentID is set, then that reagent will be the focus when charting data
    var reagentID: Int?
    
    var wellnessScore: Double
    
    let reagents: [ReagentResult]
    
    enum CodingKeys: String, CodingKey
    {
        case id
        case last_updated
        case card_uuid
        case wellnessScore = "wellness_score"
        //case insert_date
        case reagents
    }
    
    init(id: Int = 0,
         last_updated: Int = 0, storage: StorageType = .cache, card_uuid: String = "12345", wellnessScore: Double = 0.85, insert_date: String = "", reagents: [ReagentResult] = [])
         
    {
        self.storage = storage
        self.wellnessScore = wellnessScore
        self.reagents = reagents
        self.last_updated = last_updated
        self.id = id
        self.card_uuid = card_uuid
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
        var result: ReagentResult?
        for reagent in reagents
        {
            if id.rawValue == reagent.id
            {
                result = reagent
                break
            }
        }
        return result
    }
}

//These are what the reagents[] array in the Result holds
struct ReagentResult: Codable
{
    let id: Int
    let score: Double
    let value: Double
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
        self.score = score
        self.value = value
        self.errorCodes = errorCodes
    }
    
    enum CodingKeys: String, CodingKey
    {
        case id = "reagent_id"
        case score
        case value
        //case errorCodes = "error_codes"
    }
}

