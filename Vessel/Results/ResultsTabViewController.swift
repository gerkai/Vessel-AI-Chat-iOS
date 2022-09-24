//
//  ResultsTabViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 9/24/22.
//

import UIKit

class ResultsTabViewController: UIViewController, ChartViewDataSource, ChartViewDelegate
{
    @IBOutlet weak var chartView: ChartView!
    var initialLoad = true
    
    let dataPoints = [ChartViewDataPoint(score: 0.4, month: 04, day: 9, year: 2022),
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
    
    override func viewDidLoad()
    {
        chartView.dataSource = self
        chartView.delegate = self
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        if initialLoad
        {
            initialLoad = false
            chartView.selectLastCell()
        }
    }
    
    //Mark: - ChartViewDataSource
    func chartViewNumDataPoints() -> Int
    {
        return dataPoints.count
    }
    
    func chartViewData(forIndex index: Int) -> ChartViewDataPoint
    {
        return dataPoints[index]
    }
    
    func ChartViewInfoTapped()
    {
        print("INFO TAPPED")
    }
}
