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
    
    var reagentID: Int!
    var viewModel: ResultsTabViewModel!
    
    override func viewDidLoad()
    {
        print("VIEW DID LOAD")
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
        //populate the infoView title and description text
        let result = viewModel.resultForIndex(i: cellIndex).result
        let reagent_ID = Reagent.ID(rawValue: reagentID)
        if let reagentResult = result.getResult(id: reagent_ID!)
        {
            let reagent = Reagent.fromID(id: reagentID)
            if let bucketIndex = reagent.getBucketIndex(value: reagentResult.value)
            {
                let bucket = reagent.buckets[bucketIndex]
                resultTitleLabel.text = bucket.hint.title
                resultTextLabel.text = bucket.hint.description
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
        
        for item in reagent.goalSources
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
    
    //MARK: - ScienceStudiesViewDelegates
    func didSelectStudy(buttonID: Int)
    {
        let storyboard = UIStoryboard(name: "Results", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "StudiesViewController") as! StudiesViewController
        vc.goalID = Goal.ID(rawValue: buttonID)
        vc.reagentID = Reagent.ID(rawValue: reagentID)
        navigationController?.pushViewController(vc, animated: true)
    }
}
