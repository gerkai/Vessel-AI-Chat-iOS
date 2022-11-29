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
    @IBOutlet weak var stackViewHeightConstraint: NSLayoutConstraint!
    
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
            if let _ = viewModel.selectedAnswerId
            {
                if coordinator.shouldShowSuccessScreen()
                {
                    if let viewController = coordinator.getNextStepViewController(state: viewModel.state) as? LessonResultsViewController
                    {
                        viewController.imageUrl = viewModel.lesson.imageUrl
                        viewController.success = viewModel.result == .correct
                        navigationController?.pushViewController(viewController, animated: false)
                    }
                }
                viewModel.state = .result
                reloadUI()
            }
            else
            {
                GenericAlertViewController.presentAlert(in: self,
                                                        type: .titleButton(text: GenericAlertLabelInfo(title: "Please make a selection to continue", font: Constants.FontTitleMain24!),
                                                                           button: GenericAlertButtonInfo(label: GenericAlertLabelInfo(title: "Got it!"),
                                                                                                          type: .dark)),
                                                        description: "",
                                                        alignment: .bottom)
            }
        }
        else
        {
            if let viewController = coordinator.getNextStepViewController(state: viewModel.state)
            {
                navigationController?.pushViewController(viewController, animated: true)
            }
            else
            {
                print("LESSON FINISHED")
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
        setupImageView()
        setupStackView()
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
            for view in stepsStackView.arrangedSubviews
            {
                guard let view = view as? LessonStepView else { return }
                view.setup(checkedState: view.id == (viewModel.selectedAnswerId ?? 0) ? .selected : .unselected)
            }
        }
        else
        {
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
        updateNextButton()
    }
    
    func updateNextButton()
    {
        if let _ = viewModel?.selectedAnswerId
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
