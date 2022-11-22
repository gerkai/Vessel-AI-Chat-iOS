//
//  QuizLessonStepViewController.swift
//  Vessel
//
//  Created by Nicolas Medina on 11/21/22.
//

import UIKit

class QuizLessonStepViewController: UIViewController
{
    var viewModel: StepViewModel?
    var coordinator: LessonsCoordinator?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var stepsStackView: UIStackView!
    @IBOutlet weak var nextButton: BounceButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        setupUI()
        updateNextButton()
    }
    
    // MARK: - Actions
    
    @IBAction func onBack()
    {
        coordinator?.back()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onNext()
    {
        guard let viewModel = viewModel else { return }
        
        if viewModel.state == .answering
        {
            if let _ = viewModel.selectedAnswerId
            {
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
            if let viewController = coordinator?.getNextStepViewController()
            {
                navigationController?.present(viewController, animated: true)
            }
            else
            {
                print("LESSON FINISHED")
            }
        }
    }
}

private extension QuizLessonStepViewController
{
    func setupUI()
    {
        guard let viewModel = viewModel else { return }
        questionLabel.text = viewModel.step.text
        setupImageView()
        setupStackView()
    }
    
    func setupImageView()
    {
        guard let viewModel = viewModel,
              let url = URL(string: viewModel.lesson.imageUrl) else { return }
        backgroundImageView.kf.setImage(with: url)
    }
    
    func setupStackView()
    {
        guard let viewModel = viewModel else { return }
        for answer in viewModel.step.answers
        {
            let view = LessonStepView(frame: .zero)
            view.setup(title: answer.primaryText, id: answer.id, checkedState: .unselected, delegate: self)
            stepsStackView.addArrangedSubview(view)
        }
    }
    
    func reloadUI()
    {
        guard let viewModel = viewModel else { return }
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
                if viewModel.result == .correct
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

extension QuizLessonStepViewController: LessonStepViewDelegate
{
    func onStepSelected(id: Int)
    {
        guard let viewModel = viewModel else { return }
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
