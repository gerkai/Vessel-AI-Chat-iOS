//
//  TodayFooterTableViewCell.swift
//  Vessel
//
//  Created by Nicolas Medina on 9/27/22.
//

import UIKit

class TodayFooterTableViewCell: UITableViewCell
{
    // MARK: - UI
    @IBOutlet weak var vesselIcon: UIImageView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        vesselIcon.image = vesselIcon.image?.withRenderingMode(.alwaysTemplate)
        vesselIcon.tintColor = .white
    }
}
