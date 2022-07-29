//
//  ResultsViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 7/24/22.
//

import UIKit

struct Color
{
    var red: Float
    var green: Float
    var blue: Float
}

class ResultsViewController: UIViewController
{
    @IBOutlet weak var wellnessScoreLabel: UILabel!
    @IBOutlet weak var wellnessCard: UIView!
    @IBOutlet weak var evaluationLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var leftStackView: UIStackView!
    @IBOutlet weak var rightStackView: UIStackView!
    @IBOutlet weak var staggerConstraint: NSLayoutConstraint!
    
    var testResult: TestResult! //set by the caller during instantiation
    var timer: Timer!
    var iteration = 0
    let wellnessCardAnimationTime = 2.0
    let tickTime = 0.05
    var tickCounter = 0.0
    var referenceDate: Date!
    var viewModel: AfterTestViewModel!
    
    var numTiles = 10
    var curTile = 0
    var showingRanges = true
    var bouncyViews: [ReagentTileView] = []
    var originalStaggerConstraintConstant: CGFloat! //the right stackView is staggered for Results but not staggered for ranges.
    
    //will move these to constants if we start using them in more places
    let poorColor = Color(red: 0.9059, green: 0.7686, blue: 0.6941)
    let fairColor = Color(red: 0.9451, green: 0.8627, blue: 0.8078)
    let goodColor = Color(red: 0.8588, green: 0.9216, blue: 0.8353)
    let greatColor = Color(red: 0.7569, green: 0.8706, blue: 0.7294)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        viewModel = AfterTestViewModel(testResult: testResult)
        referenceDate = Date()
        evaluationLabel.alpha = 0.0
        originalStaggerConstraintConstant = staggerConstraint.constant
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true)
        {
           _ in self.onTick()
        }
        showRanges()
    }
    
    deinit
    {
        print("ResultsViewController deinit")
    }
    
    func showRanges()
    {
        //remove the placeholder views
        clearStackViews()
        
        titleLabel.text = NSLocalizedString("Ranges", comment: "Wellness score ranges (0-25, 25-50 etc.)")
        staggerConstraint.constant = 0
        for i in 0 ..< 4
        {
            let reagentView = ReagentTileView()
            let heightConstraint = NSLayoutConstraint(item: reagentView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 78)
            reagentView.addConstraints([heightConstraint])
            if i == 0
            {
                reagentView.titleLabel.text = NSLocalizedString("0-25", comment: "range 0 - 25")
                reagentView.subtextLabel.text = NSLocalizedString("Poor", comment: "Quality level")
                reagentView.contentView.backgroundColor = UIColor(red: CGFloat(poorColor.red), green: CGFloat(poorColor.green), blue: CGFloat(poorColor.blue), alpha: 1.0)
                leftStackView.addArrangedSubview(reagentView)
            }
            else if i == 1
            {
                reagentView.titleLabel.text = NSLocalizedString("25-50", comment: "range 25 - 50")
                reagentView.subtextLabel.text = NSLocalizedString("Fair", comment: "Quality level")
                reagentView.contentView.backgroundColor = UIColor(red: CGFloat(fairColor.red), green: CGFloat(fairColor.green), blue: CGFloat(fairColor.blue), alpha: 1.0)
                rightStackView.addArrangedSubview(reagentView)
            }
            else if i == 2
            {
                reagentView.titleLabel.text = NSLocalizedString("50-75", comment: "range 50 - 75")
                reagentView.subtextLabel.text = NSLocalizedString("Good", comment: "Quality level")
                reagentView.contentView.backgroundColor = UIColor(red: CGFloat(goodColor.red), green: CGFloat(goodColor.green), blue: CGFloat(goodColor.blue), alpha: 1.0)
                leftStackView.addArrangedSubview(reagentView)
            }
            else
            {
                reagentView.titleLabel.text = NSLocalizedString("75-100", comment: "range 75 - 100")
                reagentView.subtextLabel.text = NSLocalizedString("Great", comment: "Quality level")
                reagentView.contentView.backgroundColor = UIColor(red: CGFloat(greatColor.red), green: CGFloat(greatColor.green), blue: CGFloat(greatColor.blue), alpha: 1.0)
                rightStackView.addArrangedSubview(reagentView)
            }
            reagentView.alpha = 0.0
            bouncyViews.append(reagentView)
        }
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        animateBouncyViews()
        animateBackgroundColor()
    }
    
    func animateBackgroundColor()
    {
        //animates background color of wellness card from poor color to fair color, good color and great color depending on
        //wellness score.
        let sectionSize = 0.25
        var remainingScore = testResult.wellnessScore
        let sectionTime = sectionSize / remainingScore * wellnessCardAnimationTime
        
        if remainingScore > sectionSize
        {
            remainingScore -= sectionSize
            //print("Animating to Fair with remaining score: \(remainingScore)")
            var duration = (remainingScore / sectionSize) * sectionTime
            if duration > sectionTime
            {
                duration = sectionTime
            }
            var percentage = duration / sectionTime
            //print("Starting Time: \(sectionTime), duration: \(duration), percentage: \(percentage)")
            UIView.animate(withDuration: duration, delay: sectionTime, options: .curveLinear)
            {
                self.setBackgroundColor(startColor: self.poorColor, endColor: self.fairColor, percentage: percentage)
            }
            completion:
            { completed in
                //Animate to Good
                remainingScore -= sectionSize
                if remainingScore > 0
                {
                    //print("Animating to Good with remaining score: \(remainingScore)")
                    duration = (remainingScore / sectionSize) * sectionTime
                    
                    if duration > sectionTime
                    {
                        duration = sectionTime
                    }
                    percentage = duration / sectionTime
                    UIView.animate(withDuration: duration, delay: 0, options: .curveLinear)
                    {
                        self.setBackgroundColor(startColor: self.fairColor, endColor: self.goodColor, percentage: percentage)
                    }
                    completion:
                    { _ in
                        //Animate to Great
                        remainingScore -= sectionSize
                        if remainingScore > 0
                        {
                            //print("Animating to Great with remaining score: \(remainingScore)")
                            duration = (remainingScore / sectionSize) * sectionTime
                            if duration > sectionTime
                            {
                                duration = sectionTime
                            }
                            percentage = duration / sectionTime
                            UIView.animate(withDuration: duration, delay: 0, options: .curveLinear)
                            {
                                self.setBackgroundColor(startColor: self.goodColor, endColor: self.greatColor, percentage: percentage)
                            }
                            completion:
                            { _ in
                            }
                        }
                    }
                }
            }
        }
    }
    
    func animateBouncyViews()
    {
        var delay = 0.0
        for view in bouncyViews
        {
            //calculate large enough yOffset to place the view off the bottom of the screen
            let newPoint = view.convert(CGPoint(x: 0, y: 0), to: self.view)
            let newY = self.view.frame.size.height - newPoint.y
            var frame = view.frame
            view.endFrame = view.frame
            
            //move the view past the bottom of the screen
            frame.origin.y += newY
            view.frame = frame
            view.startFrame = frame
            
            UIView.animate(withDuration: 0.25, delay: delay, options: .curveEaseOut)
            {
                view.alpha = 1.0
                view.tempFrame = view.endFrame
                view.tempFrame.origin.y -= 20.0
                view.frame = view.tempFrame
            }
            completion:
            { complete in
                UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut)
                {
                    view.frame = view.endFrame
                }
                completion:
                { complete in
                    view.alpha = 1.0
                }
            }
            delay += 0.2
        }
    }
    
    func populateResults()
    {
        //populate stackViews with new reagent tiles
        //set their alpha to 0 so they remain invisible while the layout engine places them in the correct location.
        for i in 0 ..< testResult.reagents.count
        {
            let reagentView = ReagentTileView()
            let heightConstraint = NSLayoutConstraint(item: reagentView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 78)
            reagentView.addConstraints([heightConstraint])
            reagentView.alpha = 0.0
            let reagent = Reagents[Reagent.ID(rawValue: testResult.reagents[i].id)!]!
            let value = testResult.reagents[i].value
            let evaluation = reagent.getEvaluation(score: value)
            
            reagentView.titleLabel.text = reagent.name
            reagentView.subtextLabel.text = evaluation.title
            reagentView.contentView.backgroundColor = evaluation.color
            reagentView.imageView.image = UIImage.init(named: reagent.imageName)
            
            if i & 1 == 0
            {
                leftStackView.addArrangedSubview(reagentView)
            }
            else
            {
                rightStackView.addArrangedSubview(reagentView)
            }
            
            bouncyViews.append(reagentView)
        }
        
        //update title label and fade it in
        titleLabel.text = NSLocalizedString("Results", comment: "Title label showing your wellness results")
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveLinear)
        {
            self.titleLabel.alpha = 1.0
        }
        completion:
        { completed in
            var delay = 0.0
            
            //animate reagent tiles up to their original positions
            for view in self.bouncyViews
            {
                //calculate yOffset sufficient to place view off bottom of screen.
                let newPoint = view.convert(CGPoint(x: 0, y: 0), to: self.view)
                let newY = self.view.frame.size.height - newPoint.y
                var frame = view.frame
                view.endFrame = view.frame
                
                //Move tiles to starting position off bottom of screen
                frame.origin.y += newY
                view.frame = frame
                view.startFrame = frame
                
                //animate to position slightly above original position (overshoot)
                UIView.animate(withDuration: 0.25, delay: delay, options: .curveEaseOut)
                {
                    view.alpha = 1.0
                    view.tempFrame = view.endFrame
                    view.tempFrame.origin.y -= 30.0
                    view.frame = view.tempFrame
                }
                completion:
                { complete in
                    //And then animate back down to original position
                    UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut)
                    {
                        view.frame = view.endFrame
                    }
                    completion:
                    { complete in
                    }
                }
                delay += 0.2
            }
        }
    }
    
    func onTick()
    {
        let curDate = Date()
        let elapsedTime = curDate.timeIntervalSince(referenceDate)

        var percentage = elapsedTime / wellnessCardAnimationTime
        if percentage > 1.0
        {
            percentage = 1.0
        }
        let value = Int((testResult.wellnessScore * percentage) * 100.0)
        wellnessScoreLabel.text = "\(value)"
        if percentage == 1.0
        {
            timer.invalidate()
            evaluationLabel.text = evaluation(value)
            
            //pop the evaluation label in
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseOut)
            {
                self.evaluationLabel.alpha = 1.0
                self.evaluationLabel.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }
            completion:
            { _ in
                UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseOut)
                {
                    self.evaluationLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }
                completion:
                { _ in
                }
            }
        }
    }
    
    func evaluation(_ score: Int) -> String
    {
        if score <= 25
        {
            return NSLocalizedString("Poor", comment: "Health quality")
        }
        if score <= 50
        {
            return NSLocalizedString("Fair", comment: "Health quality")
        }
        if score < 75
        {
            return NSLocalizedString("Good", comment: "Health quality")
        }
        return NSLocalizedString("Great", comment: "Health quality")
    }
    
    func setBackgroundColor(startColor: Color, endColor: Color, percentage: Double)
    {
        var percent = Float(percentage)
        if percent > 1.0
        {
            percent = 1.0
        }
        let red = startColor.red + (endColor.red - startColor.red) * percent
        let green = startColor.green + (endColor.green - startColor.green) * percent
        let blue = startColor.blue + (endColor.blue - startColor.blue) * percent

        self.wellnessCard.backgroundColor = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1.0)
        self.wellnessCard.setNeedsDisplay()
    }
    
    func clearStackViews()
    {
        for v in leftStackView.subviews
        {
           v.removeFromSuperview()
        }
        for v in rightStackView.subviews
        {
           v.removeFromSuperview()
        }
        bouncyViews.removeAll()
    }
    
    @IBAction func next()
    {
        if showingRanges
        {
            showingRanges = false
            for view in bouncyViews
            {
                UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn)
                {
                    view.frame = view.startFrame
                    self.titleLabel.alpha = 0.0
                } completion:
                { _ in
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2)
            {
                self.clearStackViews()
                self.staggerConstraint.constant = self.originalStaggerConstraintConstant
                self.populateResults()
            }
        }
        else
        {
            let result = viewModel.nextViewControllerData()
            if result.transition == .dismiss
            {
                if self.navigationController != nil
                {
                    navigationController?.popViewController(animated: true)
                }
                else
                {
                    dismiss(animated: true)
                }
            }
            else
            {
                let storyboard = UIStoryboard(name: "AfterTest", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "ReagentInfoViewController") as! ReagentInfoViewController
                vc.viewModel = viewModel
                vc.titleText = result.title
                vc.details = result.details
                vc.image = result.image
                vc.transition = result.transition
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func mockTestResult()
    {
        //used for test/debug
        testResult = TestResult(wellnessScore: 0.73, errors: [], reagents: [ReagentResult(id: 11, value: 30.0, score: 1.0),
                                                                            ReagentResult(id: 8, value: 225.0, score: 0.4),
                                                                            ReagentResult(id: 1, value: 7.5, score: 1.0),
                                                                            ReagentResult(id: 3, value: 0.0, score: 0.0),
                                                                            ReagentResult(id: 4, value: 150.0, score: 0.2),
                                                                            ReagentResult(id: 2, value: 1.002, score: 0.8),
                                                                            ReagentResult(id: 5, value: 450.0, score: 1.0)])
    }
}
