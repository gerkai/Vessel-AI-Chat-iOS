//
//  TestResult.swift
//  Vessel
//
//  Created by Carson Whitsett on 7/27/22.
//

import Foundation

struct TestResult: Codable
{
    let wellnessScore: Double
    let errors: [TestError]
    let reagents: [ReagentResult]
    
    enum CodingKeys: String, CodingKey
    {
        case wellnessScore = "wellness_score"
        case errors
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
    
    func getResult(id : Reagent.ID) -> ReagentResult?
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
    let value: Double
    let score: Double
    
    enum CodingKeys: String, CodingKey
    {
        case id = "reagent_id"
        case value
        case score
    }
}

struct TestError: Codable
{
}
