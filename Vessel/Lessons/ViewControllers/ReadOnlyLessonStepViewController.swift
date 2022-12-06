//
//  ReadOnlyLessonStepViewController.swift
//  Vessel
//
//  Created by Nicolas Medina on 11/24/22.
//

import UIKit

class ReadOnlyLessonStepViewController: UIViewController
{
    var viewModel: StepViewModel!
    var coordinator: LessonsCoordinator!
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var contentStackView: UIStackView!
    @IBOutlet private weak var contentTextLabel: UILabel!
    @IBOutlet private weak var progressBar: LessonStepsProgressBar!
    @IBOutlet private weak var nextButton: BounceButton!
    @IBOutlet private weak var planAddedViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var planAddedViewHeightConstraint: NSLayoutConstraint!
    
    private var progressBarSetup = false
    @Resolved private var analytics: Analytics
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        setupUI()
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        
        if !progressBarSetup
        {
            progressBarSetup = true
            let index = viewModel.lesson.stepIds.firstIndex(of: viewModel.step.id)
            progressBar.setProgressBar(totalSteps: viewModel.lesson.stepIds.count, progress: index ?? 0)
        }
    }

    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        planAddedViewHeightConstraint.constant = 95 + view.safeAreaInsets.top
        planAddedViewTopConstraint.constant = -planAddedViewHeightConstraint.constant
        view.layoutIfNeeded()
    }
    
    // MARK: - Actions
    
    @IBAction func onBack()
    {
        coordinator.back()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onNext()
    {
        coordinator.answerStep(answer: "", answerId: 0)
        if let viewController = coordinator?.getNextStepViewController()
        {
            navigationController?.fadeTo(viewController)
        }
        else
        {
            coordinator.finishLesson(navigationController: navigationController!)
        }
    }
}

private extension ReadOnlyLessonStepViewController
{
    func setupUI()
    {
        titleLabel.text = viewModel.lesson.title
        durationLabel.text = "~\(viewModel.lesson.durationString())"
        setupImageView()
        setupStackView()
        let index = viewModel.lesson.stepIds.firstIndex(where: { $0 == viewModel.step.id })
        progressBar.setup(totalSteps: viewModel.lesson.stepIds.count, progress: index ?? 0)
        if index == viewModel.lesson.stepIds.count - 1
        {
            nextButton.setTitle(NSLocalizedString("Done", comment: ""), for: .normal)
        }
    }
    
    func setupImageView()
    {
        guard let imageUrl = viewModel.lesson.imageUrl,
              let url = URL(string: imageUrl) else { return }
        backgroundImageView.kf.setImage(with: url)
    }
    
    func setupStackView()
    {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 12
        
        let mutableAttributedString = viewModel.step.text?.makeAttributedString(fontName: "BananaGrotesk-Regular", textColor: .white)
        mutableAttributedString?.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: mutableAttributedString?.length ?? 0))
        contentTextLabel.attributedText = mutableAttributedString
        
        if viewModel.step.activityIds.isEmpty
        {
            contentStackView.arrangedSubviews.last?.removeFromSuperview()
        }
        else
        {
            let userPlans = PlansManager.shared.getActivities()
            for activityId in viewModel.step.activityIds
            {
                if let activity = viewModel.lesson.activities.first(where: { $0.id == activityId })
                {
                    let activityView = LessonStepActivityView(frame: .zero)
                    activityView.setup(activityId: activityId, title: activity.title, frequency: activity.frequency, backgroundImage: activity.imageUrl, delegate: self)
                    if userPlans.contains(where: { $0.type == .activity && $0.typeId == activityId })
                    {
                        activityView.setButtonText(addText: false)
                    }
                    contentStackView.addArrangedSubview(activityView)
                }
            }
        }
    }
    
    func setActivityButtonTitle(activityId: Int, addText: Bool)
    {
        let activityViews = contentStackView.arrangedSubviews.filter({ ($0 as? LessonStepActivityView) != nil }) as! [LessonStepActivityView]
        let activityView = activityViews.first(where: { $0.activityId == activityId })
        activityView?.setButtonText(addText: addText)
    }
}

extension ReadOnlyLessonStepViewController: LessonStepActivityViewDelegate
{
    func onActivityAddedToPlan(activityId: Int, activityName: String)
    {
        let plan = Plan(type: .activity, typeId: activityId)
        Server.shared.addSinglePlan(plan: plan) { [weak self] plan in
            guard let self = self else { return }
            self.analytics.log(event: .activityAdded(activityId: activityId, activityName: activityName))
            PlansManager.shared.plans.append(plan)
            self.setActivityButtonTitle(activityId: activityId, addText: false)
            
            self.planAddedViewTopConstraint.constant = 0
            UIView.animate(withDuration: 0.3, delay: 0.0)
            {
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.planAddedViewTopConstraint.constant = -self.planAddedViewHeightConstraint.constant
                UIView.animate(withDuration: 0.3, delay: 2.0)
                {
                    self.view.layoutIfNeeded()
                }
            }
        } onFailure: { [weak self] error in
            guard let self = self else { return }
            self.setActivityButtonTitle(activityId: activityId, addText: true)
        }
    }
    
    func onActivityRemovedFromPlan(activityId: Int)
    {
        guard let plan = PlansManager.shared.getActivities().first(where: { $0.typeId == activityId}) else { return }
        Server.shared.removeSinglePlan(planId: plan.id)
        { [weak self] in
            guard let self = self else { return }
            self.setActivityButtonTitle(activityId: activityId, addText: true)
            PlansManager.shared.remove(plan: plan)
        }
        onFailure:
        { [weak self] error in
            guard let self = self else { return }
            print(error)
            self.setActivityButtonTitle(activityId: activityId, addText: false)
        }
    }
}
