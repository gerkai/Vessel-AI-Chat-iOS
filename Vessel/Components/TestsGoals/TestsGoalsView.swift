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
    var isAnimated = false
    let CURVY_LINE_TILE_SPACE = CGFloat(7.0) //space between curvy line and tile
    
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
        
        //remove placeholder views put there by XIB file
        testsStackView.removeAllArrangedSubviews()
        goalsStackView.removeAllArrangedSubviews()
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        contentView.layoutIfNeeded()
        if isAnimated == false
        {
            drawLines()
        }
    }
    
    func refresh(result: Result, selectedReagentID: Reagent.ID)
    {
        setupReagents(forResult: result, selectedReagentID: selectedReagentID)
        if let reagentView = testsStackView.arrangedSubviews[0] as? ReagentLearnMoreTileView
        {
            reagentView.isSelected = true
        }
    }
    
    func setupReagents(forResult result: Result, selectedReagentID: Reagent.ID)
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
                if reagentID == selectedReagentID
                {
                    reagentView.isSelected = true
                }
                testsStackView.addArrangedSubview(reagentView)
            }
        }
        
        //unselect all goals and set the impact dots for the goals associated with this reagent
        let reagent = Reagents[selectedReagentID]
        
        for view in self.goalsStackView.arrangedSubviews
        {
            if let goalView = view as? GoalLearnMoreTileView
            {
                let impact = reagent!.impactFor(goal: goalView.tag)
                goalView.numDots = impact
                goalView.isSelected = false
            }
        }
        //immediately draw curvy lines from selected reagent to goals
        isAnimated = false
        setNeedsLayout()
    }
    
    func drawLines()
    {
        var selectedIsGoal = false
        var selectedView: UIView?
        var targetViews: [UIView] = []
        
        curvyLineView.clearCurvyLines()
        
        //find selected view
        for view in testsStackView.arrangedSubviews
        {
            if let testView = view as? ReagentLearnMoreTileView
            {
                selectedView = testView
                break
            }
        }
        if selectedView == nil
        {
            for view in goalsStackView.arrangedSubviews
            {
                if let testView = view as? GoalLearnMoreTileView
                {
                    selectedView = testView
                    selectedIsGoal = true
                    break
                }
            }
        }
        
        if selectedView != nil
        {
            //build target views
            if selectedIsGoal
            {
                let connectedReagentIDs = Reagent.reagentsFor(goal: selectedView!.tag, withImpactAtLease: 1)
                for view in self.testsStackView.arrangedSubviews
                {
                    if let testView = view as? ReagentLearnMoreTileView
                    {
                        if connectedReagentIDs.contains(testView.tag)
                        {
                            targetViews.append(testView)
                        }
                    }
                }
            }
            else
            {
                if let reagentID = Reagent.ID(rawValue: selectedView!.tag)
                {
                    let reagent = Reagents[reagentID]
                    
                    for view in self.goalsStackView.arrangedSubviews
                    {
                        if let goalView = view as? GoalLearnMoreTileView
                        {
                            let impact = reagent!.impactFor(goal: goalView.tag)
                            
                            //add curvy lines from reagent to goals
                            if impact != 0
                            {
                                targetViews.append(goalView)
                            }
                        }
                    }
                }
            }
            
            //draw curvy lines
            showSelectionAndCurvyLines(selectedView: selectedView, targetViews: targetViews, testSelected: !selectedIsGoal)
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
    
    func didSelectGoal(id: Int, learnMore: Bool, animated: Bool)
    {
        isAnimated = animated
        var selectedGoalView: UIView?
        var targetViews: [UIView] = []
        
        if learnMore
        {
            print("LEARN MORE ABOUT GOAL \(id)")
        }
        else
        {
            curvyLineView.clearCurvyLines()
            curvyLineView.animated = animated
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
                            targetViews.append(testView)
                        }
                    }
                }
                if animated
                {
                    self.animateSelectionAndCurvyLines(selectedView: selectedGoalView, targetViews: targetViews, testSelected: false)
                }
                else
                {
                    self.showSelectionAndCurvyLines(selectedView: selectedGoalView, targetViews: targetViews, testSelected: false)
                }
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
    
    //MARK: - ReagentLearnMoreTileView delegates
    func userDidSelectReagent(id: Int, learnMore: Bool, animated: Bool)
    {
        isAnimated = animated
        var selectedView: UIView?
        var targetViews: [UIView] = []
        if learnMore
        {
            print("LEARN MORE ABOUT REAGENT \(id)")
        }
        else
        {
            curvyLineView.clearCurvyLines()
            curvyLineView.animated = animated
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
            if animated
            {
                animateSelectionAndCurvyLines(selectedView: selectedView, targetViews: targetViews, testSelected: true)
            }
            else
            {
                showSelectionAndCurvyLines(selectedView: selectedView, targetViews: targetViews, testSelected: true)
            }
        }
    }
    
    func animateSelectionAndCurvyLines(selectedView: UIView?, targetViews: [UIView], testSelected: Bool)
    {
        UIView.animate(withDuration: 0.1)
        {
            //we can't just tell the stackView to layout as it will cause superviews to jump around.
            //If you ask the superview to layout, then the view above that jumps around.
            //solution was to ask the parent viewController's view to layout. Now it's smooth as butter. But if anything changes in any of the other subviews, those changes will also be animated.
            self.parentViewController?.view.layoutIfNeeded()
        }
        completion:
        { done in
            //add curvy lines from reagent to goals
            if selectedView != nil
            {
                for target in targetViews
                {
                    if testSelected
                    {
                        let startPoint = CGPoint(x: selectedView!.frame.width + self.CURVY_LINE_TILE_SPACE, y: selectedView!.frame.height / 2)
                        let endPoint = CGPoint(x: -self.CURVY_LINE_TILE_SPACE, y: target.frame.height / 2)
                        let convertedStartPoint = selectedView!.convert(startPoint, to: self.curvyLineView)
                        let convertedEndPoint = target.convert(endPoint, to: self.curvyLineView)
                        
                        let curvyLine = CurvyLine(startPoint: convertedStartPoint, endPoint: convertedEndPoint, intensity: 50.0, offset: 0.0)
                        self.curvyLineView.addCurvyLine(line: curvyLine)
                    }
                    else
                    {
                        let startPoint = CGPoint(x: -self.CURVY_LINE_TILE_SPACE, y: selectedView!.frame.height / 2)
                        let endPoint = CGPoint(x: target.frame.width + self.CURVY_LINE_TILE_SPACE, y: target.frame.height / 2)
                        let convertedStartPoint = selectedView!.convert(startPoint, to: self.curvyLineView)
                        let convertedEndPoint = target.convert(endPoint, to: self.curvyLineView)
                        
                        let curvyLine = CurvyLine(startPoint: convertedStartPoint, endPoint: convertedEndPoint, intensity: 50.0, offset: 0.0)
                        self.curvyLineView.addCurvyLine(line: curvyLine)
                    }
                }
                self.curvyLineView.animated = true
                self.curvyLineView.layoutSubviews()
            }
        }
    }
    
    func showSelectionAndCurvyLines(selectedView: UIView?, targetViews: [UIView], testSelected: Bool)
    {
        //add curvy lines from reagent to goals
        if selectedView != nil
        {
            for target in targetViews
            {
                if testSelected
                {
                    let startPoint = CGPoint(x: selectedView!.frame.width + self.CURVY_LINE_TILE_SPACE, y: selectedView!.frame.height / 2)
                    let endPoint = CGPoint(x: -self.CURVY_LINE_TILE_SPACE, y: target.frame.height / 2)
                    let convertedStartPoint = selectedView!.convert(startPoint, to: self.curvyLineView)
                    let convertedEndPoint = target.convert(endPoint, to: self.curvyLineView)
                    
                    let curvyLine = CurvyLine(startPoint: convertedStartPoint, endPoint: convertedEndPoint, intensity: 50.0, offset: 0.0)
                    self.curvyLineView.addCurvyLine(line: curvyLine)
                }
                else
                {
                    let startPoint = CGPoint(x: -self.CURVY_LINE_TILE_SPACE, y: selectedView!.frame.height / 2)
                    let endPoint = CGPoint(x: target.frame.width + self.CURVY_LINE_TILE_SPACE, y: target.frame.height / 2)
                    let convertedStartPoint = selectedView!.convert(startPoint, to: self.curvyLineView)
                    let convertedEndPoint = target.convert(endPoint, to: self.curvyLineView)
                    
                    let curvyLine = CurvyLine(startPoint: convertedStartPoint, endPoint: convertedEndPoint, intensity: 50.0, offset: 0.0)
                    self.curvyLineView.addCurvyLine(line: curvyLine)
                }
            }
            self.curvyLineView.animated = false
            self.curvyLineView.setNeedsDisplay()
        }
    }
}
