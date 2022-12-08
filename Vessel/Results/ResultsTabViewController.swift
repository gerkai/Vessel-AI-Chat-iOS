//
//  ResultsTabViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 9/24/22.
//

import UIKit

class ResultsTabViewController: UIViewController, ChartViewDataSource, ChartViewDelegate, TestsGoalsViewDelegate, UITextViewDelegate, ReagentDetailsViewControllerDelegate
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
        setupTextView()
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupTextView()
    {
        //apply text and make the "learn more" portion of it underlined and tappable
        let message = NSLocalizedString("Your wellness score is a combination of all your results. Learn more", comment: "")
        let interactiveText = NSLocalizedString("Learn more", comment: "")
        let linkRange = message.range(of: interactiveText)
        let linkNSRange = NSRange(linkRange!, in: message)
        let font = Constants.FontBodyAlt14
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 0.5 * font.lineHeight
        let myAttribute = [ NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor.init(hex: "555553"),
                            NSAttributedString.Key.paragraphStyle: paragraphStyle]
        
        let attributedString = NSMutableAttributedString(string: message, attributes: myAttribute)
        attributedString.addAttribute(.link, value: "https://www.vesselhealth.com", range: linkNSRange)
        attributedString.underline(term: interactiveText)
        attributedString.font(term: interactiveText, font: Constants.FontLearnMore10)
        textView.attributedText = attributedString
        textView.delegate = self
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
        //print("Results: viewWillAppear")
        
        if initialLoad
        {
            viewModel.refresh()
            testsGoalsView.setupGoals()
        }
        handleLockoutView()
        let numResults = viewModel.numberOfResults()
        if numResults != 0 && initialLoad
        {
            testsGoalsView.setupReagents(forResult: viewModel.selectedResult()!, selectedReagentID: .MAGNESIUM)
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
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func reagentSelected(id: Int)
    {
        defaultSelectedReagent = Reagent.ID(rawValue: id)!
    }
    
    //MARK: -- reagentDetailsViewController delegates
    func reagentDetailsChartCellSelected(cellIndex: Int)
    {
        chartView.preSelectCell(cellIndex: cellIndex)
    }
}
