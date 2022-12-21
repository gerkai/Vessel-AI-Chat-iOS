//
//  GamificationCongratulationsDayView.swift
//  Vessel
//
//  Created by Nicolas Medina on 12/20/22.
//

import UIKit

class GamificationCongratulationsDayView: UIStackView
{
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    func setup(text: String, complete: Bool)
    {
        imageView.image = complete ? UIImage(named: "checkbox_squared_selected") : UIImage(named: "checkbox_squared_background")
        label.text = text
    }
}
