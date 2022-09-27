//
//  WellnessScoreViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 9/24/22.
//

import UIKit

class WellnessScoreViewController: ResultsTabMVVMViewController
{
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var poorTileView: ReagentTileView!
    @IBOutlet weak var fairTileView: ReagentTileView!
    @IBOutlet weak var goodTileView: ReagentTileView!
    @IBOutlet weak var greatTileView: ReagentTileView!
    
    weak var viewmodel: ResultsTabViewModel!
    let scoreViewHeight = 78.0
    
    override func viewDidLoad()
    {
        let result = viewModel.result
        //stackView comes pre-populated with a single lineView. Remove it and add it back later.
        let lineView = stackView.arrangedSubviews[0]
        stackView.removeArrangedSubview(lineView)
        for reagentResult in result.reagents
        {
            let scoreView = ReagentScoreView()
            let heightConstraint = NSLayoutConstraint(item: scoreView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: scoreViewHeight)
            scoreView.addConstraints([heightConstraint])
            scoreView.score = reagentResult.score
            let reagent = Reagents[Reagent.ID(rawValue: reagentResult.id)!]!
            scoreView.nameLabel.text = reagent.name
            scoreView.imageView.image = UIImage(named: reagent.imageName)
            let evaluation = reagent.getEvaluation(score: reagentResult.value)
            scoreView.levelLabel.text = evaluation.title
            scoreView.contentView.backgroundColor = evaluation.color
            stackView.addArrangedSubview(scoreView)
        }
        //add the lineView back here
        stackView.addArrangedSubview(lineView)
        
        //add wellness score
        let scoreView = ReagentScoreView()
        let heightConstraint = NSLayoutConstraint(item: scoreView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: scoreViewHeight)
        scoreView.addConstraints([heightConstraint])
        scoreView.score = result.wellnessScore
        scoreView.nameLabel.text = NSLocalizedString("Wellness Score", comment: "")
        scoreView.contentView.backgroundColor = Constants.colorForScore(score: result.wellnessScore)
        scoreView.levelLabel.text = Constants.stringForScore(score: result.wellnessScore)
        stackView.addArrangedSubview(scoreView)
        //scoreView.imageView.contentMode = .scaleAspectFit
        scoreView.imageView.image = UIImage(named: "HappyWomanSquare")
        
        //populate wellness score ranges
        poorTileView.contentView.backgroundColor = Constants.vesselPoor
        poorTileView.titleLabel.text = NSLocalizedString("0-25", comment: "percentage range 0 - 25")
        poorTileView.subtextLabel.text = Constants.POOR_STRING
        
        fairTileView.contentView.backgroundColor = Constants.vesselFair
        fairTileView.titleLabel.text = NSLocalizedString("25-50", comment: "percentage range 25 - 50")
        fairTileView.subtextLabel.text = Constants.FAIR_STRING
        
        goodTileView.contentView.backgroundColor = Constants.vesselGood
        goodTileView.titleLabel.text = NSLocalizedString("50-75", comment: "percentage range 50 - 75")
        goodTileView.subtextLabel.text = Constants.GOOD_STRING
        
        greatTileView.contentView.backgroundColor = Constants.vesselGreat
        greatTileView.titleLabel.text = NSLocalizedString("75-100", comment: "percentage range 75 - 100")
        greatTileView.subtextLabel.text = Constants.GREAT_STRING
    }
    
    @IBAction func back()
    {
        navigationController?.popViewController(animated: true)
    }
}
