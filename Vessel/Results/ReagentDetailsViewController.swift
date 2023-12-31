//
//  ReagentDetailsViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 10/12/22.
//

import UIKit

class ReagentDetailsViewController: UIViewController, UIScrollViewDelegate, ChartViewDataSource, ChartViewDelegate, ScienceStudiesViewDelegate
{
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var chartZoneStackView: UIStackView!
    @IBOutlet weak var chartView: ChartView!
    @IBOutlet weak var reagentImageView: UIImageView!
    @IBOutlet weak var resultTitleLabel: UILabel!
    @IBOutlet weak var resultTextLabel: UILabel!
    @IBOutlet weak var scienceStackview: UIStackView!
    @IBOutlet weak var scienceLabel: UILabel!
    @IBOutlet weak var tipsStackView: UIStackView!
    @IBOutlet weak var infoView: UIView!
    
    var reagentID: Int!
    var viewModel: ResultsTabViewModel!
    
    static func initWith(reagentID: Int, viewModel: ResultsTabViewModel, selectedCell: Int) -> ReagentDetailsViewController
    {
        let storyboard = UIStoryboard(name: "Results", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ReagentDetailsViewController") as! ReagentDetailsViewController
        
        vc.reagentID = reagentID
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad()
    {
        if UserDefaults.standard.bool(forKey: Constants.KEY_PRINT_INIT_DEINIT)
        {
            print("❇️ \(self)")
        }
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
        populateScienceSection()
        populateTipsSection()
    }
    
    deinit
    {
        viewModel = nil
        chartView.delegate = nil
        chartView.dataSource = nil
        if UserDefaults.standard.bool(forKey: Constants.KEY_PRINT_INIT_DEINIT)
        {
            print("❌ \(self)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        //print("ReagentDetailsViewController viewWillAppear()")
        super.viewWillAppear(animated)
        //force the chartView to lay itself out immediately. This allows us to scroll to an initial contentOffset
        chartView.layoutIfNeeded()
        //all UI is performed on main thread. Dispatching the below on the main thread ensures chartView completed its layout before preSelectCell is called.
        DispatchQueue.main.async
        {
            self.chartView.preSelectCell(cellIndex: self.viewModel.selectedResultIndex)
        }
    }
    
    @IBAction func back()
    {
        navigationController?.popViewController(animated: true)
    }
    
    /*func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        //print("Content offset: \(scrollView.contentOffset)")
        //print("Wellness Score: \(titleLabel.frame.origin.y)")
    }*/
    
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
        //return 0 if viewModel is nil. This could happen if user dismisses ReagentDetailsViewController WHILE chart is still scrolling. Fixes a crash bug.
        return viewModel?.numberOfResults() ?? 0
    }
    
    func chartViewData(forIndex index: Int) -> (result: Result, isSelected: Bool)
    {
        return viewModel.resultForIndex(i: index)
    }
    
    func chartViewWhichCellSelected(cellIndex: Int) -> Bool
    {
        return cellIndex == viewModel.selectedResultIndex
    }
    
    //deprecated
    func ChartViewInfoTapped()
    {
    }
    
    func chartViewCellSelected(cellIndex: Int)
    {
        viewModel.selectResult(index: cellIndex)
        //populate the infoView title and description text
        let result = viewModel.resultForIndex(i: cellIndex).result
        let reagent_ID = Reagent.ID(rawValue: reagentID)
        if let reagentResult = result.getResult(id: reagent_ID!), let value = reagentResult.value
        {
            let reagent = Reagent.fromID(id: reagentID)
            if let bucketIndex = reagent.getBucketIndex(value: value)
            {
                let bucket = reagent.buckets[bucketIndex]
                resultTitleLabel.text = bucket.hint.title
                resultTextLabel.text = bucket.hint.description
                infoView.backgroundColor = bucket.evaluation.color
                if reagent.name == "Ketones" && Contact.main()!.isOnDiet(.KETO)
                {
                    resultTextLabel.text = bucket.hint.variation
                }
            }
            else
            {
                resultNotAvailable()
            }
        }
        else
        {
            resultNotAvailable()
        }
    }
    
    func resultNotAvailable()
    {
        resultTitleLabel.text = NSLocalizedString("No Result", comment: "")
        resultTextLabel.text = NSLocalizedString("There is no data for this day.", comment: "")
    }
    
    func populateScienceSection()
    {
        let reagent = Reagent.fromID(id: reagentID)
        let string = String(format: NSLocalizedString("Below are peer-reviewed scientific studies on how %@ might affect you.", comment: ""), reagent.name.capitalized)
        scienceLabel.text = string
        scienceStackview.removeAllArrangedSubviews() //remove placeholder
        
        let sortedGoalSources = reagent.goalSources.sorted(by: { $0.sources.count > $1.sources.count })
        for item in sortedGoalSources
        {
            let count = item.sources.count
            var studiesView: ScienceStudiesView!
            
            if count == 1
            {
                studiesView = ScienceStudiesView(goalID: item.goalID, studies: NSLocalizedString("1 study", comment: ""))
            }
            else
            {
                studiesView = ScienceStudiesView(goalID: item.goalID, studies: String(format: NSLocalizedString("%i studies", comment: "number of studies"), count))
            }
            
            let heightConstraint = NSLayoutConstraint(item: studiesView!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 60.0)
            studiesView.addConstraints([heightConstraint])
            studiesView.delegate = self
            scienceStackview.addArrangedSubview(studiesView)
        }
    }
    
    func populateTipsSection()
    {
        let reagent = Reagent.fromID(id: reagentID)
        tipsStackView.removeAllArrangedSubviews() //remove placeholder
        
        for tip in reagent.moreInfo
        {
            let view = ExpandableContentView(title: tip.title, info: tip.description.makeAttributedString())
            tipsStackView.addArrangedSubview(view)
        }
    }
    
    @IBAction func chatWithHealthCoach()
    {
        LiveChatManager.shared.navigateToLiveChat(in: self)
    }
    
    @IBAction func customerSupport()
    {
        ZendeskManager.shared.navigateToChatWithSupport(in: self)
    }
    //MARK: - ScienceStudiesViewDelegates
    func didSelectStudy(buttonID: Int)
    {
        let vc = StudiesViewController.initWith(reagentID: Reagent.ID(rawValue: reagentID)!, goalID: Goal.ID(rawValue: buttonID)!)
        navigationController?.pushViewController(vc, animated: true)
    }
}
