//
//  ChartView.swift
//  ChartView
//
//  Created by Carson Whitsett on 9/21/22.
//

import UIKit

protocol ChartViewDataSource: AnyObject
{
    func chartViewNumDataPoints() -> Int
    func chartViewData(forIndex index: Int) -> (result: Result, isSelected: Bool)
    func chartViewWhichCellSelected(cellIndex: Int) -> Bool
}

protocol ChartViewDelegate: AnyObject
{
    func ChartViewInfoTapped()
    func chartViewCellSelected(cellIndex: Int)
}

class ChartView: UIView, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ChartViewCellDelegate
{
    enum ChartViewType
    {
        case wellnessScore
        case reagentDetails
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    weak var dataSource: ChartViewDataSource!
    
    var selectedCell = -1
    weak var delegate: ChartViewDelegate?
    var reagentID: Int?
    //when the view is being initialized, the system sends several scrollViewDidScroll callbacks with the scrollView at 0.0 or at max before it eventually settles down at the correct contentOffset. This was causing us to notify delegates and post notifications with the wrong selected cell. So we disable notifications until the user actually starts scrolling the scrollView.
    var notificationsEnabled = false
    
    //if true, this will draw the tick marks on the right side of the selected cell. Defaults to true.
    var showScaleOnSelection = true
    var chartType = ChartViewType.wellnessScore
    
    override func awakeFromNib()
    {
        if UserDefaults.standard.bool(forKey: Constants.KEY_PRINT_INIT_DEINIT)
        {
            print("✳️ \(self)")
        }
        collectionView.registerFromNib(ResultsChartCell.self)
        collectionView.registerFromNib(ReagentDetailsChartCell.self)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.selected(_:)), name: .selectChartViewCell, object: nil)
    }
    
    deinit
    {
        if UserDefaults.standard.bool(forKey: Constants.KEY_PRINT_INIT_DEINIT)
        {
            print("❌ \(self)")
        }
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func selected(_ notification: NSNotification)
    {
        if let cellIndex = notification.userInfo?["cell"] as? Int
        {
            //if my selectedCell doesn't match notification cell then move to the notification cell
            if cellIndex != selectedCell
            {
                preSelectCell(cellIndex: cellIndex)
            }
        }
    }
    
    func cellWidth() -> CGFloat
    {
        if chartType == .wellnessScore
        {
            return 74.0
        }
        else
        {
            //reagent details has slightly wider cell in order to fit the range data
            return 110.0
        }
    }
    
    func refresh()
    {
        //print("ChartView \(tag): refresh()")
        collectionView.reloadData()
        collectionView.contentOffset = CGPoint(x: collectionView.contentSize.width - frame.width, y: 0)
        let numCells = dataSource.chartViewNumDataPoints()
        selectedCell = numCells - 1
        NotificationCenter.default.post(name: .selectChartViewCell, object: nil, userInfo: ["cell": selectedCell, "animated": false])
    }
    
    //when chartView is first loaded, we can pre-select a particular cell and this will calculate the collectionView's proper scrollView offset.
    func preSelectCell(cellIndex: Int)
    {
        selectedCell = cellIndex
        //print("preselecting cell: \(cellIndex) for \(dataSource)")
        var offset = 0.0
        let numCells = dataSource.chartViewNumDataPoints()
        let selectionIncrement = (collectionView.contentSize.width - frame.width - 2.0) / Double(numCells - 2)
        
        if cellIndex == numCells - 1
        {
            offset = collectionView.contentSize.width - frame.width
        }
        else if cellIndex != 0
        {
            offset = 1.0 + CGFloat(cellIndex) * selectionIncrement - (selectionIncrement / 2)
        }
        
        delegate?.chartViewCellSelected(cellIndex: cellIndex)
        //print("\(tag) Preselecting offset: \(offset)")
        collectionView.contentOffset = CGPoint(x: offset, y: 0.0)
    }
    
    func setSelectedCell(cellIndex: Int)
    {
        selectedCell = cellIndex
        delegate?.chartViewCellSelected(cellIndex: cellIndex)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    {
        //print("ScrollView will begin dragging")
        notificationsEnabled = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        //print("\(tag) ScrollViewDidScroll: \(scrollView.contentOffset.x)")
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
            if notificationsEnabled
            {
                if selectedCell != cell
                {
                    setSelectedCell(cellIndex: cell)
                   // print("\(tag) Posting select notification for \(cell)")
                    NotificationCenter.default.post(name: .selectChartViewCell, object: nil, userInfo: ["cell": cell, "animated": true])
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: cellWidth(), height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        //print("Number of items: \(dataSource.chartViewNumDataPoints())")
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
                if let value = result!.value
                {
                    if let index = reagent.getBucketIndex(value: value)
                    {
                        //y = CGFloat(index) * zoneHeight + (zoneHeight / 2.0)
                        //let y = CGFloat(index) / CGFloat(numBuckets)
                        reagentDetailsCell.setTextUnitAndYPosition(text: reagent.rangeFor(value: value), unit: reagent.unit, bucket: index, numBuckets: numBuckets)
                    }
                }
            }
        }
        cell.parentTag = tag
        cell.tag = numCells - indexPath.row - 1
        cell.delegate = self
        cell.graphView.data = data
        cell.graphView.reagentID = reagentID
        //time delay of at least 1 display cycle ensures proper subview frame positioning of cell
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) //w/o this, infoLabel in wrong spot
        {
            //print("Setting selected cell: \(cell.tag) in vc:\(String(describing: self.dataSource))")
            cell.select(selectionIntent: self.dataSource.chartViewWhichCellSelected(cellIndex: cell.tag))
        }
        if showScaleOnSelection == false
        {
            cell.graphView.drawTickMarks = false
        }
        if let date = Date.from(vesselTime: data[2].last_updated)
        {
            Log_Add("date: \(date) last_updated: \(data[2].last_updated)")
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
    
    //deprecated
    func cellInfoTapped()
    {
        delegate?.ChartViewInfoTapped()
    }
}
