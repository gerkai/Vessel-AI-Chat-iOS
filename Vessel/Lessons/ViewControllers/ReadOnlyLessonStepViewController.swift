//
//  ReadOnlyLessonStepViewController.swift
//  Vessel
//
//  Created by Nicolas Medina on 11/24/22.
//

import UIKit

class ReadOnlyLessonStepViewController: UIViewController, VesselScreenIdentifiable
{
    var viewModel: StepViewModel!
    var coordinator: LessonsCoordinator!
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var contentStackView: UIStackView!
    @IBOutlet private weak var contentTextView: UITextView!
    @IBOutlet private weak var progressBar: LessonStepsProgressBar!
    @IBOutlet private weak var nextButton: BounceButton!
    @IBOutlet private weak var planAddedViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var planAddedViewHeightConstraint: NSLayoutConstraint!
    
    private var progressBarSetup = false
    @Resolved var analytics: Analytics
    var flowName: AnalyticsFlowName = .lessonsFlow
    
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
        if coordinator.shouldFadeBack()
        {
            navigationController?.fadeOut()
        }
        else
        {
            navigationController?.popViewController(animated: true)
        }
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
              let url = URL(string: imageUrl) else
        {
            assertionFailure("ReadOnlyLessonStepViewController-setupImageView: backgroundImage not a valid URL")
            return
        }
        backgroundImageView.kf.setImage(with: url)
    }
    
    func setupStackView()
    {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 12
        
        contentTextView.isScrollEnabled = false
        let mutableAttributedString = viewModel.step.text?.makeAttributedString(fontName: "BananaGrotesk-Regular", textColor: .white)
        mutableAttributedString?.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: mutableAttributedString?.length ?? 0))
        
        contentTextView.linkTextAttributes =
        [
            .foregroundColor: UIColor.systemBlue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        contentTextView.attributedText = mutableAttributedString
        
        contentStackView.layoutIfNeeded()
        
        if viewModel.step.activityIds.isEmpty
        {
            contentStackView.arrangedSubviews.last?.removeFromSuperview()
        }
        else
        {
            let userPlans = PlansManager.shared.getActivityPlans()
            for activityId in viewModel.step.activityIds
            {
                if let activity = Storage.retrieve(activityId, as: Tip.self)
                {
                    let activityView = LessonStepActivityView(frame: .zero)
                    activityView.setup(activityId: activityId, title: activity.title, frequency: activity.frequency, backgroundImage: activity.imageUrl, delegate: self)
                    if userPlans.contains(where: { $0.type == .activity && $0.typeId == activityId && $0.removedDate == nil })
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
            PlansManager.shared.addPlans(plansToAdd: [plan])
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
                } completion: { _ in
                    if RemoteConfigManager.shared.getValue(for: .remindersFeature) as? Bool ?? false
                    {
                        let activities = PlansManager.shared.activities
                        let activityPlans = PlansManager.shared.getActivityPlans()
                        guard let plan = activityPlans.first(where: { $0.typeId == activityId }),
                              let activity = activities.first(where: { $0.id == plan.typeId }) else
                        {
                            assertionFailure("ReadOnlyLessonStepViewController-onActivityAddedToPlan: Can't find plan or activity with id: \(activityId)")
                            return
                        }
                        
                        self.analytics.log(event: .addReminder(planId: plan.id, typeId: plan.typeId, planType: .activity))
                        
                        let reminders = RemindersManager.shared.getRemindersForPlan(planId: plan.id)
                        if reminders.count > 0
                        {
                            let storyboard = UIStoryboard(name: "Reminders", bundle: nil)
                            let addReminderVC = storyboard.instantiateViewController(identifier: "RemindersViewController") as! RemindersViewController
                            addReminderVC.hidesBottomBarWhenPushed = true
                            addReminderVC.viewModel = RemindersViewModel(planId: plan.id, reminders: reminders, activity: activity)
                            self.navigationController?.pushViewController(addReminderVC, animated: true)
                        }
                        else
                        {
                            let storyboard = UIStoryboard(name: "Reminders", bundle: nil)
                            let addReminderVC = storyboard.instantiateViewController(identifier: "AddReminderViewController") as! AddReminderViewController
                            addReminderVC.hidesBottomBarWhenPushed = true
                            addReminderVC.viewModel = AddReminderViewModel(planId: plan.id, activity: activity)
                            self.navigationController?.pushViewController(addReminderVC, animated: true)
                        }
                    }
                }
            }
        } onFailure: { [weak self] error in
            guard let self = self else { return }
            self.setActivityButtonTitle(activityId: activityId, addText: true)
        }
    }
    
    func onActivityRemovedFromPlan(activityId: Int)
    {
        guard let plan = PlansManager.shared.getActivityPlans().first(where: { $0.typeId == activityId && $0.removedDate == nil }) else
        {
            assertionFailure("ReadOnlyLessonStepViewController-onActivityRemovedFromPlan: Plan non existent")
            return
        }
        PlansManager.shared.removePlans(plansToRemove: [plan])
        {
            self.setActivityButtonTitle(activityId: activityId, addText: true)
        }
    }
}
