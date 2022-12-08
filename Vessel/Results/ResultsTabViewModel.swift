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
    
    var isEmpty: Bool { results.isEmpty }
    
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
        if UserDefaults.standard.bool(forKey: Constants.KEY_USE_MOCK_RESULTS)
        {
            results = mockResults
        }
        else
        {
            results = Storage.retrieve(as: Result.self)
        }
        selectedResultIndex = numberOfResults() - 1
    }
    
    func refresh()
    {
        if UserDefaults.standard.bool(forKey: Constants.KEY_USE_MOCK_RESULTS)
        {
            results = mockResults
        }
        else
        {
            results = Storage.retrieve(as: Result.self)
        }
        selectedResultIndex = numberOfResults() - 1
    }
    
    func numberOfResults() -> Int
    {
        return results.count
    }
    
    func resultForIndex(i: Int) -> (result: Result, isSelected: Bool)
    {
        return (results[i], i == selectedResultIndex)
    }
    
    func selectedResult() -> Result?
    {
        var result: Result?
        if results.count != 0
        {
            print("selected result last_updated: \(results[selectedResultIndex].last_updated)")
            result = results[selectedResultIndex]
        }
        return result
    }
    
    func selectResult(index: Int)
    {
        //print("ViewModel set selected result: \(index)")
        selectedResultIndex = index
    }
}
