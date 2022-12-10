//
//  InputLessonStepViewController.swift
//  Vessel
//
//  Created by Nicolas Medina on 11/26/22.
//

import UIKit

class InputLessonStepViewController: UIViewController
{
    var viewModel: StepViewModel!
    var coordinator: LessonsCoordinator!
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var contentStackView: UIStackView!
    @IBOutlet private weak var contentTextLabel: UILabel!
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var charactersCountLabel: UILabel!
    @IBOutlet private weak var progressBar: LessonStepsProgressBar!
    @IBOutlet private weak var nextButton: BounceButton!
    
    private var initialTextViewText: String?
    private var progressBarSetup = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        setupUI()
        backgroundImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBackgroundTapped)))
        contentStackView.arrangedSubviews.first?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBackgroundTapped)))
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
        if textView.text.count > 0 || viewModel.step.isSkippable
        {
            coordinator.answerStep(answer: textView.text ?? "", answerId: 0)
            if let viewController = coordinator?.getNextStepViewController()
            {
                navigationController?.fadeTo(viewController)
            }
            else
            {
                coordinator.finishLesson(navigationController: navigationController!)
            }
        }
        else
        {
            GenericAlertViewController.presentAlert(in: self,
                                                    type: .titleButton(text: GenericAlertLabelInfo(title: "Please enter text to continue", font: Constants.FontTitleMain24),
                                                                       button: GenericAlertButtonInfo(label: GenericAlertLabelInfo(title: "Got it!"),
                                                                                                      type: .dark)),
                                                    description: "",
                                                    alignment: .bottom)
        }
    }
}

private extension InputLessonStepViewController
{
    func setupUI()
    {
        titleLabel.text = viewModel.lesson.title
        durationLabel.text = "~\(viewModel.lesson.durationString())"
        textView.text = viewModel.answer ?? viewModel.step.placeholderText
        initialTextViewText = viewModel.step.placeholderText
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
        contentTextLabel.text = viewModel.step.text
    }
    
    func updateNextButton()
    {
        if textView.text.count > 0 || viewModel.step.isSkippable
        {
            nextButton.backgroundColor = Constants.vesselBlack
        }
        else
        {
            nextButton.backgroundColor = Constants.vesselGray
        }
    }
    
    @objc
    func onBackgroundTapped(gestureRecognizer: UIGestureRecognizer)
    {
        textView.resignFirstResponder()
    }
}

extension InputLessonStepViewController: UITextViewDelegate
{
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if textView.text == initialTextViewText
        {
            textView.text = ""
        }
    }

    func textViewDidEndEditing(_ textView: UITextView)
    {
        if textView.text == ""
        {
            textView.text = initialTextViewText
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        return textView.text.count < 1000
    }

    func textViewDidChange(_ textView: UITextView)
    {
        if textView.text == initialTextViewText
        {
            charactersCountLabel.text = NSLocalizedString("1,000 characters remaining", comment: "")
        }
        else if 1000 - textView.text.count == 1
        {
            charactersCountLabel.text = NSLocalizedString("1 character remaining", comment: "")
        }
        else
        {
            charactersCountLabel.text = "\(1000 - textView.text.count) \(NSLocalizedString("characters remaining", comment: ""))"
        }
        updateNextButton()
    }
}
