//
//  ResultsViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 7/24/22.
//

import UIKit

class ResultsViewController: UIViewController
{
    @IBOutlet weak var wellnessScoreLabel: UILabel!
    @IBOutlet weak var wellnessCard: UIView!
    @IBOutlet weak var evaluationLabel: UILabel!
    
    var wellnessScore: Double!
    var timer: Timer!
    let wellnessCardAnimationTime = 3.0
    let tickTime = 0.05
    var tickCounter = 0.0
    var referenceDate: Date!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        referenceDate = Date()
        evaluationLabel.alpha = 0.0
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true)
        {
           _ in self.onTick()
        }
    }
    
    var iteration = 0
    
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
    
    @IBAction func done()
    {
        //navigationController?.popToRootViewController(animated: true)
        dismiss(animated: true)
    }
}
