//
//  TodayTextCell.swift
//  Vessel
//
//  Created by Nicolas Medina on 11/30/22.
//

import UIKit

class TodayTextCell: UITableViewCell
{
    @IBOutlet private weak var titleLabel: UILabel!
    
    func setup(text: String, alignment: NSTextAlignment)
    {
        titleLabel.text = text
        titleLabel.textAlignment = alignment
    }
}
