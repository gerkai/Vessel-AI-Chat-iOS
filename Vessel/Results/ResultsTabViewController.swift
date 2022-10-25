//
//  ResultsTabViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 9/24/22.
//

import UIKit

class ResultsTabViewController: UIViewController, ChartViewDataSource, ChartViewDelegate, TestsGoalsViewDelegate
{
    @IBOutlet weak var chartView: ChartView!
    var initialLoad = true
    var viewModel = ResultsTabViewModel()
    @IBOutlet weak var lockoutView: UIView!
    @IBOutlet weak var testsGoalsView: TestsGoalsView!
    let defaultSelectedReagent = Reagent.ID.MAGNESIUM
    
    override func viewDidLoad()
    {
        chartView.dataSource = self
        chartView.delegate = self
        testsGoalsView.delegate = self
        super.viewDidLoad()
        //get notified when new result comes in from After Test Flow
        NotificationCenter.default.addObserver(self, selector: #selector(self.dataUpdated(_:)), name: .newDataArrived, object: nil)
        //get notified if food preferences changes (specifically ketones which changes color of ketone tile)
        NotificationCenter.default.addObserver(self, selector: #selector(self.foodPrefsChanged(_:)), name: .foodPreferencesChangedNotification, object: nil)
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        //show lockout view if there are no test results to display
        //print("Results: viewWillAppear")
        viewModel.refresh()
        if initialLoad
        {
            testsGoalsView.setupGoals()
        }
        handleLockoutView()
        let numResults = viewModel.numberOfResults()
        if numResults != 0 && initialLoad
        {
            testsGoalsView.setupReagents(forResult: viewModel.selectedResult(), selectedReagentID: .MAGNESIUM)
        }
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        if initialLoad
        {
            initialLoad = false
        }
        else
        {
            chartView.refresh()
        }
    }
    
    @objc func foodPrefsChanged(_ notification: NSNotification)
    {
        refresh()
    }
    
    @objc func dataUpdated(_ notification: NSNotification)
    {
        //print("Results: Data Updated")
        if let type = notification.userInfo?["objectType"] as? String
        {
            //if the new data is a Result then refresh the chart and tests/goals
            if type == String(describing: Result.self)
            {
                //print("It's a Result. Refreshing...")
                refresh()
                handleLockoutView()
            }
        }
    }
    
    func handleLockoutView()
    {
        let numResults = viewModel.numberOfResults()
        if numResults == 0
        {
            //print("0 results: Showing lockoutView")
            lockoutView.isHidden = false
        }
        else
        {
            //print("\(numResults) results. Hiding lockoutView")
            lockoutView.isHidden = true
        }
    }
    
    func refresh()
    {
        //print("ResultTabVC refresh()")
        viewModel.refresh() //loads latest results
        chartView.refresh() //reloads collectionView. Selects last cell.
        let numResults = viewModel.numberOfResults()
        if numResults != 0
        {
            testsGoalsView.refresh(result: viewModel.resultForIndex(i: numResults - 1).result, selectedReagentID: defaultSelectedReagent)
        }
    }
    
    //Mark: - ChartViewDataSource
    func chartViewNumDataPoints() -> Int
    {
        return viewModel.numberOfResults()
    }
    
    func chartViewData(forIndex index: Int) -> (result: Result, isSelected: Bool)
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
        testsGoalsView.setupReagents(forResult: viewModel.resultForIndex(i: cellIndex).result, selectedReagentID: defaultSelectedReagent)
    }
    
    func chartViewWhichCellSelected(cellIndex: Int) -> Bool
    {
        return cellIndex == viewModel.selectedResultIndex
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
        //ObjectStore.shared.testFetch() //TODO: remove this test code.
    }
    
    //MARK: - TestsGoalsViewDelegates
    func learnMoreAboutGoal(id: Int)
    {
        let goalID = Goal.ID(rawValue: id)!
        let vc = GoalDetailsViewController.initWith(goal: goalID, viewModel: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func learnMoreAboutReagent(id: Int)
    {
        let vc = ReagentDetailsViewController.initWith(reagentID: id, viewModel: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
}
