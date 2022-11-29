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
    @IBOutlet private weak var contentTitleLabel: UILabel!
    @IBOutlet private weak var contentTextLabel: UILabel!
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var charactersCountLabel: UILabel!
    
    private var initialTextViewText: String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        setupUI()
    }
    
    // MARK: - Actions
    
    @IBAction func onBack()
    {
        coordinator.back()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onNext()
    {
        coordinator.answerStep(answer: textView.text ?? "", answerId: 0)
        if let viewController = coordinator?.getNextStepViewController()
        {
            navigationController?.pushViewController(viewController, animated: true)
        }
        else
        {
            print("LESSON FINISHED")
        }
    }
}

private extension InputLessonStepViewController
{
    func setupUI()
    {
        titleLabel.text = viewModel.lesson.title
        // TODO: Uncomment when placeholder_text issue is fixed on the Backend
//        textView.text = viewModel.step.placeholderText
//        initialTextViewText = viewModel.step.placeholderText
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
        contentTextLabel.text = viewModel.step.text
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
    }
}
