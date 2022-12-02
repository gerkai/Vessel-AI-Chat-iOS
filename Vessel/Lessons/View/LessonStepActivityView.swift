//
//  LessonStepActivityView.swift
//  Vessel
//
//  Created by Nicolas Medina on 11/30/22.
//

import UIKit

protocol LessonStepActivityViewDelegate: AnyObject
{
    func onActivityAddedToPlan(activityId: Int, activityName: String)
    func onActivityRemovedFromPlan(activityId: Int)
}

class LessonStepActivityView: UIView
{
    @IBOutlet private weak var rootView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var frequencyLabel: UILabel!
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var addOrRemoveButton: UIButton!
    
    var activityId: Int = -1
    private weak var delegate: LessonStepActivityViewDelegate!
    private let addPlanString = NSLocalizedString("Add to your plan", comment: "")
    private let removePlanString = NSLocalizedString("Remove from plan", comment: "")
    
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
    }
    
    func setup(activityId: Int, title: String, frequency: String, backgroundImage: String, delegate: LessonStepActivityViewDelegate)
    {
        self.activityId = activityId
        titleLabel.text = title
        frequencyLabel.text = frequency
        self.delegate = delegate
        guard let url = URL(string: backgroundImage) else { return }
        backgroundImageView.kf.setImage(with: url)
    }
    
    func setButtonText(addText: Bool)
    {
        if addText
        {
            addOrRemoveButton.setTitle(addPlanString, for: .normal)
        }
        else
        {
            addOrRemoveButton.setTitle(removePlanString, for: .normal)
        }
    }
    
    @IBAction func onTapped()
    {
        if addOrRemoveButton.title(for: .normal) == addPlanString
        {
            delegate?.onActivityAddedToPlan(activityId: self.activityId, activityName: self.titleLabel.text ?? "")
        }
        else if addOrRemoveButton.title(for: .normal) == removePlanString
        {
            delegate?.onActivityRemovedFromPlan(activityId: self.activityId)
        }
        addOrRemoveButton.setTitle("", for: .normal)
    }
}
