//
//  ReagentDetailsViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 10/12/22.
//

import UIKit

class ReagentDetailsViewController: UIViewController, UIScrollViewDelegate
{
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var chartZoneStackView: UIStackView!
    var reagentID: Int!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        scrollView.delegate = self
        configureChartZone()
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
        let reagent = Reagents[Reagent.ID(rawValue: reagentID)!]!
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
}
