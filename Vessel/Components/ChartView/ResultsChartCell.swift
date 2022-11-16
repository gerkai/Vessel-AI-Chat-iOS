//
//  ResultsChartCell.swift
//  ChartView
//
//  Created by Carson Whitsett on 10/15/22.
//
//  to change the range of the plot area, modify the graphView top and bottom constraints.

import UIKit

class ResultsChartCell: ChartViewCell
{
    override var score: CGFloat
    {
        didSet
        {
            //print("Did set wellness score to \(wellnessScore)")
            let wellnessScore = Int((score + 0.005) * 100)
            scoreLabel.text = "\(wellnessScore)"
        }
    }
}
