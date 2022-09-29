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
    @IBOutlet weak var curvyLineView: CurvyLineView!
    
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
    
    func selectFirstReagent()
    {
        if let reagentView = testsStackView.arrangedSubviews[0] as? ReagentLearnMoreTileView
        {
            reagentView.tapped()
        }
    }
    
    func setupReagents(forResult result: Result)
    {
        testsStackView.removeAllArrangedSubviews()
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
        goalsStackView.removeAllArrangedSubviews()
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
        var selectedGoalView: UIView?
        
        if learnMore
        {
            print("LEARN MORE ABOUT GOAL \(id)")
        }
        else
        {
            curvyLineView.clearCurvyLines()
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
                    else
                    {
                        selectedGoalView = goalView
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
            self.parentViewController?.view.layoutIfNeeded()
        }
        completion:
        { done in
            //draw the curvy lines
            if selectedGoalView != nil
            {
                let connectedReagentIDs = Reagent.reagentsFor(goal: id, withImpactAtLease: 1)
                
                for view in self.testsStackView.arrangedSubviews
                {
                    if let testView = view as? ReagentLearnMoreTileView
                    {
                        if connectedReagentIDs.contains(testView.tag)
                        {
                            //add curvy lines from goal to reagents that have an impact > 0
                            if let reagentView = self.reagentViewWithID(id: testView.tag), let goalView = selectedGoalView
                            {
                                let startPoint = CGPoint(x: 0.0, y: goalView.frame.height / 2)
                                let endPoint = CGPoint(x: reagentView.frame.width, y: reagentView.frame.height / 2)
                                let convertedStartPoint = goalView.convert(startPoint, to: self.curvyLineView)
                                let convertedEndPoint = reagentView.convert(endPoint, to: self.curvyLineView)
                                
                                let curvyLine = CurvyLine(startPoint: convertedStartPoint, endPoint: convertedEndPoint, intensity: 50.0, offset: 0.0)
                                self.curvyLineView.addCurvyLine(line: curvyLine)
                            }
                        }
                    }
                }
                self.curvyLineView.layoutSubviews()
            }
        }
    }
    
    func didSelectReagent(id: Int, learnMore: Bool)
    {
        var selectedView: UIView?
        var targetViews: [UIView] = []
        
        if learnMore
        {
            print("LEARN MORE ABOUT REAGENT \(id)")
        }
        else
        {
            curvyLineView.clearCurvyLines()
            //unselect all other reagents
            for view in self.testsStackView.arrangedSubviews
            {
                if let testView = view as? ReagentLearnMoreTileView
                {
                    if testView.tag != id
                    {
                        testView.isSelected = false
                    }
                    else
                    {
                        selectedView = testView
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
                        
                        //add curvy lines from reagent to goals
                        if impact != 0
                        {
                            targetViews.append(goalView)
                        }
                    }
                }
            }
        }
        UIView.animate(withDuration: 0.1)
        {
            //we can't just tell the stackView to layout as it will cause superviews to jump around.
            //If you ask the superview to layout, then the view above that jumps around.
            //solution was to ask the parent viewController's view to layout. Now it's smooth as butter.
            self.parentViewController?.view.layoutIfNeeded()
        }
        completion:
        { done in
            //add curvy lines from reagent to goals
            if selectedView != nil
            {
                for target in targetViews
                {
                    let startPoint = CGPoint(x: selectedView!.frame.width, y: selectedView!.frame.height / 2)
                    let endPoint = CGPoint(x: 0.0, y: target.frame.height / 2)
                    let convertedStartPoint = selectedView!.convert(startPoint, to: self.curvyLineView)
                    let convertedEndPoint = target.convert(endPoint, to: self.curvyLineView)
                    
                    let curvyLine = CurvyLine(startPoint: convertedStartPoint, endPoint: convertedEndPoint, intensity: 50.0, offset: 0.0)
                    self.curvyLineView.addCurvyLine(line: curvyLine)
                }
                self.curvyLineView.layoutSubviews()
            }
        }
    }
                                                      
    func reagentViewWithID(id: Int) -> UIView?
    {
        for view in testsStackView.arrangedSubviews
        {
            if view.tag == id
            {
                return view
            }
        }
        return nil
    }
}
