//
//  TodaySectionTitleTableViewCell.swift
//  Vessel
//
//  Created by Nicolas Medina on 9/27/22.
//

import UIKit

class TodaySectionTitleTableViewCell: UITableViewCell
{
    // MARK: - UI
    @IBOutlet private weak var icon: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var infoIcon: UIImageView!
    
    // MARK: - Method
    func setup(iconName: String, title: String, showInfoIcon: Bool)
    {
        if let image = UIImage(named: iconName)
        {
            icon.image = image
        }
        titleLabel.text = title
        infoIcon.isHidden = !showInfoIcon
    }
}
