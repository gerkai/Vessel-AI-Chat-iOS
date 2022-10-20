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
    
    static func initWith(reagentID: Reagent.ID, goalID: Goal.ID) -> StudiesViewController
    {
        let storyboard = UIStoryboard(name: "Results", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "StudiesViewController") as! StudiesViewController
        vc.goalID = goalID
        vc.reagentID = reagentID
        return vc
    }
    
    override func viewDidLoad()
    {
        if UserDefaults.standard.bool(forKey: Constants.KEY_PRINT_INIT_DEINIT)
        {
            print("📗 did load \(self)")
        }
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
    
    deinit
    {
        if UserDefaults.standard.bool(forKey: Constants.KEY_PRINT_INIT_DEINIT)
        {
            print("📘 deinit \(self)")
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
