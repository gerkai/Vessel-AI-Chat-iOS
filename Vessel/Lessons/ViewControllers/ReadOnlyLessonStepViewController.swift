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
        coordinator.answerStep(answer: "", answerId: 0)
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

private extension ReadOnlyLessonStepViewController
{
    func setupUI()
    {
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
        contentTextLabel.text = viewModel.step.text
    }
}
