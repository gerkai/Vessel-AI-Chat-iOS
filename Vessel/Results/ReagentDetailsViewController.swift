//
//  ReagentDetailsViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 10/12/22.
//

import UIKit

class ReagentDetailsViewController: UIViewController, UIScrollViewDelegate, ChartViewDataSource, ChartViewDelegate
{
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var chartZoneStackView: UIStackView!
    @IBOutlet weak var chartView: ChartView!
    @IBOutlet weak var reagentImageView: UIImageView!
    
    var reagentID: Int!
    var viewModel: ResultsTabViewModel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        scrollView.delegate = self
        chartView.delegate = self
        chartView.dataSource = self
        chartView.showScaleOnSelection = false
        chartView.chartType = .reagentDetails
        chartView.reagentID = reagentID
        configureChartZone()
        let reagent = Reagent.fromID(id: reagentID)
        titleLabel.text = reagent.name
        reagentImageView.image = UIImage(named: reagent.imageName + "-top-right")
    }
    
    @IBAction func back()
    {
        navigationController?.popViewController(animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        //print("Content offset: \(scrollView.contentOffset)")
        print("Wellness Score: \(titleLabel.frame.origin.y)")
    }
    
    func configureChartZone()
    {
        //assumes stackView starts with the maximum number of ChartZone subviews
        let reagent = Reagent.fromID(id: reagentID)
        let numBuckets = reagent.buckets.count
        let numViews = chartZoneStackView.arrangedSubviews.count
        
        //only show as many zones as there are buckets
        if numBuckets < numViews
        {
            for i in numBuckets ..< numViews
            {
                chartZoneStackView.arrangedSubviews[i].isHidden = true
            }
        }
        for i in 0 ..< numBuckets
        {
            let evaluation = reagent.buckets[i].evaluation
            let view = chartZoneStackView.arrangedSubviews[i] as! ChartZone
            view.contentView.backgroundColor = evaluation.color
            view.titleLabel.text = evaluation.title.capitalized
        }
    }
    
    //MARK: - ChartView datasource & delegates
    func chartViewNumDataPoints() -> Int
    {
        return viewModel.numberOfResults()
    }
    
    func chartViewData(forIndex index: Int) -> (result: Result, isSelected: Bool)
    {
        return viewModel.resultForIndex(i: index)
    }
    
    func chartViewWhichCellSelected(cellIndex: Int) -> Bool
    {
        return cellIndex == viewModel.selectedResultIndex
    }
    
    func ChartViewInfoTapped()
    {
    }
    
    func chartViewCellSelected(cellIndex: Int)
    {
    }
}
