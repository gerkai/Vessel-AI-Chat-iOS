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
    @IBOutlet weak var collectionView: UICollectionView!
    var dataSource: ChartViewDataSource!
    
    let cellWidth = 74.0
    var selectedCell = 0
    var delegate: ChartViewDelegate?
    
    override func awakeFromNib()
    {
        collectionView.registerFromNib(ChartViewCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func refresh()
    {
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
        return CGSize(width: cellWidth, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return dataSource.chartViewNumDataPoints()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let numCells = dataSource.chartViewNumDataPoints()
        let currentRow = numCells - indexPath.row - 1

        let cell: ChartViewCell = collectionView.dequeueCell(for: indexPath)
        cell.tag = numCells - indexPath.row - 1
        cell.delegate = self
        cell.select(selectionIntent: dataSource.chartViewWhichCellSelected(cellIndex: cell.tag))
        let data = fetchDataPointsFor(index: currentRow)
        cell.graphView.data = data
        let wellnessScore = Int((data[2].wellnessScore + 0.005) * 100)
        cell.wellnessScoreLabel.text = "\(wellnessScore)"
        cell.wellnessScore = data[2].wellnessScore
        if let date = Date.from(vesselTime: data[2].last_updated)
        {
            let components = Date.components(for: date)
            cell.monthLabel.text = Date.abbreviationFor(month: components.month)
            cell.dayLabel.text = String(format: "%02i", components.day)
        }
        print("CELL: \(cell)")
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
