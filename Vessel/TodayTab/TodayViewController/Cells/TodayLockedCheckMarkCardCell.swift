//
//  TodayLockedCheckMarkCardCell.swift
//  Vessel
//
//  Created by Nicolas Medina on 1/7/22.
//

import UIKit

class TodayLockedCheckMarkCardCell: UITableViewCell
{
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtextLabel: UILabel!
    
    var type: CheckMarkCardType?
    
    func setup(backgroundImage: String, title: String, subtext: String)
    {
        backgroundImageView.image = UIImage(named: backgroundImage)
        titleLabel.text = title
        subtextLabel.text = subtext
    }
}
