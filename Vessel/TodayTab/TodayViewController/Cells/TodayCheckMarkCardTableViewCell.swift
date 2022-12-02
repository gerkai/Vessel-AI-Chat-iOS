//
//  TodayCheckMarkCardTableViewCell.swift
//  Vessel
//
//  Created by Nicolas Medina on 9/27/22.
//

import UIKit

class TodayCheckMarkCardTableViewCell: UITableViewCell
{
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var checkMark: UIImageView!
    
    func setup(title: String, subtitle: String, description: String?, backgroundImage: String, completed: Bool)
    {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        if let description = description
        {
            descriptionLabel?.text = description
        }
        checkMark.image = completed ? UIImage(named: "Checkbox_beige_selected") : UIImage(named: "Checkbox_beige_unselected")
        guard let url = URL(string: backgroundImage) else { return }
        backgroundImageView.kf.setImage(with: url)
    }
}
