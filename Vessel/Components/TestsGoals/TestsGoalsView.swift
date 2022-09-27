//
//  TestsGoalsView.swift
//  ChartView
//
//  Created by Carson Whitsett on 9/25/22.
//

import UIKit

class TestsGoalsView: UIView, GoalLearnMoreTileViewDelegate, ReagentLearnMoreTileViewDelegate
{
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var testsStackView: UIStackView!
    @IBOutlet weak var goalsStackView: UIStackView!
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit()
    {
        let xibName = String(describing: type(of: self))
        
        let bundle = Bundle(for: TestsGoalsView.self)
        bundle.loadNibNamed(xibName, owner: self, options: nil)
        contentView.fixInView(self)
        self.backgroundColor = .clear
        
        testsStackView.removeAllArrangedSubviews()
        goalsStackView.removeAllArrangedSubviews()
    }
    
    func setupReagents(forResult result: Result)
    {
        for reagentResult in result.reagents
        {
            if let reagentID = Reagent.ID(rawValue: reagentResult.id)
            {
                let reagentView = ReagentLearnMoreTileView()
                reagentView.tag = reagentID.rawValue
                let evaluation = Reagent.evaluation(id: reagentID, value: reagentResult.value)
                reagentView.contentView.backgroundColor = evaluation.color
                reagentView.titleLabel.text = Reagents[reagentID]?.name
                reagentView.subtextLabel.text = evaluation.title.capitalized
                reagentView.imageView.image = UIImage(named: Reagents[reagentID]!.imageName)
                reagentView.delegate = self
                testsStackView.addArrangedSubview(reagentView)
            }
        }
    }
    
    func setupGoals()
    {
        for goalID in Goal.ID.allCases
        {
            let goal = Goals[goalID]
            let goalView = GoalLearnMoreTileView()
            goalView.titleLabel.text = goal?.name.capitalized
            goalView.imageView.image = UIImage(named: goal!.imageName)
            goalView.numDots = 0
            goalView.tag = goalID.rawValue
            goalView.delegate = self
            goalsStackView.addArrangedSubview(goalView)
        }
    }
    
    func didSelectGoal(id: Int, learnMore: Bool)
    {
        if learnMore
        {
            print("LEARN MORE ABOUT GOAL \(id)")
        }
        else
        {
            //unselect all other goals
            for view in goalsStackView.arrangedSubviews
            {
                if let goalView = view as? GoalLearnMoreTileView
                {
                    goalView.numDots = 0
                    if goalView.tag != id
                    {
                        goalView.isSelected = false
                    }
                }
            }
            
            //unselect all other tests
            for view in testsStackView.arrangedSubviews
            {
                if let testView = view as? ReagentLearnMoreTileView
                {
                    testView.isSelected = false
                }
            }
        }
        UIView.animate(withDuration: 0.1)
        {
            self.superview?.layoutIfNeeded()
        }
    }
    
    func didSelectReagent(id: Int, learnMore: Bool)
    {
        if learnMore
        {
            print("LEARN MORE ABOUT REAGENT \(id)")
        }
        else
        {
            //unselect all other reagents
            for view in self.testsStackView.arrangedSubviews
            {
                if let testView = view as? ReagentLearnMoreTileView
                {
                    if testView.tag != id
                    {
                        testView.isSelected = false
                    }
                }
            }
            
            //set the impact dots for the goals associated with this reagent
            if let reagentID = Reagent.ID(rawValue: id)
            {
                let reagent = Reagents[reagentID]
                
                for view in self.goalsStackView.arrangedSubviews
                {
                    if let goalView = view as? GoalLearnMoreTileView
                    {
                        let impact = reagent!.impactFor(goal: goalView.tag)
                        goalView.numDots = impact
                        goalView.isSelected = false
                    }
                }
            }
        }
        UIView.animate(withDuration: 0.1)
        {
            self.superview?.layoutIfNeeded()
        }
    }
}
