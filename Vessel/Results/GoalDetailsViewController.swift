//
//  GoalDetailsViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 10/21/22.
//

import UIKit

class GoalDetailsViewController: UIViewController
{
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var headerSubtextLabel: UILabel!
    
    var goal: Goal!
    var viewModel: ResultsTabViewModel!
    
    static func initWith(goal: Goal.ID, viewModel: ResultsTabViewModel) -> GoalDetailsViewController
    {
        let storyboard = UIStoryboard(name: "Results", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "GoalDetailsViewController") as! GoalDetailsViewController
        
        vc.goal = Goals[goal]!
        vc.viewModel = viewModel
        
        return vc
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        headerImageView.image = UIImage(named: goal.largeImageName)
        headerTitleLabel.text = goal.name.capitalized
        headerSubtextLabel.text = goal.headerText
    }
    
    @IBAction func back()
    {
        viewModel = nil
        navigationController?.popViewController(animated: true)
    }
}
