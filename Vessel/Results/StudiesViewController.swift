//
//  StudiesViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 10/18/22.
//

import UIKit

class StudiesViewController: UIViewController, SourceInfoViewDelegate
{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var studiesStackView: UIStackView!
    
    var reagentID: Reagent.ID!
    var goalID: Goal.ID!
    
    override func viewDidLoad()
    {
        let reagent = Reagents[reagentID]!
        let goal = Goals[goalID]!
        let title = "\(reagent.name.capitalized) & \(goal.name.capitalized)"
        titleLabel.text = title
        super.viewDidLoad()
        
        studiesStackView.removeAllArrangedSubviews()
        let sources = reagent.sources(for: goalID)
        for source in sources
        {
            let infoView = SourceInfoView(content: source.text, url: source.url)
            infoView.delegate = self
            studiesStackView.addArrangedSubview(infoView)
        }
    }
    
    @IBAction func back()
    {
        navigationController?.popViewController(animated: true)
    }
    
    func moreButtonPressed(url: String)
    {
        openInSafari(url: url)
    }
}
