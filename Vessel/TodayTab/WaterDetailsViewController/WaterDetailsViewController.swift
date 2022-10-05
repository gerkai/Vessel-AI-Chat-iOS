//
//  WaterDetailsViewController.swift
//  Vessel
//
//  Created by Nicolas Medina on 10/1/22.
//

import UIKit

class WaterDetailsViewController: UIViewController
{
    // MARK: - Views
    @IBOutlet private weak var glassesStackView: UIStackView!
    
    // MARK: - Model
    var drinkedWaterGlasses: Int?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if let drinkedWaterGlasses = drinkedWaterGlasses
        {
            for (i, glassView) in glassesStackView.arrangedSubviews.enumerated()
            {
                if let glass = glassView as? UIImageView,
                   i < drinkedWaterGlasses
                {
                    glass.image = UIImage(named: "water-glass-empty")
                }
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func onBack()
    {
        navigationController?.popViewController(animated: true)
    }
}
