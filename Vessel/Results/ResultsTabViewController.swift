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
        NotificationCenter.default.addObserver(self, selector: #selector(self.dataUpdated(_:)), name: .newDataFromServer, object: nil)
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
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
            }
        }
        testsGoalsView.setupGoals()
        
        //let result = viewModel.resultForIndex(i: 0)
        //let dict = ["objectType": String(describing: type(of: result.self))]
        //NotificationCenter.default.post(name: .newDataFromServer, object: nil, userInfo: dict)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        if initialLoad
        {
            initialLoad = false
            chartView.selectLastCell()
            if viewModel.numberOfResults() != 0
            {
                testsGoalsView.selectFirstReagent()
            }
        }
    }
    
    @objc func dataUpdated(_ notification: NSNotification)
    {
        if let type = notification.userInfo?["objectType"] as? String
        {
            //if the new data is a Result then refresh the chart and tests/goals
            if type == String(describing: Result.self)
            {
                viewModel.refresh()
                chartView.refresh()
                let numResults = viewModel.numberOfResults()
                testsGoalsView.setupReagents(forResult: viewModel.resultForIndex(i: numResults - 1))
            }
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
        if viewModel.numberOfResults() != 0
        {
            viewModel.selectResult(index: cellIndex)
            testsGoalsView.setupReagents(forResult: viewModel.resultForIndex(i: cellIndex))
        }
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
