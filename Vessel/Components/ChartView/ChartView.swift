//
//  ChartView.swift
//  ChartView
//
//  Created by Carson Whitsett on 9/21/22.
//

import UIKit

extension Notification.Name
{
    static let selectChartViewCell = Notification.Name("SelectChartViewCell")
}

protocol ChartViewDataSource
{
    func chartViewNumDataPoints() -> Int
    func chartViewData(forIndex index: Int) -> (result: Result, isSelected: Bool)
    func chartViewWhichCellSelected(cellIndex: Int) -> Bool
}

protocol ChartViewDelegate
{
    func ChartViewInfoTapped()
    func chartViewCellSelected(cellIndex: Int)
}

class ChartView: UIView, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ChartViewCellDelegate
{
    enum type
    {
        case wellnessScore
        case reagentDetails
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    var dataSource: ChartViewDataSource!
    
    var selectedCell = 0
    var delegate: ChartViewDelegate?
    var reagentID: Int?
    
    //if true, this will draw the tick marks on the right side of the selected cell. Defaults to true.
    var showScaleOnSelection = true
    var chartType = type.wellnessScore
    
    override func awakeFromNib()
    {
        collectionView.registerFromNib(ResultsChartCell.self)
        collectionView.registerFromNib(ReagentDetailsChartCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func cellWidth() -> CGFloat
    {
        if chartType == .wellnessScore
        {
            return 74.0
        }
        else
        {
            return 110.0
        }
    }
    
    func refresh()
    {
        //print("ChartView: refresh()")
        collectionView.reloadData()
        collectionView.contentOffset = CGPoint(x: collectionView.contentSize.width - frame.width, y: 0)
        let numCells = dataSource.chartViewNumDataPoints()
        selectedCell = numCells - 1
        NotificationCenter.default.post(name: .selectChartViewCell, object: nil, userInfo: ["cell": selectedCell, "animated": false])
    }
    
    func setSelectedCell(cellIndex: Int)
    {
        selectedCell = cellIndex
        delegate?.chartViewCellSelected(cellIndex: cellIndex)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
       // print("ScrollViewDidScroll: \(scrollView.contentOffset.x)")
        let numCells = dataSource.chartViewNumDataPoints()
        if numCells != 0
        {
            let selectionIncrement = (scrollView.contentSize.width - frame.width - 2.0) / Double(numCells - 2)
            var cell = 0
            if scrollView.contentOffset.x >= scrollView.contentSize.width - frame.width
            {
                cell = numCells - 1
            }
            else if scrollView.contentOffset.x > 0.0
            {
                cell = Int(1 + (scrollView.contentOffset.x - 1.0) / selectionIncrement)
            }
            
            //print("\(scrollView.contentOffset.x), \(scrollView.contentSize.width), \(selectionIncrement), \(cell)")
            if selectedCell != cell
            {
                setSelectedCell(cellIndex: cell)
                NotificationCenter.default.post(name: .selectChartViewCell, object: nil, userInfo: ["cell": cell, "animated": true])
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: cellWidth(), height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return dataSource.chartViewNumDataPoints()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        //print("cellForItemAt")
        let numCells = dataSource.chartViewNumDataPoints()
        let currentRow = numCells - indexPath.row - 1

        var cell: ChartViewCell!
        let data = fetchDataPointsFor(index: currentRow)
        
        if chartType == .wellnessScore
        {
            let resultsCell = (collectionView.dequeueReusableCell(withReuseIdentifier: "ResultsChartCell", for: indexPath) as! ResultsChartCell)
            cell = resultsCell
            cell.score = data[2].wellnessScore
        }
        else
        {
            let reagentDetailsCell = (collectionView.dequeueReusableCell(withReuseIdentifier: "ReagentDetailsChartCell", for: indexPath) as! ReagentDetailsChartCell)
            cell = reagentDetailsCell
            
            let reagent = Reagent.fromID(id: reagentID!)
            
            //get number of buckets in this reagent
            let numBuckets = reagent.buckets.count
            
            //determine which bucket this result falls into
            var result: ReagentResult?
            
            for dataResult in data[2].reagentResults
            {
                if dataResult.id == reagentID
                {
                    result = dataResult
                    break
                }
            }
            if result != nil
            {
                if let index = reagent.getBucketIndex(value: result!.value)
                {
                    //y = CGFloat(index) * zoneHeight + (zoneHeight / 2.0)
                    //let y = CGFloat(index) / CGFloat(numBuckets)
                    reagentDetailsCell.setTextUnitAndYPosition(text: reagent.rangeFor(value: result!.value), unit: reagent.unit, bucket: index, numBuckets: numBuckets)
                }
            }
        }
        cell.tag = numCells - indexPath.row - 1
        cell.delegate = self
        cell.graphView.data = data
        cell.graphView.reagentID = reagentID
        //time delay of at least 1 display cycle ensures proper subview frame positioning of cell
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) //w/o this, infoLabel in wrong spot
        {
            cell.select(selectionIntent: self.dataSource.chartViewWhichCellSelected(cellIndex: cell.tag))
        }
        if showScaleOnSelection == false
        {
            cell.graphView.drawTickMarks = false
        }
        if let date = Date.from(vesselTime: data[2].last_updated)
        {
            let components = Date.components(for: date)
            cell.monthLabel.text = Date.abbreviationFor(month: components.month)
            cell.dayLabel.text = String(format: "%02i", components.day)
        }
        return cell
    }
    
    func fetchDataPointsFor(index: Int) -> [Result]
    {
        //create an array of 5 data points (2 before and 2 after this data point)
        //If we're indexing either end of the data set, mark it with -1. This signals the
        //graphView not to draw that line segment.
        var data: [Result] = []
        let numCells = dataSource.chartViewNumDataPoints()
        //add two data points before current one
        if index < 2
        {
            let chartData = dataSource.chartViewData(forIndex: 0)
            data.append(chartData.result)
        }
        else
        {
            let chartData = dataSource.chartViewData(forIndex: index - 2)
            data.append(chartData.result)
        }
        if index < 1
        {
            let chartData = dataSource.chartViewData(forIndex: 0)
            data.append(chartData.result)
        }
        else
        {
            let chartData = dataSource.chartViewData(forIndex: index - 1)
            data.append(chartData.result)
        }
        
        //add current data point
        let currentData = dataSource.chartViewData(forIndex: index)
        data.append(currentData.result)
        
        //add two data points after current one
        if index >= numCells - 1
        {
            data.append(dataSource.chartViewData(forIndex: numCells - 1).result)
            data.append(dataSource.chartViewData(forIndex: numCells - 1).result)
        }
        else
        {
            let chartData = dataSource.chartViewData(forIndex: index + 1)
            data.append(chartData.result)
            
            if index >= numCells - 2
            {
                data.append(dataSource.chartViewData(forIndex: numCells - 1).result)
            }
            else
            {
                let chartData = dataSource.chartViewData(forIndex: index + 2)
                data.append(chartData.result)
            }
        }
        
        //don't draw far left segment or far right segment
        if index == 0
        {
            data[0].wellnessScore = -1
        }
        if index == numCells - 1
        {
            data[4].wellnessScore = -1
        }
        return data
    }
    
    //MARK: - ChartViewCell delegates
    func cellTapped(id: Int)
    {
        if collectionView.contentSize.width < frame.width
        {
            setSelectedCell(cellIndex: id)
            NotificationCenter.default.post(name: .selectChartViewCell, object: nil, userInfo: ["cell": id, "animated": true])
        }
    }
    
    func cellInfoTapped()
    {
        delegate?.ChartViewInfoTapped()
    }
}
