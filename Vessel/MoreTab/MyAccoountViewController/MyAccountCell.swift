//
//  MyAccountCell.swift
//  Vessel
//
//  Created by Nicolas Medina on 7/27/22.
//

import UIKit

class MyAccountCell: UITableViewCell
{
    @IBOutlet private weak var label: UILabel!
    
    func setup(title: String)
    {
        label.text = title
    }
}
