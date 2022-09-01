//
//  OnboardingFinalViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 7/10/22.
//

import UIKit

class OnboardingFinalViewController: UIViewController
{
    // MARK: - Views
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Logic
    var mainGoal: Int?
    var coordinator: OnboardingCoordinator?
        
    // MARK: - ViewController Lifecycle
    override func viewDidLoad()
    {
        titleLabel.text = finalScreenText()
        
        print("📗 did load \(self)")
    }
    
    deinit
    {
        print("📘 deinit \(self)")
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        // TODO: Add analytics for viewed page
    }
    
    // MARK: - Actions
    @IBAction func onBackTapped()
    {
        coordinator?.backup()
    }
    
    @IBAction func onNextTapped()
    {
        coordinator?.pushNextViewController()
    }
    
    // MARK: - Logic
    private func finalScreenText() -> String
    {
        if let mainGoalInt = mainGoal,
           let mainGoal = Goal.ID(rawValue: mainGoalInt),
           let goal = Goals[mainGoal]
        {
            let text = String(format: NSLocalizedString("We've designed %@ program personalized to your lifestyle.", comment: ""), goal.nameWithArticle)
            return text
        }
        //should never get here
        return ""
    }
}
