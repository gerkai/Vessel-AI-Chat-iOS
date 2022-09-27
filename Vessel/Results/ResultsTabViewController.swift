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
    var viewModel = ResultsTabViewModel()
    @IBOutlet weak var lockoutView: UIView!
    
    override func viewDidLoad()
    {
        chartView.dataSource = self
        chartView.delegate = self
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        if viewModel.dataPoints.isEmpty
        {
            lockoutView.isHidden = false
        }
        else
        {
            lockoutView.isHidden = true
        }
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
        return viewModel.dataPoints.count
    }
    
    func chartViewData(forIndex index: Int) -> ChartViewDataPoint
    {
        return viewModel.dataPoints[index]
    }
    
    func ChartViewInfoTapped()
    {
        let storyboard = UIStoryboard(name: "Results", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "WellnessScoreViewController") as! WellnessScoreViewController
        vc.initWithViewModel(vm: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func takeATest()
    {
        mainTabBarController?.vesselButtonPressed()
    }
}
