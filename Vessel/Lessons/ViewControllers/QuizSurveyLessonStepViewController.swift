//
//  QuizSurveyLessonStepViewController.swift
//  Vessel
//
//  Created by Nicolas Medina on 11/21/22.
//

import UIKit

class QuizSurveyLessonStepViewController: UIViewController
{
    var viewModel: StepViewModel!
    var coordinator: LessonsCoordinator!
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var stepsStackView: UIStackView!
    @IBOutlet private weak var nextButton: BounceButton!
    @IBOutlet private weak var stackViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var progressBar: LessonStepsProgressBar!
    
    private var progressBarSetup = false
    private var type: StepType?
    {
        switch viewModel?.step.type
        {
        case .quiz, .survey:
            return viewModel?.step.type
        default:
            return nil
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setupUI()
        updateNextButton()
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
    
    // MARK: - Actions
    
    @IBAction func onBack()
    {
        coordinator.back()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onNext()
    {
        if viewModel.state == .answering
        {
            if viewModel.selectedAnswerId != nil || viewModel.step.isSkippable
            {
                if let selectedAnswerId = viewModel.selectedAnswerId
                {
                    coordinator?.answerStep(answer: "", answerId: selectedAnswerId)
                }
                if coordinator.shouldShowSuccessScreen()
                {
                    if let viewController = coordinator.getNextStepViewController(state: viewModel.state) as? LessonResultsViewController
                    {
                        viewController.imageUrl = viewModel.lesson.imageUrl
                        viewController.success = viewModel.result == .correct
                        navigationController?.fadeTo(viewController)
                    }
                }
                viewModel.state = .result
                reloadUI()
            }
            else
            {
                GenericAlertViewController.presentAlert(in: self,
                                                        type: .titleButton(text: GenericAlertLabelInfo(title: "Please make a selection to continue", font: Constants.FontTitleMain24),
                                                                           button: GenericAlertButtonInfo(label: GenericAlertLabelInfo(title: "Got it!"),
                                                                                                          type: .dark)),
                                                        description: "",
                                                        alignment: .bottom)
            }
        }
        else
        {
            viewModel.state = .answering
            if let viewController = coordinator.getNextStepViewController(state: viewModel.state)
            {
                navigationController?.fadeTo(viewController)
            }
            else
            {
                coordinator.finishLesson(navigationController: navigationController!)
            }
        }
    }
}

private extension QuizSurveyLessonStepViewController
{
    func setupUI()
    {
        questionLabel.text = viewModel.step.text
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
        for answer in viewModel.step.answers
        {
            let view = LessonStepView(frame: .zero)
            view.setup(title: answer.primaryText, id: answer.id, checkedState: .unselected, delegate: self)
            stepsStackView.addArrangedSubview(view)
        }
        
        stackViewHeightConstraint.constant = CGFloat((viewModel.step.answers.count * 60) + ((viewModel.step.answers.count - 1) * 16))
        view.layoutIfNeeded()
    }
    
    func reloadUI()
    {
        if viewModel.state == .answering
        {
            questionLabel.font = Constants.FontBoldMain28
            for view in stepsStackView.arrangedSubviews
            {
                guard let view = view as? LessonStepView else { return }
                view.setup(checkedState: view.id == (viewModel.selectedAnswerId ?? 0) ? .selected : .unselected)
            }
        }
        else
        {
            questionLabel.font = Constants.FontBodyMain16
            questionLabel.text = viewModel.step.successText ?? (viewModel.result == .correct ? NSLocalizedString("Nice work! You got it right!", comment: "") : NSLocalizedString("Good try! Below is the correct answer.", comment: ""))
            for view in stepsStackView.arrangedSubviews
            {
                guard let view = view as? LessonStepView else { return }
                
                let state: LessonStepViewCheckedState
                if viewModel.state == .result && (viewModel.result == .correct || type == .survey)
                {
                    if view.id == viewModel.selectedAnswerId
                    {
                        state = .correct
                    }
                    else
                    {
                        state = .unselected
                    }
                }
                else
                {
                    if view.id == viewModel.selectedAnswerId
                    {
                        state = .wrong
                    }
                    else if view.id == viewModel.step.correctAnswerId
                    {
                        state = .correctUnselected
                    }
                    else
                    {
                        state = .unselected
                    }
                }
                
                view.setup(checkedState: state)
            }
        }
        view.layoutIfNeeded()
        updateNextButton()
    }
    
    func updateNextButton()
    {
        if viewModel?.selectedAnswerId != nil || viewModel.step.isSkippable
        {
            nextButton.backgroundColor = Constants.vesselBlack
        }
        else
        {
            nextButton.backgroundColor = Constants.vesselGray
        }
    }
}

extension QuizSurveyLessonStepViewController: LessonStepViewDelegate
{
    func onStepSelected(id: Int)
    {
        if viewModel.state == .answering
        {
            if id == viewModel.selectedAnswerId
            {
                viewModel.selectedAnswerId = nil
            }
            else
            {
                viewModel.selectedAnswerId = id
            }
            reloadUI()
        }
    }
}
