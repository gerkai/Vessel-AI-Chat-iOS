//
//  ChartView.swift
//  ChartView
//
//  Created by Carson Whitsett on 9/21/22.
//

import UIKit

struct ChartViewDataPoint
{
    var score: Double
    var month: Int
    var day: Int
    var year: Int
}

extension Notification.Name
{
    static let selectChartViewCell = Notification.Name("SelectChartViewCell")
}

protocol ChartViewDataSource
{
    func chartViewNumDataPoints() -> Int
    func chartViewData(forIndex index: Int) -> ChartViewDataPoint
}

protocol ChartViewDelegate
{
    func ChartViewInfoTapped()
}

class ChartView: UIView, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ChartViewCellDelegate
{
    @IBOutlet weak var collectionView: UICollectionView!
    var dataSource: ChartViewDataSource!
    
    let cellWidth = 74.0
    var numCells: Int!
    var selectedCell = 0
    var delegate: ChartViewDelegate?
    
    override func awakeFromNib()
    {
        collectionView.registerFromNib(ChartViewCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func selectLastCell()
    {
        if numCells == nil
        {
            numCells = dataSource.chartViewNumDataPoints()
        }
        NotificationCenter.default.post(name: .selectChartViewCell, object: nil, userInfo: ["cell": numCells - 1])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        if numCells == nil
        {
            numCells = dataSource.chartViewNumDataPoints()
        }
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
            selectedCell = cell
            NotificationCenter.default.post(name: .selectChartViewCell, object: nil, userInfo: ["cell": cell])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: cellWidth, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return numCells
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let currentRow = numCells - indexPath.row - 1

        let cell: ChartViewCell = collectionView.dequeueCell(for: indexPath)
        cell.tag = numCells - indexPath.row - 1
        cell.delegate = self
        
        let data = fetchDataPointsFor(index: currentRow)
        cell.graphView.data = data
        let wellnessScore = Int((data[2].score + 0.005) * 100)
        cell.wellnessScoreLabel.text = "\(wellnessScore)"
        cell.wellnessScore = data[2].score
        //cell.dateMonth = data[2].month
        //cell.dateDay = data[2].day
        cell.monthLabel.text = Date.abbreviationFor(month: data[2].month)
        cell.dayLabel.text = String(format: "%02i", data[2].day)
        return cell
    }
    
    func fetchDataPointsFor(index: Int) -> [ChartViewDataPoint]
    {
        //create an array of 5 data points (2 before and 2 after this data point)
        //If we're indexing either end of the data set, mark it with -1. This signals the
        //graphView not to draw that line segment.
        var data: [ChartViewDataPoint] = []
        
        //add two data points before current one
        if index < 2
        {
            let chartData = dataSource.chartViewData(forIndex: 0)
            data.append(chartData)
        }
        else
        {
            let chartData = dataSource.chartViewData(forIndex: index - 2)
            data.append(chartData)
        }
        if index < 1
        {
            let chartData = dataSource.chartViewData(forIndex: 0)
            data.append(chartData)
        }
        else
        {
            let chartData = dataSource.chartViewData(forIndex: index - 1)
            data.append(chartData)
        }
        
        //add current data point
        let currentData = dataSource.chartViewData(forIndex: index)
        data.append(currentData)
        
        //add two data points after current one
        if index >= numCells - 1
        {
            data.append(dataSource.chartViewData(forIndex: numCells - 1))
            data.append(dataSource.chartViewData(forIndex: numCells - 1))
        }
        else
        {
            let chartData = dataSource.chartViewData(forIndex: index + 1)
            data.append(chartData)
            
            if index >= numCells - 2
            {
                data.append(dataSource.chartViewData(forIndex: numCells - 1))
            }
            else
            {
                let chartData = dataSource.chartViewData(forIndex: index + 2)
                data.append(chartData)
            }
        }
        
        //don't draw far left segment or far right segment
        if index == 0
        {
            data[0].score = -1
        }
        if index == numCells - 1
        {
            data[4].score = -1
        }
        return data
    }
    
    //MARK: - ChartViewCell delegates
    func cellTapped(id: Int)
    {
        if collectionView.contentSize.width < frame.width
        {
            selectedCell = id
            NotificationCenter.default.post(name: .selectChartViewCell, object: nil, userInfo: ["cell": id])
        }
    }
    
    func cellInfoTapped()
    {
        delegate?.ChartViewInfoTapped()
    }
}
