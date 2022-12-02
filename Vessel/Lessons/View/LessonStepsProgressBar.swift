//
//  LessonStepsProgressBar.swift
//  Vessel
//
//  Created by Nicolas Medina on 12/1/22.
//

import UIKit

class LessonStepsProgressBar: UIView
{
    @IBOutlet private weak var rootView: UIView!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var progressView: UIView!
    @IBOutlet private weak var progressViewWidhtConstraint: NSLayoutConstraint!
    
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
        Bundle.main.loadNibNamed(xibName, owner: self, options: nil)
        rootView.fixInView(self)
        backgroundColor = .clear
    }
    
    func setProgressBar(totalSteps: Int, progress: Int)
    {
        progressViewWidhtConstraint.constant = frame.width * CGFloat(progress + 1) / CGFloat(totalSteps)
        layoutIfNeeded()
    }
    
    func setup(totalSteps: Int, progress: Int)
    {
        if totalSteps > 10
        {
            stackView.removeAllArrangedSubviews()
        }
        else
        {
            let stepsToRemove = 11 - totalSteps
            // Remove excess of points
            for _ in stride(from: 1, to: stepsToRemove, by: 1)
            {
                let subview = stackView.arrangedSubviews[1]
                subview.removeFromSuperview()
            }
            // Setup points
            for i in stride(from: 1, through: totalSteps, by: 1)
            {
                if i > progress + 1
                {
                    let subview = stackView.arrangedSubviews[i] as? UIImageView
                    subview?.image = UIImage(named: "LessonEmptyCircle")
                    subview?.layer.cornerRadius = 4
                }
                else
                {
                    let subview = stackView.arrangedSubviews[i] as? UIImageView
                    subview?.image = UIImage(named: "LessonProgressCircle")
                    subview?.layer.cornerRadius = 7
                }
            }
        }
    }
}
