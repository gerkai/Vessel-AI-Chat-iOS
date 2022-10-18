//
//  ReagentFoodTableViewCell.swift
//  Vessel
//
//  Created by Nicolas Medina on 10/12/22.
//

import UIKit
import Kingfisher

class ReagentFoodTableViewCell: UITableViewCell
{
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var checkmarkView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
 
    func setup(foodName: String, isChecked: Bool, backgroundImageURL: URL)
    {
        titleLabel.text = foodName
        checkmarkView.image = UIImage(named: isChecked ? "Checkbox_beige_selected" : "Checkbox_beige_unselected")
        backgroundImageView.kf.setImage(with: backgroundImageURL)
    }
}
