//
//  ResultsTabViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 9/24/22.
//

import UIKit

class ResultsTabViewController: UIViewController, ChartViewDataSource, ChartViewDelegate, TestsGoalsViewDelegate, UITextViewDelegate
{
    @IBOutlet weak var chartView: ChartView!
    var initialLoad = true
    var viewModel = ResultsTabViewModel()
    @IBOutlet weak var lockoutView: UIView!
    @IBOutlet weak var testsGoalsView: TestsGoalsView!
    @IBOutlet weak var textView: UITextView!
    
    var defaultSelectedReagent = Reagent.ID.MAGNESIUM
    
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
        textView.attributedText = viewModel.wellnessText()
        textView.delegate = self
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool
    {
        let storyboard = UIStoryboard(name: "Results", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "WellnessScoreViewController") as! WellnessScoreViewController
        vc.initWithViewModel(vm: viewModel)
        navigationController?.pushViewController(vc, animated: true)
        return false
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        //show lockout view if there are no test results to display
        
        if initialLoad
        {
            viewModel.refresh()
            testsGoalsView.setupGoals()
        }
        
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
                testsGoalsView.setupReagents(forResult: viewModel.selectedResult()!, selectedReagentID: .MAGNESIUM)
            }
            guard let contact = Contact.main() else { return }
            
            if contact.flags & Constants.SAW_WELLNESS_POPUP == 0
            {
                let vc = WellnessPopupViewController.createWith(viewModel: viewModel)
                self.present(vc, animated: false)
                
                contact.flags |= Constants.SAW_WELLNESS_POPUP
                ObjectStore.shared.ClientSave(contact)
            }
            else if contact.flags & Constants.SAW_REAGENT_POPUP == 0,
                        let selectedTile = testsGoalsView.selectedReagentTile()
            {
                let vc = ReagentPopupViewController.createWith(reagentTile: selectedTile)
                self.present(vc, animated: false)
                
                contact.flags |= Constants.SAW_REAGENT_POPUP
                ObjectStore.shared.ClientSave(contact)
            }
            else if contact.flags & Constants.SAW_COACH_POPUP == 0
            {
                let vc = CoachPopupViewController.create()
                self.present(vc, animated: false)
                
                contact.flags |= Constants.SAW_COACH_POPUP
                ObjectStore.shared.ClientSave(contact)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        if initialLoad
        {
            initialLoad = false
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
            Log_Add("Results Page: dataUpdated: \(type)")
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
    
    //deprecated
    //info icon on chartView was hidden. If it stays that way, we can remove this infoTapped functionality from the app
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
        LiveChatManager.shared.navigateToLiveChat(in: self)
    }
    
    @IBAction func customerSupport()
    {
        ZendeskManager.shared.navigateToChatWithSupport(in: self)
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
        let vc = ReagentDetailsViewController.initWith(reagentID: id, viewModel: viewModel, selectedCell: chartView.selectedCell)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func reagentSelected(id: Int)
    {
        defaultSelectedReagent = Reagent.ID(rawValue: id)!
    }
}
