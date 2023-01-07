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
    
    var type: CheckMarkCardType?
    
    func setup(backgroundImage: String)
    {
        backgroundImageView.image = UIImage(named: backgroundImage)
    }
}
