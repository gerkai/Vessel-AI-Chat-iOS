//
//  DebugMenuCell.swift
//  Vessel
//
//  Created by Nicolas Medina on 8/23/22.
//

import UIKit

protocol DebugMenuCellDelegate: AnyObject
{
    func onToggle(_ value: Bool, tag: Int)
}

class DebugMenuCell: UITableViewCell
{
    // MARK: - View
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet weak var switchToggle: UISwitch!
    private var delegate: DebugMenuCellDelegate?
    
    // MARK: - Methods
    func setup(title: String, turnedOn: Bool, delegate: DebugMenuCellDelegate)
    {
        titleLabel.text = title
        switchToggle.isOn = turnedOn
        self.delegate = delegate
    }
    
    // MARK: - Actions
    @IBAction func onSwitchToggle()
    {
        delegate?.onToggle(switchToggle.isOn, tag: tag)
    }
}
