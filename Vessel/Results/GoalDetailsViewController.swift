//
//  GoalDetailsViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 10/21/22.
//

import UIKit

class GoalDetailsViewController: UIViewController, ReagentImpactViewDelegate
{
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var headerSubtextLabel: UILabel!
    @IBOutlet weak var headerBackgroundView: UIView!
    @IBOutlet weak var testsStackView: UIStackView!
    
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
        
        testsStackView.removeAllArrangedSubviews() //remove placeholder view
        let result = viewModel.selectedResult()
        
        for reagentResult in result.reagentResults
        {
            let impactView = ReagentImpactView()
            let heightConstraint = NSLayoutConstraint(item: impactView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 46)
            impactView.addConstraints([heightConstraint])
            impactView.delegate = self
            if let reagentID = Reagent.ID(rawValue: reagentResult.id)
            {
                let reagent = Reagents[reagentID]!
                impactView.reagentNameLabel.text = reagent.name.capitalized
                let evaluation = reagent.getEvaluation(value: reagentResult.value)
                impactView.evaluationLabel.text = evaluation.title.capitalized
                impactView.contentView.backgroundColor = evaluation.color
                
                let impact = reagent.impactFor(goal: goal.id)
                impactView.numDots = impact
                
                testsStackView.addArrangedSubview(impactView)
            }
        }
    }
    
    @IBAction func back()
    {
        viewModel = nil
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - ReagentImpactView delegates
    func reagentImpactViewTapped()
    {
        print("Reagent Impact View tapped")
    }
}
