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
