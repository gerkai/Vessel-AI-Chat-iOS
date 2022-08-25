//
//  ChangePasswordCell.swift
//  Vessel
//
//  Created by Nicolas Medina on 8/9/22.
//

import UIKit

class ChangePasswordCell: UITableViewCell
{
    @IBOutlet private weak var textField: VesselTextField!
    
    func setup(placeholder: String)
    {
        textField.placeholder = placeholder
    }
    
    func text() -> String?
    {
        return textField.text
    }
}
