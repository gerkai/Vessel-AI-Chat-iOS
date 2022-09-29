//
//  Result.swift
//  Vessel
//
//  Created by Carson Whitsett on 7/27/22.
//

import Foundation

struct Result: Codable
{
    let id: Int
    let lastUpdated: Int
    let cardUUID: String
    var wellnessScore: Double
    let dateString: String
    let reagents: [ReagentResult]
    
    enum CodingKeys: String, CodingKey
    {
        case id
        case lastUpdated = "last_updated"
        case cardUUID = "card_uuid"
        case wellnessScore = "wellness_score"
        case dateString = "insert_date"
        case reagents
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

struct ReagentResult: Codable
{
    let id: Int
    let score: Double
    let value: Double
    let errorCodes: [Int]
    
    enum CodingKeys: String, CodingKey
    {
        case id = "reagent_id"
        case score
        case value
        case errorCodes = "error_codes"
    }
}

