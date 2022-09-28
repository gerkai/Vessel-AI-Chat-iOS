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
    @IBOutlet weak var testsGoalsView: TestsGoalsView!
    
    override func viewDidLoad()
    {
        chartView.dataSource = self
        chartView.delegate = self
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        let numResults = viewModel.numberOfResults()
        if numResults == 0
        {
            lockoutView.isHidden = false
        }
        else
        {
            lockoutView.isHidden = true
            if initialLoad
            {
                testsGoalsView.setupReagents(forResult: viewModel.resultForIndex(i: numResults - 1))
                testsGoalsView.setupGoals()
            }
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
        return viewModel.numberOfResults()
    }
    
    func chartViewData(forIndex index: Int) -> Result
    {
        return viewModel.resultForIndex(i: index)
    }
    
    func ChartViewInfoTapped()
    {
        let storyboard = UIStoryboard(name: "Results", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "WellnessScoreViewController") as! WellnessScoreViewController
        vc.initWithViewModel(vm: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func chartViewCellSelected(cellIndex: Int)
    {
        viewModel.selectResult(index: cellIndex)
        testsGoalsView.setupReagents(forResult: viewModel.resultForIndex(i: cellIndex))
    }
    
    @IBAction func takeATest()
    {
        mainTabBarController?.vesselButtonPressed()
    }
    
    @IBAction func talkToANutritionist()
    {
        print("TALK TO A NUTRITIONIST")
    }
    
    @IBAction func customerSupport()
    {
        print("CUSTOMER SUPPORT")
    }
}
