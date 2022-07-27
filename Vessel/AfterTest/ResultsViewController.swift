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
    
    var wellnessScore: Double!
    var timer: Timer!
    var iteration = 0
    let wellnessCardAnimationTime = 3.0
    let tickTime = 0.05
    var tickCounter = 0.0
    var referenceDate: Date!
    
    var numTiles = 10
    var curTile = 0
    
    //will move these to constants if we start using them in more places
    let poorColor = Color(red: 0.9059, green: 0.7686, blue: 0.6941)
    let fairColor = Color(red: 0.9451, green: 0.8627, blue: 0.8078)
    let goodColor = Color(red: 0.8588, green: 0.9216, blue: 0.8353)
    let greatColor = Color(red: 0.7569, green: 0.8706, blue: 0.7294)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        referenceDate = Date()
        evaluationLabel.alpha = 0.0
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true)
        {
           _ in self.onTick()
        }
        
        //remove the placeholder views
        for v in leftStackView.subviews
        {
           v.removeFromSuperview()
        }
        for v in rightStackView.subviews
        {
           v.removeFromSuperview()
        }
        
        titleLabel.text = NSLocalizedString("Ranges", comment: "Wellness score ranges (0-25, 25-50 etc.)")
        staggerConstraint.constant = 0
        for i in 0 ..< 4
        {
            let reagentView = ReagentTileView(frame: CGRect(x: 0, y: 0, width: 128, height: 78))
            let heightConstraint = NSLayoutConstraint(item: reagentView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 78)
            reagentView.addConstraints([heightConstraint])
            if i == 0
            {
                print("Setting Reagent View data")
                reagentView.titleLabel.text = "0-25"
                reagentView.subtextLabel.text = NSLocalizedString("Poor", comment: "Quality level")
                reagentView.contentView.backgroundColor = UIColor(red: CGFloat(poorColor.red), green: CGFloat(poorColor.green), blue: CGFloat(poorColor.blue), alpha: 1.0)
                leftStackView.addArrangedSubview(reagentView)
            }
            else if i == 1
            {
                reagentView.titleLabel.text = "25-50"
                reagentView.subtextLabel.text = NSLocalizedString("Fair", comment: "Quality level")
                reagentView.contentView.backgroundColor = UIColor(red: CGFloat(fairColor.red), green: CGFloat(fairColor.green), blue: CGFloat(fairColor.blue), alpha: 1.0)
                rightStackView.addArrangedSubview(reagentView)
            }
            else if i == 2
            {
                reagentView.titleLabel.text = "50-75"
                reagentView.subtextLabel.text = NSLocalizedString("Good", comment: "Quality level")
                reagentView.contentView.backgroundColor = UIColor(red: CGFloat(goodColor.red), green: CGFloat(goodColor.green), blue: CGFloat(goodColor.blue), alpha: 1.0)
                leftStackView.addArrangedSubview(reagentView)
            }
            else
            {
                reagentView.titleLabel.text = "75-100"
                reagentView.subtextLabel.text = NSLocalizedString("Great", comment: "Quality level")
                reagentView.contentView.backgroundColor = UIColor(red: CGFloat(greatColor.red), green: CGFloat(greatColor.green), blue: CGFloat(greatColor.blue), alpha: 1.0)
                rightStackView.addArrangedSubview(reagentView)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        animateBackgroundColor()
    }
    
    func animateBackgroundColor()
    {
        //animates background color of wellness card from poor color to fair color, good color and great color depending on
        //wellness score.
        let sectionSize = 0.25
        var remainingScore = wellnessScore!
        let sectionTime = sectionSize / remainingScore * wellnessCardAnimationTime
        
        if remainingScore > sectionSize
        {
            remainingScore -= sectionSize
            print("Animating to Fair with remaining score: \(remainingScore)")
            var duration = (remainingScore / sectionSize) * sectionTime
            if duration > sectionTime
            {
                duration = sectionTime
            }
            var percentage = duration / sectionTime
            print("Starting Time: \(sectionTime), duration: \(duration), percentage: \(percentage)")
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
                    print("Animating to Good with remaining score: \(remainingScore)")
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
                            print("Animating to Great with remaining score: \(remainingScore)")
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
                                self.showRanges()
                            }
                        }
                        else
                        {
                            self.showRanges()
                        }
                    }
                }
                else
                {
                    self.showRanges()
                }
            }
        }
        else
        {
            self.showRanges()
        }
    }
    
    func showRanges()
    {
        print("SHOW RANGES")
        DispatchQueue.main.async()
        {
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
        let value = Int((wellnessScore * percentage) * 100.0)
        wellnessScoreLabel.text = "\(value)"
        if percentage == 1.0
        {
            timer.invalidate()
            evaluationLabel.text = evaluation(value)
            
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
                    //show either ranges or results here
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
    
    @IBAction func next()
    {
        //navigationController?.popToRootViewController(animated: true)
        dismiss(animated: true)
        //navigationController?.popViewController(animated: true)
    }
}
