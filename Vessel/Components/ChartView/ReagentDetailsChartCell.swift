//
//  ReagentDetailsChartCell.swift
//  ChartView
//
//  Created by Carson Whitsett on 10/15/22.
//
//  to change the range of the plot area, modify the graphView top and bottom constraints.

import UIKit

class ReagentDetailsChartCell: ChartViewCell
{
    @IBOutlet weak var reagentUnit: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        selectedHeightOffset = 20.0
    }
    
    func setTextUnitAndYPosition(text: String, unit: String, bucket: Int, numBuckets: Int)
    {
        scoreLabel.text = text
        reagentUnit.text = unit
        
        //let zoneHeight = graphView.frame.height / CGFloat(numBuckets)
        //scoreLabelYPosition.constant = CGFloat(bucket) * zoneHeight + (zoneHeight / 2.0)
        //print("bucket: \(bucket), numBuckets: \(numBuckets), zoneHeight: \(zoneHeight), constant: \(scoreLabelYPosition.constant)")
    }
}
