//
//  ResultsTabViewModel.swift
//  Vessel
//
//  Created by Carson Whitsett on 9/24/22.
//

import Foundation

class ResultsTabViewModel
{
    //mock data
    let dataPoints: [ChartViewDataPoint] = [ChartViewDataPoint(score: 0.4, month: 04, day: 9, year: 2022),
                      ChartViewDataPoint(score: 0.7, month: 04, day: 16, year: 2022),
                      ChartViewDataPoint(score: 0.3, month: 04, day: 23, year: 2022),
                      ChartViewDataPoint(score: 0.22, month: 04, day: 30, year: 2022),
                      ChartViewDataPoint(score: 0.37, month: 05, day: 7, year: 2022),
                      ChartViewDataPoint(score: 0.46, month: 05, day: 14, year: 2022),
                      ChartViewDataPoint(score: 0.59, month: 05, day: 21, year: 2022),
                      ChartViewDataPoint(score: 0.73, month: 05, day: 28, year: 2022),
                      ChartViewDataPoint(score: 0.86, month: 06, day: 4, year: 2022),
                      ChartViewDataPoint(score: 0.77, month: 06, day: 11, year: 2022),
                      ChartViewDataPoint(score: 0.42, month: 06, day: 18, year: 2022),
                      ChartViewDataPoint(score: 0.68, month: 06, day: 25, year: 2022),
                      ChartViewDataPoint(score: 0.87, month: 07, day: 2, year: 2022),
                      ChartViewDataPoint(score: 0.92, month: 07, day: 9, year: 2022),
                      ChartViewDataPoint(score: 1.0, month: 07, day: 16, year: 2022),
                      ChartViewDataPoint(score: 0.9, month: 07, day: 23, year: 2022),
                      ChartViewDataPoint(score: 0.8, month: 07, day: 30, year: 2022),
                      ChartViewDataPoint(score: 0.7, month: 08, day: 6, year: 2022),
                      ChartViewDataPoint(score: 0.6, month: 08, day: 13, year: 2022),
                      ChartViewDataPoint(score: 0.5, month: 08, day: 20, year: 2022),
                      ChartViewDataPoint(score: 0.4, month: 08, day: 27, year: 2022),
                      ChartViewDataPoint(score: 0.3, month: 09, day: 3, year: 2022),
                      ChartViewDataPoint(score: 0.2, month: 09, day: 10, year: 2022),
                      ChartViewDataPoint(score: 0.1, month: 09, day: 17, year: 2022),
                      ChartViewDataPoint(score: 0.0, month: 09, day: 24, year: 2022)]
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
    let result = Result(id: 1, lastUpdated: 0, cardUUID: "12345", wellnessScore: 0.85, dateString: "2022-09-24T19:34:00", reagents: [
        ReagentResult(id: 5, score: 0.85, value: 250.0, errorCodes: []),
        ReagentResult(id: 4, score: 0.74, value: 395.0, errorCodes: []),
        ReagentResult(id: 2, score: 0.67, value: 1.003, errorCodes: []),
        ReagentResult(id: 3, score: 0.99, value: 1.0, errorCodes: []),
        ReagentResult(id: 1, score: 0.62, value: 5.52, errorCodes: []),
        ReagentResult(id: 11, score: 0.55, value: 2.3, errorCodes: []),
        ReagentResult(id: 18, score: 0.45, value: 25.0, errorCodes: []),
        ReagentResult(id: 23, score: 0.43, value: 100.0, errorCodes: [])
    ])
}
