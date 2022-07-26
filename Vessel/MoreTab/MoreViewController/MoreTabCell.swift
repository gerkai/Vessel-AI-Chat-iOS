//
//  MoreTabCell.swift
//  Vessel
//
//  Created by Nicolas Medina on 7/26/22.
//

import UIKit

class MoreTabCell: UITableViewCell
{
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var iconView: UIImageView!
    
    func setup(title: String, iconName: String)
    {
        titleLabel.text = title
        iconView.image = UIImage(named: iconName)
    }
}
