//
//  ResultsTabViewModel.swift
//  Vessel
//
//  Created by Carson Whitsett on 9/24/22.
//

import Foundation

class ResultsTabViewModel
{
    var selectedResultIndex: Int!
    var results: [Result]!
    
    //mock data
    /*
     case PH = 1
     case HYDRATION = 2
     case KETONES_A = 3
     case VITAMIN_C = 4
     case MAGNESIUM = 5
     case CORTISOL = 8
     case VITAMIN_B7 = 11
     case CREATININE = 12
     case CALCIUM = 18
     case NITRITE = 21
     case LEUKOCYTE = 22
     case SODIUM = 23
     */
    init()
    {
        //results = mockResults
        results = Storage.retrieve(as: Result.self)
        selectedResultIndex = numberOfResults() - 1
    }
    
    func refresh()
    {
        //results = mockResults
        results = Storage.retrieve(as: Result.self)
    }
    
    func numberOfResults() -> Int
    {
        return results.count
    }
    
    func resultForIndex(i: Int) -> Result
    {
        return results[i]
    }
    
    func selectedResult() -> Result
    {
        return results[selectedResultIndex]
    }
    
    func selectResult(index: Int)
    {
        selectedResultIndex = index
    }
    
    //uncomment to test lockout screen (and comment out the below declaration)
    //let mockResults: [Result] = []
    
    let mockResults = [Result(id: 1, last_updated: 2556, card_uuid: "12345", wellnessScore: 0.85, insert_date: "2022-08-08T19:34:00", reagents: [
        ReagentResult(id: 5, score: 0.70, value: 350.0, errorCodes: []),
        ReagentResult(id: 4, score: 0.74, value: 395.0, errorCodes: []),
        ReagentResult(id: 2, score: 0.67, value: 1.003, errorCodes: []),
        ReagentResult(id: 3, score: 0.99, value: 1.0, errorCodes: []),
        ReagentResult(id: 1, score: 0.62, value: 5.52, errorCodes: []),
        ReagentResult(id: 11, score: 0.55, value: 2.3, errorCodes: []),
        ReagentResult(id: 18, score: 0.45, value: 25.0, errorCodes: []),
        ReagentResult(id: 23, score: 0.43, value: 100.0, errorCodes: [])
    ]),
       Result(id: 1, last_updated: 3456, card_uuid: "12345", wellnessScore: 0.85, insert_date: "2022-08-17T19:34:00", reagents: [
           ReagentResult(id: 5, score: 0.30, value: 400.0, errorCodes: []),
           ReagentResult(id: 4, score: 0.74, value: 508.0, errorCodes: []),
           ReagentResult(id: 2, score: 0.67, value: 1.0, errorCodes: []),
           ReagentResult(id: 3, score: 0.99, value: 1.8, errorCodes: []),
           ReagentResult(id: 1, score: 0.62, value: 6.72, errorCodes: []),
           ReagentResult(id: 11, score: 0.55, value: 2.3, errorCodes: []),
           ReagentResult(id: 18, score: 0.45, value: 25.0, errorCodes: []),
           ReagentResult(id: 23, score: 0.43, value: 100.0, errorCodes: [])
       ]),
                   
        Result(id: 1, last_updated: 3456, card_uuid: "12345", wellnessScore: 0.22, insert_date: "2022-08-28T19:34:00", reagents: [
          ReagentResult(id: 5, score: 0.85, value: 450.0, errorCodes: []),
          ReagentResult(id: 4, score: 0.74, value: 225.0, errorCodes: []),
          ReagentResult(id: 2, score: 0.67, value: 1.0062, errorCodes: []),
          ReagentResult(id: 3, score: 0.99, value: 2.2, errorCodes: []),
          ReagentResult(id: 1, score: 0.62, value: 4.382, errorCodes: []),
          ReagentResult(id: 8, score: 0.55, value: 2.3, errorCodes: []),
          ReagentResult(id: 11, score: 0.45, value: 25.0, errorCodes: [])
        ]),

        Result(id: 1, last_updated: 3456, card_uuid: "12345", wellnessScore: 0.37, insert_date: "2022-09-03T19:34:00", reagents: [
          ReagentResult(id: 5, score: 0.85, value: 408.0, errorCodes: []),
          ReagentResult(id: 4, score: 0.74, value: 195.0, errorCodes: []),
          ReagentResult(id: 2, score: 0.67, value: 1.015, errorCodes: []),
          ReagentResult(id: 3, score: 0.99, value: 1.3, errorCodes: []),
          ReagentResult(id: 1, score: 0.62, value: 7.67, errorCodes: []),
          ReagentResult(id: 11, score: 0.55, value: 2.3, errorCodes: []),
          ReagentResult(id: 18, score: 0.45, value: 25.0, errorCodes: []),
          ReagentResult(id: 23, score: 0.43, value: 100.0, errorCodes: [])
        ]),

        Result(id: 1, last_updated: 3456, card_uuid: "12345", wellnessScore: 0.73, insert_date: "2022-09-10T19:34:00", reagents: [
          ReagentResult(id: 5, score: 0.85, value: 300.0, errorCodes: []),
          ReagentResult(id: 4, score: 0.74, value: 82.0, errorCodes: []),
          ReagentResult(id: 2, score: 0.67, value: 1.02, errorCodes: []),
          ReagentResult(id: 3, score: 0.99, value: 3.85, errorCodes: []),
          ReagentResult(id: 1, score: 0.62, value: 6.08, errorCodes: []),
          ReagentResult(id: 11, score: 0.55, value: 2.3, errorCodes: []),
          ReagentResult(id: 18, score: 0.45, value: 25.0, errorCodes: []),
          ReagentResult(id: 23, score: 0.43, value: 100.0, errorCodes: [])
        ]),

        Result(id: 1, last_updated: 3456, card_uuid: "12345", wellnessScore: 0.49, insert_date: "2022-09-16T19:34:00", reagents: [
          ReagentResult(id: 5, score: 0.85, value: 180.0, errorCodes: []),
          ReagentResult(id: 4, score: 0.74, value: 0.0, errorCodes: []),
          ReagentResult(id: 2, score: 0.67, value: 1.06, errorCodes: []),
          ReagentResult(id: 3, score: 0.99, value: 3.0, errorCodes: []),
          ReagentResult(id: 1, score: 0.62, value: 5.17, errorCodes: []),
          ReagentResult(id: 11, score: 0.55, value: 2.3, errorCodes: []),
          ReagentResult(id: 18, score: 0.45, value: 25.0, errorCodes: []),
          ReagentResult(id: 23, score: 0.43, value: 100.0, errorCodes: [])
        ]),

        Result(id: 1, last_updated: 3456, card_uuid: "12345", wellnessScore: 0.73, insert_date: "2022-09-21T19:34:00", reagents: [
          ReagentResult(id: 5, score: 0.85, value: 98.0, errorCodes: []),
          ReagentResult(id: 4, score: 0.74, value: 47.0, errorCodes: []),
          ReagentResult(id: 2, score: 0.67, value: 1.001, errorCodes: []),
          ReagentResult(id: 3, score: 0.99, value: 2.35, errorCodes: []),
          ReagentResult(id: 1, score: 0.62, value: 5.22, errorCodes: []),
          ReagentResult(id: 11, score: 0.55, value: 2.3, errorCodes: []),
          ReagentResult(id: 18, score: 0.45, value: 25.0, errorCodes: []),
          ReagentResult(id: 23, score: 0.43, value: 100.0, errorCodes: [])
        ]),

        Result(id: 1, last_updated: 3456, card_uuid: "12345", wellnessScore: 0.86, insert_date: "2022-09-23T19:34:00", reagents: [
          ReagentResult(id: 5, score: 0.85, value: 50.0, errorCodes: []),
          ReagentResult(id: 4, score: 0.74, value: 277.0, errorCodes: []),
          ReagentResult(id: 2, score: 0.67, value: 1.0092, errorCodes: []),
          ReagentResult(id: 3, score: 0.99, value: 2.28, errorCodes: []),
          ReagentResult(id: 1, score: 0.62, value: 6.22, errorCodes: []),
          ReagentResult(id: 11, score: 0.55, value: 2.3, errorCodes: []),
          ReagentResult(id: 18, score: 0.45, value: 25.0, errorCodes: []),
          ReagentResult(id: 23, score: 0.43, value: 100.0, errorCodes: [])
        ]),

        Result(id: 1, last_updated: 3456, card_uuid: "12345", wellnessScore: 0.95, insert_date: "2022-09-28T19:34:00", reagents: [
          ReagentResult(id: 5, score: 0.85, value: 250.0, errorCodes: []),
          ReagentResult(id: 4, score: 0.74, value: 989.0, errorCodes: []),
          ReagentResult(id: 2, score: 0.67, value: 1.005, errorCodes: []),
          ReagentResult(id: 3, score: 0.99, value: 3.0, errorCodes: []),
          ReagentResult(id: 1, score: 0.62, value: 7.20, errorCodes: []),
          ReagentResult(id: 11, score: 0.55, value: 12.3, errorCodes: []),
          ReagentResult(id: 18, score: 0.45, value: 67.0, errorCodes: []),
          ReagentResult(id: 23, score: 0.43, value: 30.0, errorCodes: [])
        ])]
}
