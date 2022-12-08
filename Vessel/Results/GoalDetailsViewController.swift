//
//  GoalDetailsViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 10/21/22.
//

import UIKit

class GoalDetailsViewController: UIViewController
{
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var headerSubtextLabel: UILabel!
    @IBOutlet weak var headerBackgroundView: UIView!
    @IBOutlet weak var testsStackView: UIStackView!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    var goal: Goal!
    var viewModel: ResultsTabViewModel!
    
    static func initWith(goal: Goal.ID, viewModel: ResultsTabViewModel) -> GoalDetailsViewController
    {
        let storyboard = UIStoryboard(name: "Results", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "GoalDetailsViewController") as! GoalDetailsViewController
        
        vc.goal = Goals[goal]!
        vc.viewModel = viewModel
        
        return vc
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        headerImageView.image = UIImage(named: goal.largeImageName)
        headerTitleLabel.text = goal.name.capitalized
        headerSubtextLabel.text = goal.headerText
        headerBackgroundView.backgroundColor = goal.backgroundColor
        subtitleLabel.text = NSLocalizedString("Tests that affect \(goal.name.lowercased())", comment: "Goal details subtitle")
        
        testsStackView.removeAllArrangedSubviews() //remove placeholder view
        if let result = viewModel.selectedResult()
        {
            let filteredReagentResults = result.reagentResults.filter({ Reagent.ID(rawValue: $0.id) != nil })
            let sortedReagentResults = filteredReagentResults.sorted(by: { (firstReagentResult, secondReagentResult) in
                if let firstReagentID = Reagent.ID(rawValue: firstReagentResult.id),
                   let secondReagentID = Reagent.ID(rawValue: secondReagentResult.id),
                   let firstReagent = Reagents[firstReagentID],
                   let secondReagent = Reagents[secondReagentID]
                {
                    return firstReagent.impactFor(goal: goal.id) > secondReagent.impactFor(goal: goal.id)
                }
                return false
            })
                
            for reagentResult in sortedReagentResults
            {
                let impactView = ReagentImpactView()
                let heightConstraint = NSLayoutConstraint(item: impactView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 46)
                impactView.addConstraints([heightConstraint])
                impactView.delegate = self
                if let reagentID = Reagent.ID(rawValue: reagentResult.id)
                {
                    if let value = reagentResult.value
                    {
                        let reagent = Reagents[reagentID]!
                        impactView.reagentNameLabel.text = reagent.name.capitalized
                        let evaluation = reagent.getEvaluation(value: value)
                        impactView.evaluationLabel.text = evaluation.title.capitalized
                        impactView.contentView.backgroundColor = evaluation.color
                        
                        let impact = reagent.impactFor(goal: goal.id)
                        impactView.numDots = impact
                        impactView.reagentId = reagentID.rawValue
                        
                        testsStackView.addArrangedSubview(impactView)
                    }
                }
            }
        }
        else
        {
            //Show generic all-green reagents and impacts
            
            //get list of all reagents
            var reagentIDs: [Reagent.ID] = []
            for reagentID in Reagents
            {
                reagentIDs.append(reagentID.key)
            }
            //sort by impact for this goal
            let sortedReagentIDs = reagentIDs.sorted(by:
            { (firstReagentResult, secondReagentResult) in
                if let firstReagentID = Reagent.ID(rawValue: firstReagentResult.rawValue),
                   let secondReagentID = Reagent.ID(rawValue: secondReagentResult.rawValue),
                   let firstReagent = Reagents[firstReagentID],
                   let secondReagent = Reagents[secondReagentID]
                {
                    return firstReagent.impactFor(goal: goal.id) > secondReagent.impactFor(goal: goal.id)
                }
                else
                {
                    return false
                }
            })
            for reagentID in sortedReagentIDs
            {
                let impactView = ReagentImpactView()
                let heightConstraint = NSLayoutConstraint(item: impactView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 46)
                impactView.addConstraints([heightConstraint])
                impactView.delegate = self
                let reagent = Reagents[reagentID]!
                impactView.reagentNameLabel.text = reagent.name.capitalized
                impactView.evaluationLabel.text = ""
                impactView.contentView.backgroundColor = Constants.vesselGood
                        
                let impact = reagent.impactFor(goal: goal.id)
                impactView.numDots = impact
                impactView.reagentId = reagentID.rawValue
                        
                testsStackView.addArrangedSubview(impactView)
            }
        }
    }
    
    @IBAction func back()
    {
        viewModel = nil
        navigationController?.popViewController(animated: true)
    }
}

extension GoalDetailsViewController: ReagentImpactViewDelegate
{
    func reagentImpactViewTappedImpact()
    {
        let storyboard = UIStoryboard(name: "Results", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ImpactScoreSlideupViewController") as! ImpactScoreSlideupViewController
        self.present(vc, animated: false)
    }
    
    func reagentImpactViewTappedReagent(reagentId: Int)
    {
        if viewModel.numberOfResults() != 0
        {
            let vc = ReagentDetailsViewController.initWith(reagentID: reagentId, viewModel: viewModel, selectedCell: viewModel.selectedResultIndex)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
