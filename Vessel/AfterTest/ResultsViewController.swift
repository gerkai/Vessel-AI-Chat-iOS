//
//  ResultsViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 7/24/22.
//

import UIKit

class ResultsViewController: UIViewController
{
    @IBOutlet weak var wellnessScoreLabel: UILabel!
    var wellnessScore: Double!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        wellnessScoreLabel.text = "Wellness Score: \(wellnessScore ?? 0.0)"
    }
    
    @IBAction func done()
    {
        //navigationController?.popToRootViewController(animated: true)
        dismiss(animated: true)
    }
}
